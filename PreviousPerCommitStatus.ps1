function PreviousPerCommitStatus{
    param(
        [switch]$verbose
    )

    $lastbuildUrl = "https://jenkinsURL/job/PerCommitHSMainBuild/lastCompletedBuild/api/xml"
    Write-host "Checking URL: " $lastbuildUrl

    $request = Get-WebRequest -URI $lastbuildUrl
    if($verbose -eq $true){
        Write-host "Request :  " $request
    }
    
    $xml = [xml]$request.Content
    $results = $xml.freeStyleBuild.result
    if($verbose -eq $true){
        Write-host "Result for previous build: "
        Write-Host $($results | Out-String)
    }

    return $results
}
