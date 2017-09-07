function Get-BuildStatus{
    param(
        [string]$jobName,
        [string]$buildId

    )

    write-host -NoNewline "Checking $jobName $buildId status: "

    $request =  Get-WebRequest -Method "GET" -URI "https://jenkinsURL/job/$jobName/$buildId/api/xml?tree=building,result"
    $xml = [xml]$request.Content

    if ($xml.freeStyleBuild.building -eq "true"){
        Write-Host "Building"
        return "BUILDING"
    } else {
        Write-Host $xml.freeStyleBuild.result
        return $xml.freeStyleBuild.result
    }

}

#cls
#Get-BuildStatus -jobName Reset_Node -buildId 12874