function ReturnTargetNodes()
{
    param(
    [string]$client1,
    [string]$client2
    )
    $client_nodes = @()
    $client_nodes += $client1

    $client_nodes += $client2
    Write-host "target nodes" $client_nodes
    return ,$client_nodes

}