foreach ($sub in $subs)
{
Select-AzureRmSubscription -SubscriptionId $sub.Id | Out-Null
foreach ($computer in $computerList)
{
$computerList = Get-AzureRmVM | Select-Object name

foreach ($VMName in $computerList)
{
$o = $null
$o2 = $null
$o = new-object PSObject
$o2 = new-object PSObject
$o | add-member NoteProperty VirtualMachine $VMName.Name
#$VMName.Name | Export-csv -Path C:\tmp\disk.csv -Append
$vminfo = Find-AzureRmResource -ResourceNameContains $VMName.name -ResourceType Microsoft.Compute/virtualMachines
if($vminfo -ne $null)
{

$vm = Get-AzureRmVm -ResourceGroupName $vminfo.ResourceGroupName -Name $vminfo.Name -ErrorAction SilentlyContinue
$vmosdiskUri = $vm.StorageProfile.OsDisk.vhd.Uri
if($vmosdiskUri -eq $null){
  Write-host "Disk is managed"
  $o | add-member NoteProperty HasManagedDisks "Yes"
#  "$($vm.name) has managed disks - " | Export-csv -Path C:\tmp\disk.csv -Append
  $o | add-member NoteProperty DataDiskCount $vm.StorageProfile.DataDisks.Lun.Count
#  "Data disk count  $($vm.StorageProfile.DataDisks.Lun.Count)" | Export-csv -Path C:\tmp\disk.csv -Append
  $o | export-csv -path c:\temp\testdisk.csv -notypeinformation -Append
}
else{
Write-host "disk is unmanaged"
$o2 | add-member NoteProperty VirtualMachine $VMName.Name

$o2 | add-member NoteProperty OsDiskUri $vmosdiskUri
Write-host "OS disk $($vmosdiskUri)"
$o2 | add-member NoteProperty HasManagedDisks "No"
#$vmosdiskUri | Export-csv -Path C:\tmp\disk.csv -Append
#Empty array to fill with the number of Luns for the Data disk
$diskCount = @()
$x = $vm.StorageProfile.DataDisks.Lun.Count
$o2 | add-member NoteProperty DataDiskCount $x
    if($x -gt 0)
    {
        for($i = 0 ; $i -lt $x; $i++)
        {   #Increment the array based on the count - 1
            $diskCount += $x - 1
        }
    }
    elseif($x -le 0)
    {
       $o2 | add-member NoteProperty NoDataDisk $vmosdiskUri
       #"No data disks for this VM" | Export-csv -Path C:\tmp\disk.csv -Append
    }

    for($i = 0 ; $i -lt $diskCount.Length; $i++)
    {
       $vm.StorageProfile.DataDisks[$i].Vhd.Uri |  Export-csv -Path C:\tmp\disk.csv -Append
       $o2 | add-member NoteProperty DataDiskUri[$i] $vmosdiskUri
    }

  $o2 | export-csv -path c:\temp\testdisk.csv -notypeinformation -Append
}
}
}
}
}
