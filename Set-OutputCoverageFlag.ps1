function Set-OutputCoverageFlag{
    param(
        [bool]$trackCoverage
    )

    if ($trackCoverage -eq $true){
        $value = "True"
    } else {
        $value = "False"
    }

    Write-Host "Setting the coverage flag to be true"
    $sql_command = "UPDATE [hsfaqa$($env:QA_ENV_1)].[dbo].[config] SET parameter_value='$($value)' Where parameter_name='trace_qa_test';"


    Write-Host $sql_command
    $output = $(sqlcmd -S $env:QA_DATABASE_SERVER -U $($env:QA_ENV_1) -P  -Q "$sql_command")

    write-host $output

    if ($output -contains "(1 rows affected)"){
        write-host "Success"
    } else {
        write-host -foreground red "Failed to set coverage to True"
        exit 1
    }

}
