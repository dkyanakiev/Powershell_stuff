
function Get-ArtifactURL{
    param(
        [string]$buildName = "AcceptanceTests",
        [string]$buildNumber = "lastStableBuild",
        [string]$stack
    )
    $base_url = "https://jenkinsURL/job"

    Write-Host "Looking for artifact for stack: $stack in build $buildName for build number $buildName"
    $request =  Get-WebRequest -Method "GET" -URI "$base_url/$buildName/$buildNumber/api/xml"
    $xml = [xml]$request.Content

    $returnUrl = $null

    foreach ($artifact in $xml.freeStyleBuild.artifact){

        if($artifact.fileName.ToLower().replace(".zip", "") -eq $stack.ToLower()){
            $returnUrl = "$base_url/$buildName/$buildNumber/artifact/$($artifact.fileName)"
            Write-Host "Found $returnUrl"
            break
        }
    }

    return $returnUrl
}

# cls
