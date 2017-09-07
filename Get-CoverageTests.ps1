function Get-CoverageTests(){
    param(
        [string]$dbUrl = "https://jenkinsURL:8081/",
        [string]$database = "coverage",
        [array]$idList,
        [string]$view

    )

    if($view -eq "nav"){
      $suite = "nav_documents"
      Write-host "Nav tests"
    }
    if($view -eq "sm"){
      $suite = "sm_documents"
      Write-host "Security master tests"
    }
    if($view -eq "ba"){
      $suite = "ba_documents"
      Write-host "Security master tests"
    }

    $url = "$($dbUrl)$($database)/_design/custom_view/_view/$($suite)"
    Write-host $url

    $r = Invoke-WebRequest -Method Get -Uri $url

    $list = ConvertFrom-Json $r.Content

    foreach($id in $list.rows.id){
            $idList += $id
    }
    return $idList

}
#cls
#$a = Get-UnreservedTests
