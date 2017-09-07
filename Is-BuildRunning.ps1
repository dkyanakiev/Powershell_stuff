

function Is-BuildRunning(){
    param(
        $buildName
    )

    $request = Get-WebRequest -Method GET -URI "https://jenkinsURL/job/$buildName/lastBuild/api/xml"
    $xml = [xml]$request.Content

    if ($xml.freeStyleBuild.building -eq $true){
        Write-Host -ForegroundColor Cyan "$buildName is currently building"
        return $true
    }

    $request = Get-WebRequest -Method GET -URI "https://jenkinsURL/job/$buildName/api/xml"
    $xml = [xml]$request.Content


    if ($xml.freeStyleProject.inQueue -eq $true){
        Write-Host -ForegroundColor Cyan "$buildName is currently in Queue"
        return $true
    }

    return $false
}
