
function Group-TestsByDir{
    param(
        [string]$workspace,
        [array]$tests
    )
    

    $test_file_objects = @()
    foreach($t in $tests){
        $testFile = Join-Path $workspace $t
        if (Test-Path $testFile){
          $test_file_objects += Get-Item $testFile
        }    
    }


    $tests_by_dir = @{}

    foreach($t in $test_file_objects){

        $current_dir = $t.directory.fullName.toLower()

        if ($tests_by_dir[$current_dir] -eq $null){
            $tests_by_dir[$current_dir] = @()
        }

        $tests_by_dir[$current_dir] += $t

    }

    return $tests_by_dir
}