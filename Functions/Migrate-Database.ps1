function Migrate-Database { 
    param( [string]$workspace )

    $bin_dir = "C:\Directory\bin"
    Write-Host "Changing dir to $bin_dir"
    cd $bin_dir

    Pre-ADSStartMigration -workspace $workspace
    Run-ADSMigration -workspace $workspace

}