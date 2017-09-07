
function Find-BuildAllBuildsByParameters{
  param(
      [string]$jobName,
      $buildParameters
  )
  $oldErrorPreference = $ErrorActionPreference # = "Stop"
  $ErrorActionPreference = "Continue"

  $request =  Get-WebRequest -Method "GET" -URI "https://jenkinsURL/job/$jobName/api/xml?tree=builds[actions[parameters[name,value]],builtOn,number,building]"
  $xml = [xml]$request.Content

  $builds = @()

  foreach ($currentBuild in $xml.freeStyleProject.build){
    $matchingParameters = @()

    foreach ($paramFromXml in $currentBuild.action.parameter){
        if($buildParameters.keys -contains $paramFromXml.name){
            $matchingParameters += $buildParameters[$paramFromXml.name] -eq $paramFromXml.value
        }
    }

    if ($matchingParameters.Count -ne 0 -and $matchingParameters -notcontains $false){
        $builds += $currentBuild.number
    }

  }


  $ErrorActionPreference  = "Stop"

  return $builds
}

#cls
