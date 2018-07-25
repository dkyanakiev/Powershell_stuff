function CreateWindowsExt(){
  Param(
      [string]$ResourceGroupName ,
      [string]$Location,
      [string]$VMname,
      [string]$scriptextensionname ,
      [string]$storageaccountname ,
      [string]$StorageRG ,
      [string]$storageaccountcontainer,
      [string]$storageaccountscript
  )
$key = (Get-AzureRmStorageAccountKey -Name $storageaccountname -ResourceGroupName $StorageRG).value[0]
$createExt =  Set-AzureRmVMCustomScriptExtension -ResourceGroupName $ResourceGroupName `
                                                 -Location $Location `
                                                 -VMName $VMname `
                                                 -Name $scriptextensionname `
                                                 -StorageAccountName $storageaccountname `
                                                 -StorageAccountKey $key  `
                                                 -FileName $storageaccountscript `
                                                 -ContainerName $storageaccountcontainer `
                                                 -Run $storageaccountscript


return $createExt

}
