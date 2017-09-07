function ReleaseMDBclient()
{

  $configXML = [xml] (Get-Content ("C:\Directory\config_backup.xml"))
  $configXML.Save($($(Join-Path "C:\Directory\config" $env:CURRENT_CONFIG_NAME) + "\config.xml"))

}