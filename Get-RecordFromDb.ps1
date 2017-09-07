
function Get-RecordFromDb(){
    param(
        [string]$revision,
        [string]$dbUrl,
        [string]$dbName,
        [string]$recordId
    )


    $response = Invoke-WebRequest -Method Get -Uri "$($dbUrl)/$($dbName)/$($recordId)"

    return $response.Content
}

#cls
