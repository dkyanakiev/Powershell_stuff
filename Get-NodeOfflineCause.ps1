﻿
function Get-NodeOfflineCause{
    param(
        [string]$node
    )

    $request =  Get-WebRequest -Method "GET" -URI "https://jenkinsURL/computer/$node/api/xml"
    $xml = [xml]$request.Content

    return $xml.slaveComputer.offlineCauseReason
}
