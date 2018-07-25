

function Get-TimeInQueue{
    param(
        $searchParameters,
        $buildName
    )

    $request =  Get-WebRequest -Method "GET" -URI "https://jenkinsURL/queue/api/xml?tree=items[why,actions[parameters[name,value]],task[name],inQueueSince]"
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
                
                return $item.inQueueSince
            }
       }
    }


}