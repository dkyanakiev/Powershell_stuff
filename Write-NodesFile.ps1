
function Write-NodesFile{
  param(
    $nodeList,
    [string]$nodeFile = "NODES.txt"
  )

  if ($nodeList.count -eq 0){
    Write-Host -ForegroundColor Yellow "WARNING: Got an empty list of nodes to write to $nodeFile. Will not write this file."
    Remove-Item -Force -Path $nodeFile -ErrorAction Continue
    return $null
  }
  
  $string = "NODES=$($nodeList -join ',')"
  write-host "Writing $nodeFiles $($string)"
  
  $string | Out-File -FilePath $nodeFile -Encoding default
  write-host "write-complete"
}