
function Is-NodeOffline{
    param(
        [string]$node
    )

    $request =  Get-WebRequest -Method "GET" -URI "https://jenkinsURL/computer/$node/api/xml"
    $xml = [xml]$request.Content

    return $xml.slaveComputer.offline -eq "true"
}

#cls
#$a = Is-NodeOffline -node FQDN
