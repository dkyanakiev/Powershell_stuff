function Start-ADS{
    Write-Host "Setting ADS start up type to Manual"
    Set-Service (Get-Service ADS*).name -StartupType "Manual"

    Write-Host "Starting ADS Service"
    net start $(Get-Service ADS*).Name

    if ($(Get-Service ADS*).Status -ne "Running"){
        Write-host -foregroundcolor RED "Failed to start ADS"
        exit 1
    }

    Get-Process -Name ADS*  | %{ Set-ProcessPriority -recursive -processId $_.id }
}
