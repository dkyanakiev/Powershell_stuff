
function Print-TestRunSummary{
    param(
        [string]$build_id
    )

    Write-Host "Looking up tests for $build_id"

    $summary = @{}

    $request = Invoke-WebRequest -Method Get -Uri "https://jenkinsURL:8081/reserved_tests/_design/tests/_view/passed?keys=[%22$build_id%22]&include_docs=true"
   
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")        
    $jsonserial= New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer 
    $jsonserial.MaxJsonLength  = 67108864
    $json = $jsonserial.DeserializeObject($request.content)

    $summary["passed"] = $json.rows.Count
    Write-Host "Passed: $($json.rows.Count)"



    $request = Invoke-WebRequest -Method Get -Uri "https://jenkinsURL:8081/reserved_tests/_design/tests/_view/failed?keys=[%22$build_id%22]&include_docs=true"
   
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")        
    $jsonserial= New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer 
    $jsonserial.MaxJsonLength  = 67108864
    $json = $jsonserial.DeserializeObject($request.content)

    $summary["failed"] = $json.rows.Count
    Write-Host "Failed: $($json.rows.Count)"



    $request = Invoke-WebRequest -Method Get -Uri "https://jenkinsURL:8081/reserved_tests/_design/tests/_view/skipped?keys=[%22$build_id%22]&include_docs=true"
   
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")        
    $jsonserial= New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer 
    $jsonserial.MaxJsonLength  = 67108864
    $json = $jsonserial.DeserializeObject($request.content)

    $summary["skipped"] = $json.rows.Count
    Write-Host "Skipped: $($json.rows.Count)"

    return $summary
}

# cls
# $a = Print-TestRunSummary -build_id "jenkins-TestBuildOpt-655"