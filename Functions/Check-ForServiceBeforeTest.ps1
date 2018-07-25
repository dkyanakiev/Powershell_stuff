### Check before the tests are run.
function Check-ForServiceBeforeTest{
  Write-Host "Waiting 1 minute before checking for services"
  sleep 60
  $servicestatus = $true
  $xmlsort =[xml] (Get-Content "XML LOCATION" )
  foreach ($group in $xmlsort.containers.container)
  {
    $likeop = "*" +$group.name+ "*"
    $tmpproc = (Get-WmiObject Win32_Process -Filter "name = 'python.exe'" | Select-Object ProcessID, CommandLine| Where-Object CommandLine -Like $likeop) | Select-Object ProcessID

    foreach($id in $tmpproc.ProcessID)
    {
        $min = New-TimeSpan -Start (Get-Process -Id $id).StartTime |Select-Object Minutes
        if($min.Minutes -gt '2')
        {
            Write-Host "Process is OK: " $id

        }
        else
        {
            Write-host "Process is down : " $id
            $servicestatus = $false
        }
    }
  }

  if($servicestatus = $false)
    {
      Write-host "Canceling tests, unreserving"
    }
  else
    {
      Write-Host "Services are running, starting the test"
    }

    return $servicestatus
}
