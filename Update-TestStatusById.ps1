
function Update-TestStatusById(){
    param(
        [string]$testId,
        [string]$dbUrl,
        [string]$dbName,
        [string]$finish_time,
        [string]$rerun_result,
        [string]$node,
        [string]$result,
        [string]$start_time,
        [string]$status,
        [string]$build_url
    )


    $url = "$($dbUrl)/$($dbName)/$($testId)"

    Write-Host "Trying to update $url"

    try{
        $response = Invoke-WebRequest -Method Get -Uri $url
    } catch {
        write-host -ForegroundColor Red $_.Exception.Message
    }


    if ($response -eq $null){
        Write-Host -ForegroundColor Red "Could not locate test $testId $($dbUrl)/$($dbName)"
        return $false
    } else {
        $recordUrl = $url
        Write-Host "Updating $recordUrl"
        $testRecord = Invoke-WebRequest -Method Get -Uri $recordUrl

        $recordJson = ConvertFrom-Json $testRecord.content

        if ($start_time -ne ""){
            $recordJson.start_time = $start_time
        }

        if ($result -ne ""){
            $recordJson.result = $result
        }

        if ($rerun_result -ne ""){
            $recordJson.rerun_result = $rerun_result
        }

        if ($finish_time -ne ""){
            $recordJson.finish_time = $finish_time
        }

        if ($node -ne ""){
            $recordJson.node = $node
        }

        if ($status -ne ""){
          $recordJson.status = $status
        }

        if ($build_url -ne ""){
          $recordJson.build_url = $build_url
        }

        write-host ($recordJson |  Out-String)

        try{
          $updateResult = Invoke-WebRequest -Method Put -ContentType "application/json" -Uri $recordUrl -Body $(ConvertTo-Json $recordJson)
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
}


#cls
