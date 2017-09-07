
function Read-NodesFile{
    param(
      [string]$file = "NODES.txt"
    )

    write-host "Reading $file"
    $content = Get-Content $file

    return $content.Split("=")[1].Split(",")

}

#$a = Read-NodesFile -file C:\NODES.txt