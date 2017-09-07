
function Get-TestsNotStartedInDb{
    $ErrorActionPreference = "SilentlyContinue"

    $request = Invoke-WebRequest -Method Get -Uri https://jenkinsURL:8081/reserved_tests/_design/tests/_view/not_started
    
    
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")        
    $jsonserial= New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer 
    $jsonserial.MaxJsonLength  = 67108864
    $json = $jsonserial.DeserializeObject($request.content)
    

    foreach ($row in $json.rows){

        write-host ($row | out-string)
        $jobName = $row["key"].split("-")[1]
        $buildNumber = $row["key"].split("-")[2]

        
        $request = Get-WebRequest -Method get -URI "https://jenkinsURL/job/$jobName/$buildNumber/api/xml"
        
        if ($request -eq $null){
            Write-Host -ForegroundColor Yellow "Jenkins build $jobName $buildNumber no longer exists, marking record $($row['id']) as skipped"
            Update-TestStatusById -dbUrl "https://jenkinsURL:8081/" `
                              -dbName "reserved_tests" `
                              -testId $row['id'] `
                              -node $(hostname) `
                              -status "Skipped"

        } else {
            
            $xml = [xml]$request.Content
            if ($xml.freeStyleBuild.building -eq "false"){
                write-host "Jenkins build $jobName $buildNumber no longer running, marking record $($row['id']) as skipped"
                Update-TestStatusById -dbUrl "https://jenkinsURL:8081/" `
                              -dbName "reserved_tests" `
                              -testId $row['id'] `
                              -node $(hostname) `
                              -status "Skipped"
            }
        }
    }
}

#Get-TestsNotStartedInDb