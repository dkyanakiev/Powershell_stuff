
function Check-IfLastNodeSpecificBuildWasSuccessful{
    param(
      [string]$node,
      [string]$jenkinsJob
    )

    $url = "https://JENKINSURL/job/$jenkinsJob/api/xml?tree=builds[builtOn,result,number,id,timestamp,building]"
    write-host "Checking build $jenkinsJob $node - $url"
    $request =  Get-WebRequest -Method "GET" -URI $url
    $xml = [xml]$request.Content

    foreach ($build in $xml.freeStyleProject.build){

        if($node -eq $build.builtOn -and $build.building -eq $false){
           write-host "Found $jenkinsJob - $($build | out-string )"
           if($build.result -eq "SUCCESS"){
                Write-Host "Build was successful"
                return $true
           } else {
                Write-Host "Build was not successful"
                return $false
           }
        }
    }

    write-host "Build was not found, returning NULL"
    return $null
}

# cls
# $a = Check-IfLastNodeSpecificBuildWasSuccessful -node $(hostname) -jenkinsJob Deploy_To_Node
# $a
