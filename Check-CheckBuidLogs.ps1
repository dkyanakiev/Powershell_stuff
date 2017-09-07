function Check-CheckBuidLogs{
    $viewUrl = "https://JenkinsURL/view/BULD/api/xml"
    Write-Host "Checking all of the builds in view $viewUrl"
    Write-Host "============================================"

    $request =  Get-WebRequest -Method "GET" -URI $viewUrl
    $xml = [xml]$request.Content

    $crashedJobs = @()
    foreach($job in $xml.listView.job){
        Write-Host "Checking $($job.url | Out-String )"
        $didTheNodeFail = Did-NodeDieDuringBuild -buildURL $job.url -buildNumber "lastBuild"

        if ($didTheNodeFail -eq $true){
            $crashedJobs += $job.url
            Write-HOst "Node crash detected"
        }

    }

    if ($crashedJobs.count -ne 0){
       Write-HOst -ForegroundColor Red "Following builds failed with a node crash"
       write-host -ForegroundColor Red ($crashedJobs -join "`r`n" )
       exit 1
    }


}
