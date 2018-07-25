$subs = Get-AzureRmSubscription  | Where-Object {$_.Name -eq "Production" -or $_.Name -eq "Non-Production" -or $_.name -eq "Shared Services" -or $_.name -eq "POC"}
foreach($sub in $subs){
Set-AzureRmContext -Subscription $sub.Id

$vms = get-azurermvm
foreach ($vm in $vms)
{
           $extensionsOnVM = $null
    
           $extentionIdList = $vm.Extensions.id
        foreach ($extensionId in $extentionIdList){
         $extensionsOnVM = Get-AzureRmResource -ResourceId $extensionId
        
        $extension = (Get-AzureRmVMExtension -ResourceGroupName $vm.resourcegroupname -VMName $vm.name -name $extensionsOnVM.name)
        #write-host $vm.Name   $vm.ResourceGroupName   $extensionsOnVM.name
         #Write-host $extension.ProvisioningState

foreach($ext in $extension)
    {
$o = $Null
$o = new-object PSObject
$o | add-member NoteProperty Subscription $sub.name
$o | add-member NoteProperty VMName $vm.Name
$o | add-member NoteProperty Resourcegroupname $vm.resourcegroupname
$o | add-member NoteProperty Extension $extensionsOnVM.name
$o | add-member NoteProperty ExtensionState $ext.ProvisioningState
$o | add-member NoteProperty ExtensionType $ext.VirtualMachineExtensionType
$o | export-csv -path f:\temp\1.csv -notypeinformation -Append


   }

        }
       }
       }