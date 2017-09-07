function Get-DependentTestsForDir(){
  param(
        [string]$dbUrl,
        [string]$database,
        [string]$buildId,
        [string]$dependent_dir,
        [string]$node
    )

    $dependentTests = @()
    $node = $node.Replace("`n", "").replace("`r", "")
    $allTests = Get-AreDependentTests -dbUrl $dbUrl -database $database -buildId $buildId

    foreach ($currentTest in $allTests){
        $testUrl = "$($dbUrl)/$($database)/$($currentTest.id)"

        $r = Invoke-WebRequest -Method Get -Uri $testUrl
        $response = ConvertFrom-Json $r.content

        if (($response.node -eq "") -and ($response.are_dependent -eq $dependent_dir)) {
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
                    $dependentTests += $response.test
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
    
    Write-Host "================================================"
    $dependentTests
    Write-Host "================================================"
    return $dependentTests
}