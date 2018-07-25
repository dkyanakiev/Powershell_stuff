function RunScriptExtension(){
Param(
    [string]$outputfilepath,
    [string]$scriptextensionname ,
    [string]$storageaccountname ,
    [string]$storageaccountcontainer,
    [string]$windowsscript,
    [string]$linuxscript,
    [string]$storageRG,
    [array]$vmlist
)

#Loopig through the servers
foreach($vm in $vmlist)
{
    $vminfo = Get-AzureRmVM -ResourceGroupName $vm.ResourceGroupName -VMName $vm.name
    $serverextension= $vminfo.extensions
    $os = $vminfo.StorageProfile.OsDisk.OsType
    #check for custom script extension
    foreach($serverextension in $serverextension)
      {
          if($serverextension.VirtualMachineExtensionType -like "CustomScript*")
          {
            $extensionToRemove = $serverextension.name
            $removeExt = $true
          }
      }

    #Remove script extension
    if($removeExt){
      Write-host "Attempting to remove extension $extensionToRemove"
        $statusremove=Remove-AzureRmVMCustomScriptExtension -ResourceGroupName $vminfo.ResourceGroupName -VMName $vminfo.name -Name $extensionToRemove -Force
    }


    #create new script extension
    if($os -eq "Windows"){
      Write-host "Creating Custom Script Extension for windows"
    $statuscreate = CreateWindowsExt -ResourceGroupName $vminfo.ResourceGroupName `
                                                     -Location $vminfo.Location `
                                                     -VMName $vminfo.name `
                                                     -scriptextensionname $scriptextensionname `
                                                     -storageaccountname $storageaccountname `
                                                     -StorageRG $storageRG `
                                                     -storageaccountscript $windowsscript `
                                                     -storageaccountcontainer $storageaccountcontainer `
    }

    if($os -eq "Linux"){
      Write-host  "Creating Custom Script Extension for Linux"
      $statuscreate = CreateLinuxExt -ResourceGroupName $vminfo.ResourceGroupName `
                                                       -Location $vminfo.Location `
                                                       -VMName $vminfo.name `
                                                       -StorageRG $storageRG `
                                                       -scriptextensionname $scriptextensionname `
                                                       -storageaccountname $storageaccountname `
                                                       -storageaccountscript $linuxscript `
                                                       -storageaccountcontainer $storageaccountcontainer `
    }

    ## Getting results for the extension
    if($statuscreate.StatusCode -eq "OK"){
        $VMResult=(Get-AzureRmVMDiagnosticsExtension -ResourceGroupName $vminfo.ResourceGroupName -VMName $vminfo.name -Name $scriptextensionname -Status).SubStatuses[0].Message
        try
        {
            add-content $outputfilepath "$($vminfo.name),$VMResult"
        }
        catch
        {
            throw 'Cannot add content to $outputfilepath. Exiting the program.'
        }
    }

    #Removing custom script extension after installation
    "Removing CustomScriptExtension for VM $($vminfo.name) started at $(Get-Date)"
    try
    {
        $statusremove=Remove-AzureRmVMCustomScriptExtension -ResourceGroupName $vminfo.ResourceGroupName -VMName $vminfo.name -Name $scriptextensionname -Force
    }
    catch
    {
        promptonerror "Cannot remove custom script extension for VM"
        continue
    }
    if($statusremove.StatusCode -eq "OK")
    {
        "CustomScriptExtension for VM $($vminfo.name) succesfully removed at $(Get-Date)"
    }
    else
    {
        try
        {
            "CustomScriptExtension for VM $($vminfo.name) fail to remove properly at $(Get-Date)"
            add-content $outputfilepath "$($vminfo.name),extensions fail to remove properly"
        }
        catch
        {
            throw 'Cannot add content to $outputfilepath. Exiting the program.'
        }
    }


}
}


#RunScriptExtension   -outputfilepath "C:\results\SQLResult.txt" `
#                                              -scriptextensionname "SQLServerCheck1" `
#                                              -storageaccountname  `
#                                              -storageaccountcontainer scripts `
#                                              -windowsscript SQLCheck.ps1 `
#                                              -linuxscript SQLCheckLinux.ps1
