
function Is-BuildInQueue{
    param(
      [string]$buildName,
      $buildParameters
    )

    $request =  Get-WebRequest -Method "GET" -URI "https://jenkinsURL/queue/api/xml?tree=items[why,actions[parameters[name,value]],task[name]]"
    $xml = [xml]$request.Content

    foreach($item in $xml.queue.item){
       if($item.task.name -eq $buildName){
            $matchingParameters = @()

            foreach ($paramFromXml in $item.action.parameter){
                if($buildParameters.keys -contains $paramFromXml.name){
                    $matchingParameters += $buildParameters[$paramFromXml.name] -eq $paramFromXml.value
                }
            }

            if ($matchingParameters -notcontains $false){
                Write-Host "Found build in Queue Reason: '$($item.why | out-string)'"
                return $true
            }
       }
    }


    write-host "Item not found in Queue"
    return $false
}

# cls
