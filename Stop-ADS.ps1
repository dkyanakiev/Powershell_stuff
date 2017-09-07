function Stop-ADS{
    Write-Host "Stopping ADS Service"
    if ($(Get-Service ADS*).Status -ne "Stopped"){

        net stop $(Get-Service ADS*).Name

        if ($(Get-Service ADS*).Status -ne "Stopped") {
            Write-Host -ForegroundColor Red "Failed to stop ADS service"; exit 1
        }
    }
}
