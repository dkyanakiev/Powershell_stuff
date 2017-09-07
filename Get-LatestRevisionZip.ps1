function Get-LatestRevisionZip{
  param(
    $username,
    $password,
    $revisionNumber
  )


$a = Get-ListOfArtifactsFromArtifactory -username $username -password $password

$artifactList = @{}

$test = $a.keys | %{
 $artifactList[$a[$_]] = $_
  # Write-host $artifactList[$a[$_]]
}

  $artifactList.keys | Sort-Object -Descending| Select-Object -first 1 |  %{
  $revision = $artifactList[$_]}

  $revisionNumber = ($revision.Replace("/Zip-","")).Replace(".zip","")
  Write-host "Latest Revision Number is : " $revisionNumber

  return $revisionNumber
}
