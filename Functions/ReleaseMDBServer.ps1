function ReleaseMDBServer()
{

  $configXML = [xml] (Get-Content ("C:\Directory\config_backup.xml"))
  $configXML.Save($($(Join-Path "C:\Directory\config" $env:CURRENT_CONFIG_NAME) + "\config.xml"))
  Write-Host "Remove the environment variables"

  [Environment]::SetEnvironmentVariable("MDB_ENVIRONMENT", $null, "machine")

  $envVar = @()
  $envVar = Get-ChildItem env: | Where-Object {$_.name -like "MDB_TARGET_*"}
  foreach ($a in $envVar) {
    #remove the env variable
    [Environment]::SetEnvironmentVariable($a.name, $null, "machine")
    #update the config if not QAUNKWN

  }


}