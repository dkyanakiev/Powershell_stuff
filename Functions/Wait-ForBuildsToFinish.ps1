
function Wait-ForBuildsToFinish{
  param(
    [string]$jobName,
    $searchParameters,
    $sleepInterval = 60,
    $waitIntervalForBuildToStart = 60,
    $waitCompletionPercent = 100
  )

  $stillBuilding = $true
  $globalFinished = @()

  for($i =0; $i -lt $waitIntervalForBuildToStart; $i++){
    write-host "Waiting until build is started or added to the queue"
    $buildIDs = Find-BuildAllBuildsByParameters -jobName $jobName -buildParameters $searchParameters
    $buildsInQueue = Find-BuildAllBuildsInQueueByParameters -buildName $jobName -buildParameters $searchParameters

    if($buildIDs -ne $null -or $buildsInQueue -ne $null){
      write-host "Builds started or have been added to the queue"
      break
    } else {
      write-host "still waiting"
      sleep 1
    }

  }


  Write-Host "`r`n`r`n`r`n===================================================================================="
  Write-Host "Builds currently in Queue"
  $buildsInQueue.Keys | %{
    Write-Host "$($_) - $($buildsInQueue[$_])"
  }

  Write-Host "`r`n`r`nWaiting for $($buildIDs.count) to finish`r`n"
  $buildIDs | %{
      Write-Host "https://jenkinsURL/job/$jobName/$_/console"
  }
  Write-Host "====================================================================================`r`n`r`n`r`n"

  while($stillBuilding){
    $buildIDs = Find-BuildAllBuildsByParameters -jobName $jobName -buildParameters $searchParameters
    $buildsInQueue = Find-BuildAllBuildsInQueueByParameters -buildName $jobName -buildParameters $searchParameters

    $finishedBuild = @()
    $buildIDs | %{
        if((Is-JobBuilding -jobName $jobName -jobNumber $_) -eq $false){
            $finishedBuild += $_
        }
    }


    Write-Host -ErrorAction Continue -NoNewline "Total: $($buildIDs.count), Running: $($buildIDs.count - $finishedBuild.count), Finished: $($finishedBuild.count), In Queue: $($buildsInQueue.keys.count), "

    if($finishedBuild.count -eq 0 ){
      $percentComplete = 0
    } else {
      $percentComplete = ($finishedBuild.count/$buildIDs.count) * 100
    }
    Write-Host "$($percentComplete)% of started are complete"
    if(($percentComplete -ge $waitCompletionPercent) -and ($buildsInQueue.keys.count -eq 0)){
        $stillBuilding = $false
        Write-Host "All builds finished"
    } else {
        sleep $sleepInterval
        $buildsInQueue.keys | %{
            Remove-BuildFromQueueIfStuck -id $_ -waitIntervalForCrashCheck 30
        }
    }
  }


}

# cls
