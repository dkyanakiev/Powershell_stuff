
function Find-HsMainArtifact(){
  param(
    [string]$buildUrl,
    [string]$version
  )

  $user = "serviceaccount"
  $passwd = $($env:serviceaccount_pass).toString()
  $credentialAsBytes = [System.Text.Encoding]::ASCII.GetBytes($user + ":" + $passwd)
  $credentialAsBase64String = [System.Convert]::ToBase64String($credentialAsBytes);
  $Headers=@{Authorization = "Basic " + $credentialAsBase64String}

  $request = Invoke-WebRequest -Method GET -ErrorAction Stop -URI "$($buildUrl)/api/xml" -Headers $Headers
  $xml = [xml]$request.Content

  $artifact_url = ""

  foreach ($build in $xml.freeStyleProject.build){
    $r = Invoke-WebRequest -Method GET -ErrorAction Stop -URI "$($build.url)/api/xml"  
    $build_xml = [xml]$r.Content

    foreach ( $artifact in $build_xml.freeStyleBuild.artifact ){
      if ($artifact.fileName.Contains("0.$($version).0")){
          $artifact_url = "$($build.url)/artifact/$($artifact.fileName)".Replace(" ", "%20")
          break
      }
    }
  }
  
  return $artifact_url
}