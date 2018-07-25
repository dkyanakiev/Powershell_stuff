function Get-UnreservedTestsMDB(){
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


    #/masterdatabase?keys=%5B%22`"$buildId`"%22%5D&include_docs=true

    $url = "$($dbUrl)/$($database)/_design/tests/_view/masterdatabase?keys=[`"$buildId`"]"


    $r = Invoke-WebRequest -Method Get -Uri $url

    $list = ConvertFrom-Json $r.Content

    return $list.rows

}

#cls
#$a = Get-UnreservedTests -dbUrl "http://127.0.0.1:5984" -database "userreserve" -buildId "12345"

#Get-UnreservedTests -dbUrl "http://jenkinsURLcom:8081/" -database "reserved_tests" -buildId "abc"
#Get-UnreservedTests -dbUrl "http://jenkinsURLcom:8081/" -database "reserved_tests" -buildId "abc"
