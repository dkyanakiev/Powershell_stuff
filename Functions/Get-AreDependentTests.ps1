function Get-AreDependentTests(){
    param(
        [string]$dbUrl,
        [string]$database,
        [string]$buildId,
        $returnLimit = $((Get-MaximumNodesToUse) * 2)
    )

    if ($returnLimit -eq "-1"){
      $limit = ""
    } else {
      $limit = "&limit=$returnLimit"
    }

    $url = "$($dbUrl)/$($database)/_design/tests/_view/are_dependent?keys=[`"$buildId`"]$($limit)"

    $r = Invoke-WebRequest -Method Get -Uri $url

    $list = ConvertFrom-Json $r.Content

    return $list.rows

}