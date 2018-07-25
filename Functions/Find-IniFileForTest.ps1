$ErrorActionPreference = "Stop"
function Find-IniFileForTest{
    param( 
     [string]$test
    )

    $test_object = Get-Item $test
    $parent_dir = $test_object.Directory

    if($parent_dir -eq $null){
      $parent_dir = $test_object.parent  
    }

    $ini_file = Get-ChildItem $parent_dir.FullName | where { $_.Name.ToLower() -eq "asgardconfig.ini" }

    if($ini_file -eq $null){
        if ($test_object.GetType().Name -eq "FileInfo"){
            $path = $test_object.Directory.FullName
        } elseif ($test_object.GetType().Name -eq "DirectoryInfo"){
            $path = $test_object.Parent.FullName
        } else {
            Write-Host -ForegroundColor RED "Unknown file type for $test $($test_object.GetType() | Out-String)"
            exit 1
        }
        return Find-IniFileForTest -test $path
    } else {
        return $ini_file.FullName
    }
}