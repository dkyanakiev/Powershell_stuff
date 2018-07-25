function Run-SingleTest{
    param(
        [string]$ini_file,
        [string]$test_file,
        [string]$stdout_file,
        [switch]$debug
    )

    $originalExitStrategy = $ErrorActionPreference
    $ErrorActionPreference = "Continue"

	Kill-AllAsgard


	Write-Host $(Get-Date)


    if($debug){
        Write-Host "Running $test_file ini file $ini_file out file $stdout_file"
    }

    New-Item $stdout_file -ItemType file -Force

    $test_block = {
        param(
            [string]$ini_file,
            [string]$xls_file,
            [string]$output,
            [string]$dir_path
        )
				[System.Threading.Thread]::CurrentThread.Priority = 'Highest'


        Write-Host "Case corrected file path: $xls_file"
        cd "C:\acceptancetests"

        $python_executable = Join-Path $dir_path "Python26\python.exe"
        $nosetest_framework = Join-Path $dir_path "test_framework\nose_a_test.py"

        & $python_executable $nosetest_framework -t $xls_file | Out-File -Encoding default -FilePath $output
        $exit_code = $?

        Write-Host "Exit status $exit_code, last exit code $LastExitCode"
        if($LastExitCode -ne 0){
            throw "Test $xls_file failed!"
        }
    }


	Kill-AllAsgard

	write-host "Starting Test"
	write-host $(Get-Date)

    $timer = [Diagnostics.Stopwatch]::StartNew()
    $test_job = Start-Job -ScriptBlock $test_block -ArgumentList $ini_file, $file_to_execute, $stdout_file, $(Get-CurrentHSMainPath)

    Set-TestPrioritiesHigh

    Wait-Job -Job $test_job -Timeout 900

    $timer.Stop()


	Write-host "Background exit status $($test_job.State)"
	Write-host $(Receive-Job $test_job)

    if($test_job.State -eq "Completed"){
        $exit_code = $true
    } else {
        if($test_job.State -eq "Running"){
            Write-Host -ForegroundColor Red "Test aborted after 1500 second timeout"

						$name = (Get-Item $file_to_execute).BaseName
						$junit_folder = Join-Path $env:workspace "jUnit"
						$current_test_output_dir = $(get-item $file_to_execute).Directory.FullName.ToLower().Replace($($env:workspace).ToLower(), $junit_folder.ToLower())
                        Generate-JunitOutputFile -junit_output_file $(Join-Path $current_test_output_dir ( $name + ".xml")) `
                                                -classname "Stuck.Test" `
                                                -test_name $name `
                                                -standard_error_string "Look on $(hostname)" `
                                                -duration 9000 `
                                                -total_tests "1" `
                                                -skipped "0" `
                                                -failures "0" `
                                                -errors "1" `
                                                -status "failed" `
                                                -failure_type "Test Aborted After Timeout"

        }

        $exit_code = $false
    }

    Remove-Job $test_job -Force #If you don't do this, and Job timed out, the PID will keep running taking resources. Don't remove!!!
	  Get-Job

    Record-TestResults -exit_code $exit_code -test_file $file_to_execute -duration $timer.Elapsed.TotalSeconds


    if($debug){
        write-host $timer.Elapsed
    }

		Write-Host $(Get-Date)

    $ErrorActionPreference = $originalExitStrategy

    return $exit_code
}
