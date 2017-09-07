function Get-CoverageTest-Names{
          param(
              [array]$testlist
          )
$runTestId = @()
$testNames = @()
#$testarray = @{}
foreach($test in $testlist)
{

    $r = Invoke-WebRequest -Method "GET" -Uri "https://jenkinsURL:8081/coverage/$($test)"
    $content = ConvertFrom-Json $r
    Write-host $content


    if($content.status -eq "" -and $runTestId.Count -lt "100" -and $content.status -ne "RUNNING")
    {

        $runTestId += @($content._id)
      #  Update-CoverageTestsStatus -testId $test -status "RESERVED"
        $testNames += @($content.test_name)

    }

    if($content.status -ne "" -and $runTestId.Count -lt "100" -and $content.status -notlike "RESERVED*")
    {
      #Write-host "TEST ID: " $content._id
      if($content.finish_time -ne $null){
        $enddate = $content.finish_time
        $startDate = $content.start_time
      }else{

        $enddate = (Get-Date).ToString()}
    $TimeDiff = New-TimeSpan -Start $startDate -End $enddate
        if($TimeDiff.Days -gt 5){
            Write-host "Older than 10 days"
             $runTestId += @($content._id)
             $testNames += @($content.test_name)

        }

    }

}
    Write-host "inside get list"
    Write-host $runTestId
    Write-host $testNames
    return $runTestId,$testNames

}
