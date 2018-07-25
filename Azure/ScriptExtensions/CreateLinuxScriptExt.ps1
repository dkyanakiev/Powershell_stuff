function CreateLinuxExt(){
  Param(
      [string]$ResourceGroupName ,
      [string]$StorageRG ,
      [string]$Location,
      [string]$VMname,
      [string]$scriptextensionname ,
      [string]$storageaccountname ,
      [string]$storageaccountcontainer,
      [string]$storageaccountscript
  )
  $key = (Get-AzureRmStorageAccountKey -Name $storageaccountname -ResourceGroupName $StorageRG).value[0]

  $TheURI = "https://$storageaccountname.blob.core.windows.net/scripts/$storageaccountscript"
  $Settings = @{"fileUris" = @($TheURI); "commandToExecute" = "./$storageaccountscript"};
  $ProtectedSettings = @{"storageAccountName" = $storageaccountname; "storageAccountKey" = $key};
  #
  $createExt = Set-AzureRmVMExtension -ResourceGroupName $ResourceGroupName `
                         -Location $Location `
                         -VMName $VMname `
                         -Name $scriptextensionname `
                         -Publisher "Microsoft.Azure.Extensions" `
                         -Type "CustomScript" `
                         -TypeHandlerVersion "2.0" `
                         -Settings $Settings `
                         -ProtectedSettings $ProtectedSettings

  return $createExt

}
