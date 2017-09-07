function Is-SlaveJarExecutingAnyTasks{
    return (Get-WmiObject -Class Win32_Process `
                        -Filter "ParentProcessID=$((Get-Process -Name java*).id)" `
                        | `
                        Select-Object -Property ProcessID `
                        | `
                        Where-Object {$_.ProcessID -ne $null}) -ne $null
}