function CopyConfigXML {
    param(
        [string]$config_destination,
        [string]$jenkinsScriptsDir = "."
      )

    Write-Host "Updating in $config_destination"
    if(Test-Path "$config_destination\config.xml") {
      rm -force "$config_destination\config.xml"
    }


    cp (Join-Path $jenkinsScriptsDir "/config-as-doc/files/config.xml") "$config_destination"


    Write-Host "Update cube database server for the vms"
    $configXML = [xml] (Get-Content $($(Join-Path "C:\Directory\config" $env:CURRENT_CONFIG_NAME) + "\config.xml"))


        #update Config name
        $configname = $configXML.configs.config
        $configname.name =  $($env:CURRENT_CONFIG_NAME)
        #update Ads Server
        $ads_server = $configXML.configs.config.sections.section.properties.property | where {$_.Name -eq 'ads_server'}
        $ads_server.value = "$(hostname):9000"

        #admin_code

        $admin_code = $configXML.configs.config.sections.section.properties.property | where {$_.Name -eq 'admin_code'}
        $admin_code.value = "$($env:QA_ENV_1)QA"
        #update DB_user
        $db_user = $configXML.configs.config.sections.section.properties.property | where {$_.Name -eq 'db_user'}
        $db_user.value = "hsfaqa$($env:QA_ENV_1)"

        #update ssas_catalog name
        $ssas_catalog_name = $configXML.configs.config.sections.section.properties.property | where {$_.Name -eq 'ssas_catalog_name'}
        $ssas_catalog_name.value = "SSAS_$($env:QA_ENV_1)_Position_Cube"


    $configXML.Save($($(Join-Path "C:\Directory\config" $env:CURRENT_CONFIG_NAME) + "\config.xml"))

}
