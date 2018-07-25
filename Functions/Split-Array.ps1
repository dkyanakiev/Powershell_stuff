function Split-array  
{ 
  param($inArray,[int]$parts,[int]$size) 
   
  if ($parts) { 
    $PartSize = [Math]::Ceiling($inArray.count / $parts) 
  }  
  if ($size) { 
    $PartSize = $size 
    $parts = [Math]::Ceiling($inArray.count / $size) 
  } 
 
  $outArray = @() 
  for ($i=1; $i -le $parts; $i++) { 
    $start = (($i-1)*$PartSize) 
    $end = (($i)*$PartSize) - 1 
    if ($end -ge $inArray.count) {$end = $inArray.count} 
    $outArray+=,@($inArray[$start..$end]) 
  } 
  return ,$outArray 
 
}