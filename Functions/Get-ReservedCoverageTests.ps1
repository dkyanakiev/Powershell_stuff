function Get-ReservedCoverageTests(){
    param(
        [string]$dbUrl = "https://jenkinsURL:8081/",
        [string]$database = "coverage",
        [array]$idList,
        [string]$view,
        [string]$buildId

    )

    if($view -eq "1"){
      $suite = "1_documents"
      Write-host "1 tests"
    }
    if($view -eq "2"){
      $suite = "2_documents"
      Write-host "2 tests"
    }
    if($view -eq "3"){
      $suite = "3_documents"
      Write-host "3 tests"
    }


    $url = "$($dbUrl)$($database)/_design/custom_view/_view/$($suite)"
    Write-host $url

    $r = Invoke-WebRequest -Method Get -Uri $url

    $list = ConvertFrom-Json $r.Content

    foreach($id in $list.rows.id){
      if($list.rows.status -eq "RESERVED $($buildId)" )
      {
          $idList += $id
      }
    }
    return $idList

}
#cls
#$a = Get-UnreservedTests
