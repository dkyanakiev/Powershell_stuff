
function Update-CoverageTestsStatus(){
    param(
        [string]$dbUrl = "https://jenkinsURL:8081/coverage",
        [string]$testId,
        [string]$status,
        [string]$start_time,
        [string]$finish_time
    )

    if (($testId -eq $null) -or ($testId -eq "")){
      write-host "No build id providing skipping"
      return $true
    }
    $recordUrl = "$($dbUrl)/$($testId)"

    write-host "Attempting to update build $testId"

  #  $testName = $testName.ToLower().replace("c:\dir\", "")
    $r = Invoke-WebRequest -Method Get -Uri $recordUrl

    $parsedJson = ConvertFrom-Json $r.content
    $parsedJson.status = $status
    if($start_time -ne ""){
      $parsedJson.start_time = $start_time
    }
    if($finish_time -ne "")
    {
      $parsedJson.finish_time = $finish_time
    }
    $newJson = ConvertTo-Json $parsedJson

        write-host ($newJson |  Out-String)

        try{
          $updateResult = Invoke-WebRequest -Method Put -ContentType "application/json" -Uri $recordUrl -Body $newJson
        } catch {
          $exception = $_.Exception.response
        }

        if ($updateResult -ne $null) {
          $updateJson = ConvertFrom-Json $updateResult.content

          if ($updateJson.ok -eq $true){
              Write-Host -ForegroundColor Green "Successfully updated $recordUrl"
              return $true
          } else {
              Write-Host -ForegroundColor Red "Failed to update (inner failures) $recordUrl"
              Write-Host -ForegroundColor Red $updateResult
              return $false
          }
        } else {
          Write-Host -ForegroundColor Red "Failed to update $recordUrl"
          $exception.Response

          return $false
        }
  }



#cls
