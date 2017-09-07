function Get-SuiteName(){
    param([string]$testName)


    if (-not $testName.StartsWith("\")){
        $testName = "\" + $testName
    }

    return $testName.split("\")[1]
}