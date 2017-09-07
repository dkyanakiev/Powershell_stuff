
function Convert-TestResultsToJUnit{
    param(
        [string]$junit_folder,
        [string]$workspace
    )

    if(Test-Path $junit_folder){
        rm -Recurse -Force $junit_folder
    }

    mkdir $junit_folder


    $timer_history = Import-TestResults

    foreach($test_file in $timer_history.keys){

        $test_class_name = $($(get-item $test_file).Directory.FullName.ToLower().Replace($($workspace).ToLower(), "").Replace("`\", ".")).TrimStart(".").ToUpper()
        $test_name = $(get-item $test_file).BaseName

        $current_test_output_dir = $(get-item $test_file).Directory.FullName.ToLower().Replace($($workspace).ToLower(), $junit_folder.ToLower())
        if(-not (Test-path $current_test_output_dir)){
            New-Item -ItemType Directory -Path $current_test_output_dir -Force
        }


        $xml_output = $test_file.ToLower().Replace("xls", "xml")
        $xml_exists = Test-Path $xml_output

        $html_output = $test_file.ToLower().Replace("xls", "html")
        $html_exists = Test-Path $html_output

        if($timer_history[$test_file]["exit"] -eq $true){
            $exit_code = $true
        } elseif ($timer_history[$test_file]["rerun_exit"] -eq $true){
            $exit_code = $true
        } else {
            $exit_code = $false
        }

        if($xml_exists){
            $status = Parse-OutputXmlStatus -xml_input $xml_output -debug
        }


        $standard_out = $(Get-Content -Path $($test_file.ToLower().Replace(($workspace).ToLower(), (Join-Path $workspace "standard_out"))).Replace(".xls",".txt")) -join "`n"
        $junit_output_file = Join-Path $current_test_output_dir ($test_name + ".xml")

        if (($exit_code -eq $false) -and ($html_exists -eq $false) -and ($xml_exists -eq $false)){
            $status = "error"
            $message = "Timeout Error"

				    $env:TIMEDOUTTESTS += "$test_name,"

            Generate-JunitOutputFile -junit_output_file $junit_output_file `
                                     -classname $test_class_name `
                                     -test_name $test_name `
                                     -standard_error_string "check archived artifacts for standard out" `
                                     -duration $timer_history[$test_file]["time"] `
                                     -total_tests "1" `
                                     -skipped "0" `
                                     -failures "0" `
                                     -errors "1" `
                                     -status "error" `
                                     -failure_type "Timeout Error"

        } elseif (($exit_code -eq $true) -and ($status.ToLower() -eq "passed")){
            #write passing junit
            Generate-JunitOutputFile -junit_output_file $junit_output_file `
                                     -classname $test_class_name `
                                     -test_name $test_name `
                                     -standard_error_string "" `
                                     -duration $timer_history[$test_file]["time"] `
                                     -total_tests "1" `
                                     -skipped "0" `
                                     -failures "0" `
                                     -errors "0" `
                                     -status "passed" `
                                     -failure_type ""

        } else {
            #write failing juni
            Generate-JunitOutputFile -junit_output_file $junit_output_file `
                                     -classname $test_class_name `
                                     -test_name $test_name `
                                     -standard_error_string "check archived artifacts for standard out" `
                                     -duration $timer_history[$test_file]["time"] `
                                     -total_tests "1" `
                                     -skipped "0" `
                                     -failures "1" `
                                     -errors "0" `
                                     -status "failed" `
                                     -failure_type "Test Failure"

        }


    }

}
