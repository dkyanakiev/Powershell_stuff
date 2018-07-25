
function Get-AllRecordsForDb(){
    param (
        [string]$revision,
        [string]$dbUrl,
        [string]$dbName
    )

    $response = Invoke-WebRequest -Method Get -Uri "$($dbUrl)/$($dbName)/_all_docs"

    return $response.Content
}
