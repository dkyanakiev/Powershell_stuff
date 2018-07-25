function Find-BuildAllBuildsInQueueByParameters{
  param(
    [string]$buildName,
    $buildParameters
  )
  $oldErrorPreference = $ErrorActionPreference # = "Stop"
  $ErrorActionPreference = "Continue"
  $request =  Get-WebRequest -Method "GET" -URI "https://jenkinsURL/queue/api/xml?tree=items[why,actions[parameters[name,value]],task[name],id]"
  $xml = [xml]$request.Content

  $buildsInQueue = @{}

  foreach($item in $xml.queue.item){
     if($item.task.name -eq $buildName){
          $matchingParameters = @()

          foreach ($paramFromXml in $item.action.parameter){
              if($buildParameters.keys -contains $paramFromXml.name){
                  $matchingParameters += $buildParameters[$paramFromXml.name] -eq $paramFromXml.value
              }
          }

          if ($matchingParameters.Count -ne 0 -and $matchingParameters -notcontains $false){
              $buildsInQueue[$item.id] = $item.why
          }
     }
  }

  $ErrorActionPreference  = "Stop"
  return $buildsInQueue
}

#cls
