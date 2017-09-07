function Get-CoverageTestNames(){
  param(
    $testlist
  )
  $runTestId = @()
  $testNames = @()
  #$testarray = @{}
  foreach($test in $testlist)
  {

      $r = Invoke-WebRequest -Method "GET" -Uri "https://jenkinsURL:8081/coverage/$($test.id)"
      $content = ConvertFrom-Json $r
      #Write-host $content

      if($content.status -eq "" -and $int -lt "101")
      {
          $int++
          $runTestId += @($content._id)
          $testNames += @($content.test_name)

          #Write-Host $int
      }

      if($int -eq 100)
      {
      Write-host "time to stop"
      #$retry = $false
      }

  }
      return $runTestId,$testNames
}
