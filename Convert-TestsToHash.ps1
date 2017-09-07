
function Convert-TestsToHash(){
  param(
    $inputObject
  )

  $converted_map = @{}
  #The input objects from JSON converter is actually a custom object.
  #So we have to loop through each object that is like a Hash but has several additional object level methods, such as
  #GetType() or ToString() or Equels() etc..
  #
  #So the object's structure is a "method" that refers to a python class that was touched with the commit
  #With an Array of tests. We look through all of the methods on the custom object ignoring the primative methods such as ToString()
  #And treat all of the other methods as a key of the map.
  
  $inputObject | Get-Member | %{
    if(($_.name -ne "Equals") -and ($_.name -ne "GetHashCode") -and ($_.name -ne "GetType") -and ($_.name -ne "ToString")){
        $converted_map[$_.name] = $inputObject."$($_.name)"
    }  
  }
  
  #At this point we have a simple hashmap, now it's time to collapse any 
  return $converted_map

}