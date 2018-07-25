###Add subscription IDs you want to check
$ids = @("-9401-40f4-b950-","-1e08-41d5-9963-","85965e82-a25d--b5c6-")
  foreach($id in $ids)
  {
    $sub = Set-AzureRmContext -Subscription $id
    $subName = $sub.Subscription.Name

    #Get Azure RG
    $resourceGroups = Get-AzureRmResourceGroup
    foreach($resource in $resourceGroups){

            if($resource.Tags.Count -eq 0){

                    $o = $null
                    $o = new-object PSObject
                    $o | add-member NoteProperty Subscription $subName
                    $o | add-member NoteProperty ResourceType "Resource Group"
                    $o | add-member NoteProperty ResourceGroup $resource.ResourceGroupName
                    $o | add-member NoteProperty TagName "N/A"
                    $o | add-member NoteProperty TagValue "N/A"
                    $o | export-csv -path c:\tmp\TagExportResourceGroup.csv -notypeinformation -Append


            }
            else{
                $resource.Tags.GetEnumerator() | ForEach-Object{
                        $o = $null
                        $o = new-object PSObject
                        $o | add-member NoteProperty Subscription $subName
                        $o | add-member NoteProperty ResourceType "Resource Group"
                        $o | add-member NoteProperty ResourceGroup $resource.ResourceGroupName
                        $o | add-member NoteProperty TagName $_.key
                        if($_.value -eq ""){
                        $o | add-member NoteProperty TagValue "" }
                        else{
                        $o | add-member NoteProperty TagValue $_.value}
                        $o | export-csv -path c:\tmp\TagExportResourceGroup.csv -notypeinformation -Append
                }
            }



    }


  }
