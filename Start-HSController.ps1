function Start-HSController{
    Set-ServiceAutostart

    Write-Host "Setting HSController start up type to Manual"
    Set-Service (Get-Service HS-Controller*).Name -StartupType "Manual"

    Write-Host "Starting HS-Controller"
    net start $(Get-Service HS-Controller*).Name

    Get-Process -Name python* | %{ Set-ProcessPriority -recursive -processId $_.id }

    if ($(Get-Service HS-Controller*).Status -ne "Running") {
    Write-Host -ForegroundColor Red "Failed to START HS-Controller service"
		exit 1
    }

    Wait-ForServicesToBeStable

    if ((Get-Process -name *python*).Length -lt 10){
      Write-Host "Python service container did not start properly"
      exit 1
    }
}
