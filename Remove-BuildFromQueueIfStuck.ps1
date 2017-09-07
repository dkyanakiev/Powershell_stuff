
function Remove-BuildFromQueueIfStuck{
    param(
        $id,
        $maxMinsInQueue = 5,
        $waitIntervalForCrashCheck = 200
    )

    $queueItem = Get-QueueItemById -id $id

    if ($queueItem -eq $null) {
        Write-Host "$id is no longer in the Queue"
        return
    }

    $dateObject = Convert-FromEpochMillisecondsToDateTime -UnixDate $queueItem.inQueueSince

    $timeDifference = $(Get-Date) - $dateObject

    if ($timeDifference.TotalMinutes -gt $maxMinsInQueue){
        $nodeName = Get-ParameterFromQueueItem -queueItem $queueItem -parameterName "NODES"
        if (Node-Exists -nodeName $nodeName){
            if (Did-VMIrrecoverablyCrash -node $nodeName -waitInterval $waitIntervalForCrashCheck){
                Write-Host "Node $nodeName has crashed completely, removing Queue item $id"
                Remove-ItemFromQueue -id $id
                if(Test-Path "NODES.txt"){
                  write-host "Removing $nodeName from NODES.txt"
                  $nodes = Read-NodesFile -file "NODES.txt"
                  Write-NodesFile -nodeFile "NODES.txt" -nodeList $(Remove-ItemFromArray -inputArray $nodes -itemToRemove $nodeName)
                }
            }

        } else {
            Write-Host "Node $nodeName does not exist, removing Queue item $id"
            Remove-ItemFromQueue -id $id
            if(Test-Path "NODES.txt"){
              write-host "Removing $nodeName from NODES.txt"
              $nodes = Read-NodesFile -file "NODES.txt"
              Write-NodesFile -nodeFile "NODES.txt" -nodeList $(Remove-ItemFromArray -inputArray $nodes -itemToRemove $nodeName)
            }
        }
    }
}
