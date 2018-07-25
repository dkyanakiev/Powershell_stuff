function Get-NodesFromNodeFile{
  param([string]$file)

  $nodesFile = Get-Content -Path $file
  $nodes = $nodesFile.Split("=")[1].split(",")
  return $nodes
}
