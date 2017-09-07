function Remove-ItemFromArray{
  param(
    $inputArray,
    $itemToRemove
  )

  $returnArray = @()
  
  $inputArray | %{
    
    if ($_ -ne $itemToRemove){
        $returnArray += $_
    }
  }
  
  return $returnArray

}