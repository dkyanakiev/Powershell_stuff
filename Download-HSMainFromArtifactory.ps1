function Download-HSMainFromArtifactory(){
    param(
        [string]$outputDir = "C:\artifacts",
        [Parameter(Mandatory=$true)][string]$revision,
        [string]$artifactoryUrl= "https://artifactory/artifactory/hsmain-build/snapshot/",
        [Parameter(Mandatory=$true)][string]$username,
    		[Parameter(Mandatory=$true)][string]$password
    )

    #Do I need to delete the folder before i copy the new file
    #if (-not (Test-Path $outputDir)){
    #    mkdir $outputDir
    #}

  $downloadUrl = "$($artifactoryUrl)HSMain-$($revision).zip"
  Write-host "The download URL is: " $downloadUrl
  $downloadLocation = "$($outputDir)\HSMain-$($revision).zip"
  Write-host "The download location is: " $downloadLocation

  $wc = new-object System.Net.WebClient
	$wc.Credentials = new-object System.Net.NetworkCredential($username, $password)
  $wc.DownloadFile($downloadUrl, $downloadLocation)
  if($? -eq $true)
   {Write-host "Download successful"}
   else
   {Write-Host "Download failed"}

}
#Comment out the mendatory parameters if testing locally
#cls
#Download-HSMainFromArtifactory -revision "745126"
