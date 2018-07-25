

function Mark-AllNotFinishedTestsAsSkipped{
    param([string]$build_id)
    
     $request = Invoke-WebRequest -Method Get -Uri "https://jenkinsURL:8081/reserved_tests/_design/tests/_view/all?keys=[%22$build_id%22]&include_docs=true"
    
    
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")        
    $jsonserial= New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer 
    $jsonserial.MaxJsonLength  = 67108864
    $json = $jsonserial.DeserializeObject($request.content)


    $bulk_doc = @{"docs" = @()}
    foreach ($row in $json.rows){
        
        if($row.doc.status -ne "Finished"){
            Write-Host ($row.doc._id | Out-String)

            $row.doc.status = "Skipped"
            $bulk_doc["docs"] += $row.doc
        }
    }

    Write-Host "Total documents to skip $($bulk_doc["docs"].Count)"

    $r = Invoke-WebRequest -Method Post -ContentType "application/json" -Uri "https://jenkinsURL:8081/reserved_tests/_bulk_docs"  -Body (ConvertTo-Json $bulk_doc)
    $response = ConvertFrom-Json $r.Content

    $response | %{
        
        Write-Host "$($_.id) - $($_.ok)"
    
    }
}


#cls
#Mark-AllNotFinishedTestsAsSkipped -build_id "jenkins-TestBuildOpt-226"