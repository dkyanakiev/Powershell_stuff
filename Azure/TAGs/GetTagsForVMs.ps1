###Add subscription IDs you want to check
$ids = @("e08--9963-","-a25d--b5c6-")
  foreach($id in $ids)
  {
    $sub = Set-AzureRmContext -Subscription $id
    $subName = $sub.Subscription.Name

    #Get Azure VM
    $vms = Get-AzureRmVM
    foreach($vm in $vms){

            if($vm.Tags.Count -eq 0){

                    $o = $null
                    $o = new-object PSObject
                    $o | add-member NoteProperty Subscription $subName
                    $o | add-member NoteProperty ResourceType "Virtual Machine"
                    $o | add-member NoteProperty ResourceGroup $vm.ResourceGroupName
                    $o | add-member NoteProperty VMName $vm.Name
                    $o | add-member NoteProperty TagName "N/A"
                    $o | add-member NoteProperty TagValue "N/A"
                    $o | export-csv -path c:\tmp\TagExportVMS.csv -notypeinformation -Append


            }
            else{
                $vm.Tags.GetEnumerator() | ForEach-Object{
                        $o = $null
                        $o = new-object PSObject
                        $o | add-member NoteProperty Subscription $subName
                        $o | add-member NoteProperty ResourceType "Virtual Machine"
                        $o | add-member NoteProperty ResourceGroup $vm.ResourceGroupName
                        $o | add-member NoteProperty VMName $vm.Name
                        $o | add-member NoteProperty TagName $_.key
                        if($_.value -eq ""){
                        $o | add-member NoteProperty TagValue "" }
                        else{
                        $o | add-member NoteProperty TagValue $_.value}
                        $o | export-csv -path c:\tmp\TagExportVMS.csv -notypeinformation -Append
                }
            }



    }

  }
