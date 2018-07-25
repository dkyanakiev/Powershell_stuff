function Trigger-ResetNode(){
  param(
   [string]$node
  )
  
  $old_error_action = $ErrorActionPreference
  $ErrorActionPreference = "SilentlyContinue"
  
  Write-Host "Adding Reset Node $node to the queue"
  Get-WebRequest -Method POST -URI "https://jenkinsURL/job/Reset_Node/buildWithParameters?NODES=$node&RESTART_NODE=No"
  
  $ErrorActionPreference = $old_error_action
}