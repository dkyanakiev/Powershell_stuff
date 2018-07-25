function Idle-AllTestRunNodes () {
	
$idleNodes=@()
$allTestRunLabel="run_all_tests"
$allTestRunNodes = (Get-NodesForLabel $allTestRunLabel)["online"]

foreach ($node in $allTestRunNodes) {
    if ((Is-NodeIdle $node) -eq $true) {
     	$idleNodes += $node
    } else {
    	Write-Host "Not a single Node is idle"
    }

}
return $idleNodes
}

