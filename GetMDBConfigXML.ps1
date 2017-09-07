function GetMDBConfigXML()
{
    param(
        [array]$target_nodes,
        [array]$target_client_xml
    )

    for ([int]$i=0; $i -le $target_nodes.Count-1; $i++) {
			Write-Host "==============================="
			Write-Host $($target_nodes[$i].toString() + 'QA')
			Write-Host "==============================="

			$node = ('TS01-QA-'+ $($target_nodes[$i].toString()))
			$configEnv = $($target_nodes[$i].toString() + 'QA')
      $file_path = "\\$node\c$\Directory\config\$configEnv\config.xml"

      Write-Host "Reading $file_path"
			[string]$configXML = Get-Content $file_path
			$target_client_xml += $configXML
	}


    return ,$target_client_xml

}