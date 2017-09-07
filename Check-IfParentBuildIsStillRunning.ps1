
function Check-IfParentBuildIsStillRunning{
 param(
   [string]$jobName,
   [string]$buildNumber
 )

    Write-Host "Checking if $jobName build $buildNumber is still running"
    $request =  Get-WebRequest -Method "GET" -URI "https://jenkinsURL/job/$jobName/$buildNumber/api/xml?tree=building"
    $xml = [xml]$request.Content

    Write-Host "Running: $($xml.freeStyleBuild.building)"
    return $xml.freeStyleBuild.building
}

# cls
# $a = Check-IfParentBuildIsStillRunning -jobName "BuildOne" -buildNumber 182
#
# $a
# $b
