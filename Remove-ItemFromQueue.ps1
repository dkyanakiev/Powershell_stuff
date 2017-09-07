
function Remove-ItemFromQueue{
    param(
        [string]$id
    )
    write-host "Removing $id from the queue"
    
    $old_error_action = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    if ((Get-QueueItemById -id $id) -ne $null){
       Get-WebRequest -Method POST -Body "" -URI "https://jenkinsURL/queue/cancelItem?id=$id"
       $ErrorActionPreference = $old_error_action
    }
}