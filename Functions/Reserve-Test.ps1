

function Reserve-Test(){
    param(
        [Parameter(Mandatory=$true)]$build,
        [Parameter(Mandatory=$true)]$node
    )

    $storageLocation  = "\\testReserver"
    $allTestsXmlFile = Join-Path $storageLocation "$($build).xml"
    $reservedTestsFile = Join-Path $storageLocation "$($build)_reserved_$($node).xml"

    $allTests = Import-Clixml -Path $allTestsXmlFile

    if (-not (Test-Path $reservedTestsFile)){
        $reservedList = @("placeholder", "placeholder")
        $reservedList | Export-Clixml -Path $reservedTestsFile -Encoding Default
    }

    $keepLooking = $true
    $selectedTest = $null
    $sortedTests = $allTests | Sort-Object

    foreach ($t in $sortedTests){
       if($keepLooking){
           $allReservedTests = @()
           Get-ChildItem -Recurse "$($storageLocation)\$($build)_reserved_*" | where { $_.Extension -eq ".xml"} | %{
           $allReservedTests += Import-ReserveFile $_.FullName
           }

           if($allReservedTests.Contains($t)){
             #do nothing
           } else {
               $keepLooking = $false
               $reservedTests = Import-ReserveFile $reservedTestsFile
               $reservedTests += $t

               $reservedTests | Export-Clixml -Path $reservedTestsFile -Encoding Default
               $selectedTest = $t


           }
       }
    }

    return $selectedTest
}

# For testing
