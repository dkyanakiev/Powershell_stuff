function Download-JarFromArtifactory(){
    param(
        [string]$jarLocation,
        [string]$artifactoryUrl,
        [Parameter(Mandatory=$true)][string]$username,
    		[Parameter(Mandatory=$true)][string]$password
    )

  $downloadUrl = "$($artifactoryUrl)SCALRAPI.jar"
  Write-host "The download URL is: " $downloadUrl
  Write-host "The download location is: " $jarLocation

  $wc = new-object System.Net.WebClient
	$wc.Credentials = new-object System.Net.NetworkCredential($username, $password)
  $wc.DownloadFile($downloadUrl, $jarLocation)
  if($? -eq $true)
   {Write-host "Download successful"}
   else
   {Write-Host "Download failed"}

}
#Comment out the mendatory parameters if testing locally
#cls
#Download-HSMainFromArtifactory -jarLocation
