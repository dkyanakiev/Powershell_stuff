function Check-JenkinsNodeStatus(){
 param(
   [Parameter(Mandatory=$true)][string]$computer,
   [int]$tries = 10
 )

  Write-Host "Attempting to contact computer name $computer"

  if ($computer.tostring().tolower() -eq (hostname).tostring().tolower()){
    write-Host "Currently on same machine, exiting"
    return $true
  }


   $machine_online = $false
   for ($i = 1; $i -ne $tries; $i++){
       Write-Host -ForegroundColor Green "Attempt number $i"

       Test-Connection $computer -ErrorAction SilentlyContinue

       if ($? -ne $true){
          Write-Host -ForegroundColor RED "Node $computer is not online"
       } else {
          Write-Host -ForegroundColor Green "$computer is online checking Jenkins service"
          $machine_online = $true
          break
       }
   }

   if ($machine_online -eq $false ){
     Write-Host -ForegroundColor RED "Machine $computer did not come online"
     return $false
   } else {
     try{
       Invoke-Command -ComputerName $computer -ScriptBlock {
         param($tries)

         for ($i = 1; $i -ne $tries; $i++){
          Write-Host -ForegroundColor Green "Attempt number $i"
           $pidId = (Get-Process -Name *java*)
           if($pidId -eq $null){
            sleep 10
           } else {
             break
           }
         }
         if($pidId -eq $null){
             shutdown -r -t 10 -f
             throw "Failed to start Jenkins service"
         } else {
           Write-Host -ForegroundColor Green "Service is up and running, yay!"
        }
       }
     } catch {
        return $false
     }
   }
   return $true
}
