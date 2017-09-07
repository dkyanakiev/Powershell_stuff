function Did-NodeDieDuringBuild{
  param(
    [string]$buildURL,
    [string]$buildNumber
  )
  Write-host "Build url " $buildURL
  Write-host "build url to get "
  Write-Host "$buildURL$buildNumber/console"
  $request =  Get-WebRequest -Method "GET" -URI "$buildURL$buildNumber/console"
  $content = $request.Content

  return ($content.contains("ChannelClosedException"))

}
