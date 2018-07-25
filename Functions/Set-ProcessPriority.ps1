function Set-ProcessPriority{
    param(
        [string]$processId,
        [switch]$recursive,
        [switch]$verbose
    )

    Try
    {
      $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
      if ($process -ne $null){
        $process.PriorityBoostEnabled = $true
        $process.PriorityClass = 'High'
    

        if ($recursive -eq $true){
           Get-WmiObject -Class Win32_Process -Filter "ParentProcessID=$processId" | Select-Object -Property ProcessID | Where-Object {$_.ProcessID -ne $null} | %{
              Set-ProcessPriority -recursive -processId $_.processID
          }
      
        }
        
        if ($verbose -eq $true){
            Write-Host "Setting Priority to high. PID: $($processId) Priority: $($process.PriorityClass), Boost: $($process.PriorityBoostEnabled)"
        }
      }
    }
    Catch
    {      
      $ErrorMessage = $_.Exception.Message
      $FailedItem = $_.Exception.ItemName
      write-host -foreground RED "ERROR setting process priority `r $ErrorMessage `r`r $FailedItem"
      write-host "Restarting HS-Controller"
      Restart-Service $(Get-Service HS-CONTROLLER*).Name
    }
}

function Set-TestPrioritiesHigh{
    Get-Process -Name python* | %{ Set-ProcessPriority -recursive -processId  $_.id }
  Get-Process -Name jenkins-slave* | %{ Set-ProcessPriority  -recursive -processId  $_.id }
}