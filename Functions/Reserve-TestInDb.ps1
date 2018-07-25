
function Reserve-TestInDb(){
    param(
        [string]$dbUrl,
        [string]$database,
        [string]$buildId,
        [string]$node,
        $mdb_flag

    )

    $node = $node.Replace("`n", "").replace("`r", "")


    if($mdb_flag -ne $null -and $mdb_flag.toLower() -eq "true")
    {
      $allTests = Get-UnreservedTestsMDB -dbUrl $dbUrl -database $database -buildId $buildId
    }
    else{
      $allTests = Get-UnreservedTests -dbUrl $dbUrl -database $database -buildId $buildId
    }

    foreach ($currentTest in $allTests){
        $testUrl = "$($dbUrl)/$($database)/$($currentTest.id)"

        $r = Invoke-WebRequest -Method Get -Uri $testUrl
        $response = ConvertFrom-Json $r.content

        if ($response.node -eq ""){
            Write-Host "Attempting to reserve $currentTest"

            Print-TestStatusSummary -dbUrl $dbUrl `
                                    -dbName $database `
                                    -buildId $buildId


            $response.node = $node
            try{
                $updateR = Invoke-WebRequest -Method Put -Uri $testUrl -Body (ConvertTo-Json $response)
            } catch {
                $exception = $_.Exception.response
            }

            if ($updateR -ne $null){
                $updateResponse = ConvertFrom-Json $updateR.Content

                if ($updateResponse.ok -eq $true){
                    write-host -ForegroundColor Green "Successfully reserved $($response.test) for build $($currentTest.key) DB Id: $($response._id)"
                    $returnTest = $currentTest.key
                    return $response.test
                } else {
                    Write-Host -ForegroundColor Yellow "Reservation failed, trying next"
                    Write-Host -ForegroundColor Yellow $updateResponse
                }
            } else {
                Write-Host -ForegroundColor Yellow "Reservation failed, trying next"
                Write-Host -ForegroundColor Yellow $exception
            }
        }

    }

    return ""
}

#cls
