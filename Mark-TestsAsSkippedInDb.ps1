
function Mark-TestsAsSkippedInDb(){
    param(
        [string]$buildId,
        [string]$dbUrl,
        [string]$dbName,
        [int]$testsToLeave = 0
    )

    $allTests = Get-UnreservedTests -dbUrl $dbUrl -database $dbName -buildId $buildId -returnLimit -1


    Write-Host "Total unreserved tests $($allTests.length)"

    for ($i = 0; $i -le ($allTests.length - $testsToLeave); $i++){
        Update-TestStatusById -dbUrl $dbUrl `
                              -dbName $dbName `
                              -testId $allTests[$i].id `
                              -node $(hostname) `
                              -status "Skipped"
    }

    Write-Host $allTests
}
