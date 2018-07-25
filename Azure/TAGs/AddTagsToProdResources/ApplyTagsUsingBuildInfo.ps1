#################################
###Modify the path to represent your local directory to load the functions
### TO DO: Modify to dynamically load the path for loading the function

#################################
. ..\Functions\ApplyGeneralResourceTags.ps1
. ..\Functions\ApplyResourceGroupTags.ps1
. ..\Functions\ApplyVMTags.ps1
. ..\Functions\ApplyPublicIPTags.ps1

#### Switch to enable test logging, rather than pushing to Azure
### If you want to enable pushing to prod, change the TestingOn value to false
$TestingOn = $false
##### Location of the build sheets that are used to run the script
#######
##### If you have multiple vms - do not fill the values in the hostname field
$MultipleVMs = $false 
#######


###### Select subscription for which to run the scripts####

$Subscription = "41d5-9963-"            ### NonProd

############################################################

Set-AzureRmContext -Subscription $Subscription

###############



$content = Get-Content -Path C:\DevWork\GitCodeCommit\Cloud_rdc_sofia\PowerShell\TAGs\AddTagsToProdResources\buildsheet.txt
$LogFile = "C:\tmp\Tags\buildsheetlogs2.log"
#### Create Values based on the buildsheet #########    
#### The script will exit if any of the values in the build sheet are empty
foreach($line in $content){
$vars = $line.Split("=")
    if($vars[0] -eq $null -or $vars[0] -eq "" -or $vars[0] -eq " ")
    {
        Write-host "Missing values in the buildsheet $($vars[1]), please modify before running again"
        "$($content) has missing Values" | Out-File -FilePath $Logfile -Append -Force
    }elseif($vars[1] -eq $null -or $vars[1] -eq "" -or $vars[1] -eq " ")
    {
        Write-host "Missing values in the buildsheet for $($vars[0]), please modify before running again"
        "$($content) has missing Values" | Out-File -FilePath $Logfile -Append -Force
        exit 1
    }else{
         New-Variable -Name "$($vars[0])" -Value $vars[1] -Force
   }
}




Try
{
    $rg = Get-AzureRmResourceGroup -Name $resource_group_name -ErrorAction Stop
}
Catch
{
    "Resource Group cannot be found" | Out-File -FilePath $Logfile -Append -Force
    Break
}





ApplyResourceGroupTags -ResID $rg `
                     -switch $TestingOn `
                     -ApplicationCode $ApplicationCode `
                     -business_unit $business_unit `
                     -dr_class $dr_class `
                     -managed_service_tier '2' `
                     -security_tier $security_tier `
                     -application_id $application_id `
                     -environment $environment  `
                     -infra_msp 'KO Cloud' `
                     -terraform_managed 'not_managed'

$resources = Find-AzureRmResource -ResourceGroupNameEquals $rg.ResourceGroupName
foreach($resource in $resources){
    if($resource.ResourceType -eq "Microsoft.Compute/virtualMachines"){
        if($MultipleVMs -eq $true){
            $host_name = $resource.ResourceName
        }
        ApplyVMTags -ResID $resource `
                    -switch $TestingOn `
                    -database $database `
                    -host_name $host_name `
                    -puppet_managed $puppet_managed `
                    -saml_domain $saml_domain `
                    -migration_method $migration_method `
                    -application_id $application_id `
                    -environment $environment `
                    -infra_msp 'KO Cloud' `
                    -terraform_managed 'not_managed' `
                    -status $status

    }elseif($resource.ResourceType -contains "publicIPAddresses"){
        ApplyPublicIPTags -ResID $resource `
                          -switch $TestingOn `
                          -application_id $application_id `
                          -environment $environment `
                          -terraform_managed 'not_managed' `
                          -infra_msp 'KO Cloud'
                          
    }elseif($resource.ResourceType -eq "Microsoft.Compute/virtualMachines/extensions")
    {
            #Skipping extensions
    }
    else{
        ApplyGeneralResourceTags -ResID $resource `
                                 -switch $TestingOn `
                                 -application_id $application_id `
                                 -environment $environment `
                                 -infra_msp 'KO Cloud' `
                                 -terraform_managed 'not_managed'
    }

}
