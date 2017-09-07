function Import-ReserveFile(){
  param($file, $tries = 0)
  
  $tries++
  
  write-host "Reading file $file attempt $tries"
  
  if ($tries -eq 10){
    return @()
  }
  
  Try{
    return Import-Clixml $file
  } catch {
    return Import-ReserveFile -file $file -tries $tries
  }
}