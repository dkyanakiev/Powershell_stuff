function Node-Exists{
    param(
        [string]$nodeName
    )

    $request =  Get-WebRequest -Method "GET" -URI "https://jenkinsURL/computer/api/xml"
    $xml = [xml]$request.Content
    $nodeFound = $false
    $xml.computerSet.computer | %{
        if ($_.displayName.toLower() -eq $nodeName.ToLower()){
            $nodeFound = $true
        }
    }

    return $nodeFound
}

#cls
#$a = Node-Exists -nodeName TS01-QA-0703
#$b = Node-Exists -nodeName TS01-QA-070313212312