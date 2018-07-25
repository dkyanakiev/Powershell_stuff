function ApplyPublicIPTags(){
 [CmdletBinding()]
    Param(
        $ResID,
        $switch,
        [string]$application_id ,
        [string]$environment  ,
        [string]$infra_msp ,
        [string]$terraform_managed
    )

    #### LOGFILE FOR LOCAL OUTPUT OF FAILED TAGS#####
    $Logfile = "C:\tmp\Tags\$($ResID.Name).log"

    ### Check if the logfile Exists; If not it will create the structure to the file + the file
    If(!(test-path $Logfile))
        {
            New-Item -ItemType File -Force -Path $Logfile

        }



    ###### Empty Tag####
    $array_tag = @{}

    # Get the command name
    $CommandName = $PSCmdlet.MyInvocation.InvocationName;
    # Get the list of parameters for the command
    $ParameterList = (Get-Command -Name $CommandName).Parameters;
    $varNames = Get-Variable -Name $ParameterList.Values.Name -ErrorAction SilentlyContinue

     ### First make a check to see if a specific key exists###
    if($ResID.Tags -ne $null){

    # Grab each parameter value, using Get-Variable
    foreach($varName in $varNames){
     if($varName.Name -ne 'ResID' -and $varName.Name -ne 'switch'){
    
    ### We have the resource we are going to check the tags###
   
            if($ResID.Tags.ContainsKey($varName.Name) -eq $true){
            ###If the key exists check for value
             #if($ResID.Tags.ContainsValue($varName.Value) -eq $true){}
             #### Currently this if is disabled, as agreed. We are going to simply log the name of the resource and varify manually if the resource has the proper values 
            "Tag exists - $ResID.ResourceGroupName ; $resId.ResourceName ; $varName.Name "  | Out-File -FilePath $Logfile -Append -Force
            }
        else{
            #### there is not Tag with the key name eq to the $varname.Name 
            #### Create a tag
            #### Check to only create tags with no empty values
            if($varName.Value -ne $null -and $varName.Value -ne "" -and $varName.Value -ne " "){
                $tags = $ResID.Tags
                $tags.Add($varName.Name, $varName.Value)

                if($switch -eq $true){    
                    "Set-AzureRmResource -Tag $($tags) -ResourceId $($ResID.ResourceId) -force "| Out-File -FilePath $Logfile -Append -Force                                      
                }else{
                Set-AzureRmResource -Tag $tags -ResourceId $ResID.ResourceId -force }

            }else{
                "$ResID.ResourceGroupName ; $resId.ResourceName ; $varName.Name  Value is empty"  | Out-File -FilePath $Logfile -Append -Force
            }
        }

      }

      }
    }else{
      #### Crate Tags Hash
      foreach($varName in $varNames){
       if($varName.Name -ne 'ResID'  -and $varName.Name -ne 'switch'){
        if($varName.Value -ne $null -and $varName.Value -ne "" -and $varName.Value -ne " "){    
                $array_tag.Add($varName.Name, $varName.Value)
               
            }else{
                "$ResID.ResourceGroupName ; $resId.ResourceName ; $varName.Name  Value is empty"  | Out-File -FilePath $Logfile -Append -Force
            }
        }}

        if($switch -eq $true){    
            "Set-AzureRmResource -Tag $($array_tag) -ResourceId $($ResID.ResourceId) -force "| Out-File -FilePath $Logfile -Append -Force                                     
        }else{
        Set-AzureRmResource -Tag $array_tag -ResourceId $ResID.ResourceId -force }
      
    }




}
#ApplyGeneralResourceTags -ResID $resId

