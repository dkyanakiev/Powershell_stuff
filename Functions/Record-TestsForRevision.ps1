
function Record-TestsForRevision(){
    param(
        [string]$revision,
        [string]$dbUrl,
        [string]$dbName,
        [string]$outputFile,
        $tests
    )

    $jsonObject = @{"sorted_tests" = $tests}

    $jsonObject["svn_revision"] = $revision


    $response = Invoke-WebRequest -Method Post -Uri "$($dbUrl)/$($dbName)" -Body (ConvertTo-Json $jsonObject) -ContentType "application/json"

    $parsedResponse = ConvertFrom-Json $response.Content

    if ($parsedResponse.ok -eq $true){
        $url = "$($dbUrl)/$($dbName)/$($parsedResponse.id)"
        "TEST_DB_LINK=`"$url`"" | Out-File -Encoding default -FilePath $outputFile
        Write-Host "Tests recorded with ID: $($parsedResponse.id)  $url"
        return $true
    }

    Write-Host "Error occured recording tests"
    Write-Host $parsedResponse
    return $false
}

#cls
