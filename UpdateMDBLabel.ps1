function UpdateMDBLabel()
{
  param(
    [string]$nodeName,
    [string]$mdbLabel
  )

    Write-Host "https://jenkinsURL/computer/$nodeName/config.xml"
    $request = Get-WebRequest -URI "https://jenkinsURL/computer/$nodeName/config.xml"
    $xml = [xml]$request.Content
    $xml.slave.label = $mdbLabel
    $xmlString = $xml.OuterXml

    Write-host "Printing out the web request"
    Write-host $request

    Get-WebRequest -Method "POST" -URI "https://jenkinsURL/computer/$nodeName/config.xml" -Body $xmlString
}
