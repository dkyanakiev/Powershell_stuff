function Get-QueueItemById{
    param(
        [string]$id
    )

    $request =  Get-WebRequest -Method "GET" -URI "https://jenkinsURL/queue/api/xml"
    $xml = [xml]$request.Content

    foreach($item in $xml.queue.item){
        if($item.id -eq $id){
            return $item
        }
    }

    return $null
}

#cls
