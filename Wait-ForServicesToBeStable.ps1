function Wait-ForServicesToBeStable{
 ## Add additional loop over the check
 	Write-Host "Waiting for services to be stable..."
 	#sleep 30
  $Stoploop = $true
  $retrycounter = 0

  do{
  $xmlsort =[xml] (Get-Content "C:\Directory\config\$($env:QA_ENV_1)QA\config.xml" )
  $Retry = $false
  foreach ($group in $xmlsort.containers.container)
  {
    $likeop = "*" +$group.name+ "*"
    $tmpproc = (Get-WmiObject Win32_Process -Filter "name = 'python.exe'" | Select-Object ProcessID, CommandLine| Where-Object CommandLine -Like $likeop) | Select-Object ProcessID

    foreach($id in $tmpproc.ProcessID)
    {
        $min = New-TimeSpan -Start (Get-Process -Id $id).StartTime |Select-Object Minutes
        if($min.Minutes -lt 2)
        {
            Write-Host "Process ID: $id UpTime: $min Stop Loop: $Stoploop Retry Counter: $RetryCounter"
            $Stoploop = $false
            $Retry = $true
        }
        else
        {
            Write-host "Process is OK: " $id

        }
    }
  }

  if($Retry -eq $false)
    {
          Write-Host "Stoping rerun attempts"
          $Stoploop = $true
    }
  elseif($retrycounter -gt 2){
      Write-host "Error with the processId"
      exit 1
  }
  elseif($retrycounter -eq 0)
  {
    Write-host "Services are not up, Next retry in 8 minutes $(Get-Date)"
    sleep 480
  }
  else
  {
    Write-host "Retrying in 60sec"]
    sleep 60
    $retrycounter++
  }

  } While($Stoploop -eq $false)
}
