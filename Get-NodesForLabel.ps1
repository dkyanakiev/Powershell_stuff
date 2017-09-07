
function Get-NodesForLabel(){
  param(
    [string]$label,
    [string]$not_label
  )
  #$webClient = Get-WebClient
  $response  = $(Get-WebClient).DownloadString("https://jenkinsURL/label/$label/api/xml")

  $xml = [xml]$response

  $nodes = @{}
  $nodes["all"] = @()
  $nodes["online"] = @()
  $nodes["offline"] = @()

  foreach ($currentNode in $xml["labelAtom"].node) {

      if($not_label -eq $null -or $not_label -eq ""){
        if(Node-HasLabel -node $currentNode.InnerText -label $not_label){
            Write-Host "$($currentNode.InnerText) has $not_label label and will be skipped"
            continue
        }
      }
      
      $response  = [xml]$(Get-WebClient).DownloadString("https://jenkinsURL/computer/$($currentNode.InnerText)/api/xml")
    
      if($response.slaveComputer.offline -eq $true){
          Write-Host -ForegroundColor Red "$($currentNode.InnerText) is offline"
          $nodes["offline"] += $currentNode.InnerText
      } else {
          Write-Host -ForegroundColor Green "$($currentNode.InnerText) is online"
          $nodes["online"] += $currentNode.InnerText
      }

      $nodes["all"] += $currentNode.InnerText
  }

  return $nodes

}

#cls
#$currentNode = Get-NodesForLabel -label svn_test