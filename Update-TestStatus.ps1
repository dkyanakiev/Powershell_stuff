
function Update-TestStatus(){
    param(
        [string]$buildId,
        [string]$testName,
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

    write-host "ID: $buildId NAME: $testName DBURL: $dbUrl DBNAME: $dbName Finish: $finish_time Start: $start_time Rerun: $rerun_result Node: $node Status: $status"

    if (($buildId -eq $null) -or ($buildId -eq "")){
      write-host "No build id providing skipping"
      return $true
    }
    $list_url = "$($dbUrl)/$($dbName)/_design/tests/_view/test_names?keys=[`"$($buildId)`"]"

    write-host "Attempting to update $testName for build $buildId"

    $testName = $testName.ToLower().replace("c:\acceptancetests\", "")
    $r = Invoke-WebRequest -Method Get -Uri $list_url

    $parsedJson = ConvertFrom-Json $r.content

    $parsedJson.rows[0].value.ToLower() -eq $testName.ToLower()
    $found_row = $null
    foreach ($row in $parsedJson.rows){
        if ($row.value.ToLower() -eq $testName.ToLower()){
            write-host "Found document $($dbUrl)/$($dbName)/$($row.id)"
            $found_row = $row
            break
        }
    }
    if ($found_row -eq $null){
        Write-Host -ForegroundColor Red "Could not locate test $testName for build $buildId in $($dbUrl)/$($dbName)"
        return $false
    } else {
        $recordUrl = "$($dbUrl)/$($dbName)/$($found_row.id)"
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
          write-host $build_url
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
