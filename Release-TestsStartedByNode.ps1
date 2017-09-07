
function Release-TestsStartedByNode{
    param(
        [string]$node,
        [string]$build_id
    )

    $request = Invoke-WebRequest -Method Get -Uri "https://jenkinsURL:8081/reserved_tests/_design/tests/_view/started?keys=[`"$build_id`"]&include_docs=true"

    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")
    $jsonserial= New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer
    $jsonserial.MaxJsonLength  = 67108864
    $json = $jsonserial.DeserializeObject($request.content)

    $bulk_doc = @{"docs" = @()}

    foreach ($row in $json.rows){

        if($row.doc.node -eq $node){
            $row.doc.node = ""
            $row.doc.status = ""
            $row.doc.result = ""
            $row.doc.rerun_result = ""
            $row.doc.start_time = ""
            $row.doc.finish_time = ""
            $row.doc.build_url = ""
            $bulk_doc["docs"] += $row.doc
        }
    }

    Write-Host "Found $($bulk_doc["docs"].Count) tests to be released into the wild"

    if ($bulk_doc["docs"].Count -gt 0){

       $r = Invoke-WebRequest -Method Post -ContentType "application/json" -Uri "https://jenkinsURL:8081/reserved_tests/_bulk_docs"  -Body (ConvertTo-Json $bulk_doc)
       $response = ConvertFrom-Json $r.Content

       $response | %{

       Write-Host $_.id + " - " + $_.ok

    }

    }

}
