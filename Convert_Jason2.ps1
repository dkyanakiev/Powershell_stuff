function ParseItem()
{
  param(
    $results
  )

    if($results.PSObject.TypeNames -match 'Array')
    {
        return ParseJsonArray($results)
    }
    elseif($results.PSObject.TypeNames -match 'Dictionary')
    {
        return ParseJsonObject([HashTable]$results)
    }
    else
    {
        return $results
    }
}

function ParseJsonObject($jsonObj)
{
    $result = New-Object -TypeName PSCustomObject
    foreach ($key in $jsonObj.Keys)
    {
        $item = $jsonObj[$key]
        if ($item)
        {
            $parsedItem = ParseItem $item
        }
        else
        {
            $parsedItem = $null
        }
        $result | Add-Member -MemberType NoteProperty -Name $key -Value $parsedItem
    }
    return $result
}

function ParseJsonArray($jsonArray)
{
    $result = @()
    $jsonArray | ForEach-Object -Process {
        $result += , (ParseItem $_)
    }
    return $result
}

function ParseJsonString($json)
{
    $config = $javaScriptSerializer.DeserializeObject($json)
    return ParseJsonObject($config)
}
