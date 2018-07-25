
function Abort-JenkinsBuild{
    param(
        [string]$buildName,
        [string]$buildId
    )
    Write-Host "Aborting $buildName $buildId"
    $r = Get-WebRequest -Method POST -Body "" -URI "https://URL/job/$buildName/$buildId/stop"

    Write-Host $r.statuscode


    if($r.statuscode -eq 200){
        return $true
    } else {
        return $false
    }

}

#Abort-JenkinsBuild -buildName build-delete -buildId lastBuild
