function Kill-ProcessNicely{
    param([string]$name)

    #Temporary disable stop on error, in case a parent process is killed and the child is dead before the loop got to it
    $stopPreference = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"

    Get-Process -ProcessName $name | %{ write-host "Killing $($_.ID)"; Stop-Process -Id $_.ID -Force 2> $null}
    
    $ErrorActionPreference = $stopPreference
}

function Kill-AllAsgard{
        Kill-ProcessNicely -name *hsStart*
        Kill-ProcessNicely -name *asgard*
}