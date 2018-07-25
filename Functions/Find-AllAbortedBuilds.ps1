
function Find-AllAbortedBuilds{
    param([string]$buildName)


    $request = Get-WebRequest -Method GET -URI "https://jenkinsURL/job/$buildName/api/xml?tree=builds[number,result]"
    $xml = [xml]$request.Content

    $abortedBuilds = @()

    $xml.freeStyleProject.build | %{
        
        if($_.result -ne $null -and $_.result.toUpper() -eq "ABORTED"){
            $abortedBuilds += $_.number
        }

    }

    Write-Host "Found Aborted bulds: $($abortedBuilds -join ',')"
    return $abortedBuilds

}


#cls
#$a = Find-AllAbortedBuilds -buildName "TestBuildOpt"