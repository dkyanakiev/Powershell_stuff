
function Collect-TestFiles{
    param(
        [string]$test_location,
        [string]$workspace
    )


    $all_xls_files = get-childitem $test_location -Recurse | where {$_.Extension -eq ".xls"} | Sort-Object
    $setup_files = @()
    $teardown_files = @()
    $tests = @()

    foreach($file in $all_xls_files){
        if ($file.BaseName.Contains("aaa") -and (-not ($file.BaseName.Contains(“zzz”)))) {
            $setup_files += $file.FullName.ToLower().Replace($($workspace).toLower(), "")
        } elseif ($file.BaseName.Contains("zzz_aaa")) {
            $teardown_files += $file.FullName.ToLower().Replace($($workspace).toLower(), "")
        } else {
            $tests += $file.FullName.ToLower().Replace($($workspace).toLower(), "")
        }

    }
    
    $return_value = @{}
    $return_value["tests"] = $tests
    $return_value["setup"] = $setup_files
    $return_value["teardown"] = $teardown_files


    return $return_value
}