function Trigger-DeployHSMainTrunkToNode(){
  param(
   [string]$node
  )
  
  $old_error_action = $ErrorActionPreference
  $ErrorActionPreference = "SilentlyContinue"
  
  Write-Host "Adding Reset Node $node to the queue"
  $request = Get-WebRequest -Method POST -URI "https://jenkinsURL/view/DevOps/job/Deploy_To_Node/buildWithParameters?NODES=$node"
  write-host $request.StatusCode
  write-host $request.RawContent
  
  $ErrorActionPreference = $old_error_action
}