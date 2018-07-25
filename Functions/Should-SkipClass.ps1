
function Should-SkipClass(){
  param(
    [string]$inputClass
  )

  Get-IgnoreClassList | %{
    if($inputClass -match $_){
      write-host "$inputClass is on the skip list"
      return $true
    }
  }
  return $false
}