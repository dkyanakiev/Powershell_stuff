
function Get-TestResultOutputFile{
    return $(join-path $env:workspace "run_times.xml")
}

function Import-TestResults{
    return Import-Clixml -Path $(Get-TestResultOutputFile)
}

function Record-TestResults{
    param(
        [bool]$exit_code,
        [string]$test_file,
        [string]$duration

    )

    if(test-path $(Get-TestResultOutputFile)){
        try{
          $timer_history = Import-TestResults
        } catch {
          write-host "Could not import $(Get-TestResultOutputFile)"
          $timer_history = @{}
        }
    } else {
        $timer_history = @{}
    }


    if($timer_history[$test_file] -eq $null){
        $timer_history[$test_file] = @{}
    }

    if($timer_history[$test_file]["exit"] -eq $null){
        $timer_history[$test_file]["exit"] = $exit_code
    } else {
        $timer_history[$test_file]["rerun_exit"] = $exit_code
    }

    $timer_history[$test_file]["time"] = $duration
    
    $timer_history.keys
    
    $timer_history |  Export-Clixml -Path $(Get-TestResultOutputFile) -Encoding Default

}