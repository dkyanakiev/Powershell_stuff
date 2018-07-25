
function Reserve-Node(){
    param(
        [string]$node,
        [string]$build,
        [switch]$offline
    )
    #This is for a retry timer in case jenkins is slow
    $Stoploop = $false
    [int]$Retrycount = "0"

    $freeLabel = "hi_test_impactor hs_test_impactor"
    $reservedLabel = "svn_test"

    if ($offline -eq $true){
        $newLabel = "$reservedLabel svn_commit_$($build)"
    } else {
        $newLabel = $freeLabel
    }

    $request = Get-WebRequest -Method GET -ErrorAction SilentlyContinue -URI "https://jenkinsURL/computer/$node/config.xml"
    $xml = [xml]$request.Content

    if($xml.slave.label.Contains("shared_qa_node")){
        $newLabel = "$newLabel shared_qa_node"
    }

    if($xml.slave.label -eq "contineous_coverage_updater" -or $xml.slave.label -eq "contineous_coverage_updater" -or $xml.slave.label -eq "test_impactor_asgard_test_watcher"){
        Write-Host "This node should not be released ever."
    } else {

        $xml.slave.label = $newLabel

        $xmlString = $xml.OuterXml

        do {
         try {
           $request = Get-WebRequest -Method POST -Uri "https://jenkinsURL/computer/$node/config.xml" -Body $xmlString
           Write-Host "Label updated"
           $Stoploop = $true
           }
         catch {
           if ($Retrycount -gt 3){
             Write-Host "Could not send Information after 3 retrys."
             $Stoploop = $true
           }
           else {
             Write-Host "Could not send Information retrying in 30 seconds..."
             Start-Sleep -Seconds 30
             $Retrycount = $Retrycount + 1
           }
         }
        }
        While ($Stoploop -eq $false)


    }
}
