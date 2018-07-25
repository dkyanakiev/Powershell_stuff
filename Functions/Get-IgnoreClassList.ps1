function Get-IgnoreClassList(){

  #Regular expressions please
  $ignore = @()
  
  $ignore += "^common.*"
  
  write-host "Skip list"
  $ignore
  return $ignore

}