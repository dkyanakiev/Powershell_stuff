function Get-TestListForRevision(){
    param(
        [string]$revision,
        [string]$dbUrl,
        [string]$dbName
    )

    $fullUrl = "$($dbUrl)/$($dbName)/_design/test/_view/sort_by_revision?keys=[`"$revision`"]"
    Write-Host "Checking URL: $fullUrl"

    $response = Invoke-WebRequest -Method Get -Uri $fullUrl
    $parsedResponse = ConvertFrom-Json $response.Content
    
    try{
      $converted = Convert-TestsToHash -inputObject $parsedResponse.rows.value
      return $converted.values
    } catch {
        return $null
    }
}

#cls
#$a = Get-TestListForRevision -revision "683645" -dbUrl "http://jenkinsURLcom:8081/" -dbName "tests_for_revision"
#
#$a = Get-TestListForRevision -revision "683686" -dbUrl "http://jenkinsURLcom:8081/" -dbName "tests_for_revision"
#$a -eq $null