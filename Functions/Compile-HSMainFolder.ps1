function Compile-HSMainFolder{
    param(
        [string]$FolderPath
    )

    $oldErrorAction = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"

    if ($env:workspace -eq $null){
        $workspace = $env:workspace
    } else {
        $workspace = $(pwd).path
    }


    $status = $false
    Write-host "HSMain folder path " $FolderPath
    $boostrap = "$($FolderPath)\Autobuild\bootstrap_ci.py"
    Write-host "Booststrap " $bootstrap
    $runci = "$($FolderPath)\Autobuild\run_ci.py"
    Write-host "Run_Ci " $runci
    $boostrap_log = Join-Path $workspace "compile_bootstrap_log.txt"
    Write-host "Starting python bootstrap script"
    Write-Host "Log will be saved to $boostrap_log"

    python $boostrap
    $exit_code = $?

    Write-host "Result: $exit_code $LastExitCode"

    if($exit_code -ne $true){
        write-host "Build boostrap failed" -ForegroundColor Red
      #  Write-Host -ForegroundColor Red $(Get-Content $boostrap_log | Out-String)
        return $false
    }

    Write-Host "Bootstrap successful" -ForegroundColor Green

     #  $run_ci_log = Join-Path $workspace "run_ci_log.txt"
    Write-Host "Running RUN_ci.py"
    Write-Host "Log will be saved to $run_ci_log"

    $run_ci_output = & python $runci #| Out-File -FilePath $run_ci_log -Encoding default
    $exit_code = $?

    $run_ci_output #| Out-File -Encoding default $run_ci_log
  #  Write-Host $(Get-Content $run_ci_log | Out-String)

    Write-host "Result: $exit_code $LastExitCode"
    if($exit_code -ne $true)
    {
        Write-Host -ForegroundColor Red "Run_ci.py failed"

        return $false
    }

    Write-Host -ForegroundColor Green "Run_ci.py was successful"
    return $true

}
