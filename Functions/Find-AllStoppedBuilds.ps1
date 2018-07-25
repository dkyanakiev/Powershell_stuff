
function Find-AllStoppedBuilds{
    param([string]$buildName)


    $request = Get-WebRequest -Method GET -URI "https://jenkinsURL/job/$buildName/api/xml?tree=builds[number,result,building]"
    $xml = [xml]$request.Content

    $stoppedBuilds = @()

    $xml.freeStyleProject.build | %{
        
        if($_.building -ne $null -and $_.building.toUpper() -eq "FALSE"){
            $stoppedBuilds += $_.number
        }

    }

    Write-Host "Found Stopped bulds: $($stoppedBuilds -join ',')"
    return $stoppedBuilds

}


#cls
#$a = Find-AllStoppedBuilds -buildName "TestBuildOpt"