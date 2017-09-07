function Setup-MDBMachines{
    param(
        $nodeArray
    )

    Write-Host "All available nodes`r`n$($nodeArray -join ',')"
    $keepRunning = $true
    $selectedNodes = @()


    do{
        $currentSelectedNodeBatch = $nodeArray | Select-Object -First 3

        if($currentSelectedNodeBatch.count -eq 3){
            write-host "Current selected batch $($currentSelectedNodeBatch -join ',')"
                    
            $mdb = $currentSelectedNodeBatch[0]
            $selectedNodes += $mdb

            $clients = @()
            $clients += $currentSelectedNodeBatch[1]
            $clients += $currentSelectedNodeBatch[2]

            $remove = @()
            $remove += $currentSelectedNodeBatch[0]
            $remove += $currentSelectedNodeBatch[1]
            $remove += $currentSelectedNodeBatch[2]
            Write-Host "MDB: " $mdb "clients" $clients "all 3 " $remove
        
            foreach($currentNode in $remove)
            {
            $requrest = Get-WebRequest -Method "POST" `
                                        -URI "https://jenkinsURL/job/Deploy_MDB_From_String/buildWithParameters?NODES=$currentNode&MDBServer=$mdb&MDBclient=$clients"
            $nodeArray = Remove-ItemFromArray -inputArray $nodeArray -itemToRemove $currentNode          
            }

            Write-Host "Current state of node array $($nodeArray -join ',')"
        } else {
            Write-Host "Available nodes have dipped bellow 3, moving on"
            $keepRunning = $false
        }

    }while($keepRunning -eq $true)


    Write-NodesFile -nodeList $selectedNodes
}