 function Execute-TestFile{
 param(
    [string]$file_to_execute,
    [string[]]$files_already_executed,
    [string]$buildName = "",
    [switch]$rerun_on_failure,
    [switch]$force_execute,
    [switch]$debug,
    [switch]$dontUpdateCouchDb
  )

  write-host "Files already executed $($files_already_executed.length)"

  if(($files_already_executed -contains $file_to_execute) -and ($force_execute -ne $true)){
    if ($debug){
        Write-Host "Skip $file_to_execute"
    }
  } else {

    if ($debug){
        Write-Host "Executing $file_to_execute"
    }

    Write-Host "Opening and saving the $file_to_execute file"
    Resave-ExcelFile -debug -file $file_to_execute

    $std_out_dir = Join-Path $env:workspace "standard_out"

    if(-not (Test-Path $std_out_dir)){
        mkdir $std_out_dir
    }

    $std_out_file = ($(Get-Item $file_to_execute).fullName.toLower().Replace(($env:workspace).ToLower(), $std_out_dir)).Replace(".xls",".txt")
    if($dontUpdateCouchDb -ne $true){

      Update-TestStatus -buildId $buildName `
                        -testName $file_to_execute `
                        -dbUrl $(Get-CouchDBUrl) `
                        -dbName $(Get-TestReservationDb) `
                        -start_time $(date) `
                        -status "Running" `
                        -build_url "$env:BUILD_URL"
    }
    $exit_code = Run-SingleTest -ini_file $(Find-IniFileForTest -test $file_to_execute) `
                                -test_file $file_to_execute `
                                -stdout_file $std_out_file `
                                -debug

    if($exit_code -eq $true){

        Write-Host -ForegroundColor Green "PASSED - $file_to_execute"
        if($dontUpdateCouchDb -ne $true){
        Update-TestStatus -buildId $buildName `
                          -testName $file_to_execute `
                          -dbUrl $(Get-CouchDBUrl) `
                          -dbName $(Get-TestReservationDb) `
                          -finish_time $(date) `
                          -result $true `
                          -status "Finished" `
                          -build_url "$env:BUILD_URL"
                        }
        $files_already_executed += $file_to_execute
      } else {
        if($rerun_on_failure -eq $true){

          $rerun_std_out_file = ($(Get-Item $file_to_execute).fullName.toLower().Replace(($env:workspace).ToLower(), $std_out_dir)).Replace(".xls","_rerun.txt")
          Write-Host  -ForegroundColor DarkYellow "Rerunning $file_to_execute"

          if($dontUpdateCouchDb -ne $true){
          Update-TestStatus -buildId $buildName `
                            -testName $file_to_execute `
                            -dbUrl $(Get-CouchDBUrl) `
                            -dbName $(Get-TestReservationDb) `
                            -result $false `
                            -status "Reruning" `
                            -build_url "$env:BUILD_URL"
                          }

          $exit_code = Run-SingleTest -ini_file $(Find-IniFileForTest -test $file_to_execute) `
                                      -test_file $file_to_execute `
                                      -stdout_file $rerun_std_out_file `
                                      -debug


         if ($exit_code -eq $true){
             Write-Host -ForegroundColor DarkYellow "PASSED (With Rerun) - $file_to_execute"
             if($dontUpdateCouchDb -ne $true){
             Update-TestStatus -buildId $buildName `
                               -testName $file_to_execute `
                               -dbUrl $(Get-CouchDBUrl) `
                               -dbName $(Get-TestReservationDb) `
                               -finish_time $(date) `
                               -rerun_result $true `
                               -status "Finished" `
                               -build_url "$env:BUILD_URL"
                             }
             $files_already_executed += $file_to_execute
         } else {
             $env:FAILEDTESTS += "$file_to_execute,"
             if($dontUpdateCouchDb -ne $true){
             Update-TestStatus -buildId $buildName `
                               -testName $file_to_execute `
                               -dbUrl $(Get-CouchDBUrl) `
                               -dbName $(Get-TestReservationDb) `
                               -finish_time $(date) `
                               -rerun_result $false `
                               -status "Finished" `
                               -build_url "$env:BUILD_URL"
                             }
             Write-Host -ForegroundColor Red "FAILED - $file_to_execute"
             $files_already_executed += $file_to_execute
          }
      } else {
            $env:FAILEDTESTS += "$file_to_execute,"
            Write-Host -ForegroundColor Red "Failed - $file_to_execute"
            $files_already_executed += $file_to_execute
            }
    }


  }

  return $($files_already_executed | select -Unique)

}
