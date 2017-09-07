
function Did-VMIrrecoverablyCrash{
    param(
        [string]$node,
        $waitInterval = 60,
        $notifyList = "test-reducer-errors@Directory.com"
    )

    Write-host "Rebooting node from SCALR"

    $sleepCycles = $waitInterval / 10

    for ($i = 1; $i -le $sleepCycles; $i++){

        Write-Host "Checking if $node is " -NoNewline

        if(Is-NodeOffline -node $node){
            Write-Host -ForegroundColor Yellow "offline!"
        } else {
            Write-Host -ForegroundColor Green "online."
            return $false
       }


       sleep 10
    }

    Write-host "Rebooting node from SCALR"
    Get-WebRequest -Method POST -URI "https://jenkinsURL/job/RestartNodesFromScalr/buildWithParameters?NODE=$node"

    $reason = Get-NodeOfflineCause -node $node

    if(($reason.Contains("Connection was broken: java.io.IOException")) -or ((Check-JenkinsNodeStatus -computer $node -tries 3) -eq $false)){
        Write-Host -ForegroundColor Red "Node $node seems to have crashed"
        if($notifyList -ne $null -and $notifyList -ne ""){
            Write-Host -ForegroundColor Red "Sending notification to $notifyList that node $node has crashed"

            Send-Hipchat -color red `
                         -apitoken $token `
                         -room $room `
                         -from "Jenkins" `
                         -notify "Node: https://jenkinsURL/computer/$node/" #<br/><br/>Cause:<br/>$reason"


            # Send-MailMessage -SmtpServer "mail.Directorytest.com" `
            #                  -Subject "VM $node has Irrecoverably Crashed" `
            #                  -To $notifyList `
            #                  -From ""`
            #                  -Body "Node: https://jenkinsURL/computer/$node/`r`n`r`nCause:`n`r$reason"
        }

        return $true
    } else {
        Write-Host -ForegroundColor Yellow "Node $node is offline but it is not due to Connection was broken"
        return $false
    }


}
