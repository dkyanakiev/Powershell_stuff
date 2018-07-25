function Checkout-SVN{
    param(
        [string]$path,
        [int]$revision,
        [string]$svn_log = ""
    )

    Write-host "Revision number is " $revision
    Write-host "Attempting to export at " $path

    if(Test-Path $path) {rm -recurse -force $path }

    $oldErrorAction = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"

    if($svn_log -eq $null -or $svn_log -eq ""){
        svn export -r $revision "SVN_URL" $path
    } else {
        Write-Host "Writting svn checkout log to $svn_log"
        svn export -r $revision "SVN_URL" $path | Out-File -FilePath $svn_log -Encoding default
    }
    $exit_code = $?

    $ErrorActionPreference = $oldErrorAction
    Write-host "Checkout done. Status $exit_code. $exit_code"

    if($exit_code -ne $true -and (Test-Path $svn_log)){
        Write-Host -ForegroundColor Red $(Get-Content $svn_log | Out-String)
    }

    return $exit_code
}
