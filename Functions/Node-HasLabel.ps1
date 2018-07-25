
function Node-HasLabel(){
    param(
        [string]$node,
        [string]$label,
        $labelArray = @()
    )

    if($label -ne $null -and $label -ne ""){
        $labelArray += @($label)
    }


    $response  = $(Get-WebClient).DownloadString("https://jenkinsURL/computer/$node/config.xml")
    $xml = [xml]$response

    $labelsOnNode = $xml.slave.label.split(" ")

    $foundLabel = $false
    $labelArray | %{

        if ($labelsOnNode.contains($_)){
            $foundLabel = $true
        }
    }

    return $foundLabel
}
