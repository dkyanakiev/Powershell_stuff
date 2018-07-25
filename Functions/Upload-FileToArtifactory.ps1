function Upload-FileToArtifactory(){
	param (
		[string]$Method = "PUT",
		[Parameter(Mandatory=$true)][string]$URI,
		[Parameter(Mandatory=$true)][string]$filePath,
		[Parameter(Mandatory=$true)][string]$username,
		[Parameter(Mandatory=$true)][string]$password,
		[string]$upload_log = "uplaod_artifact_to_artifactory_log.txt"
	)
	
	if(-not (Test-Path $filePath)){
		Write-Host -ForegroundColor Red "$filePath does not exist" 
	}
	Write-host "Attempting to upload at: $URI" 
	Write-host "File name is: $filePath" 
	Write-Host "Upload log: $upload_log"

	$wc = new-object System.Net.WebClient
	$wc.Credentials = new-object System.Net.NetworkCredential($username, $password)
	$wc.UploadFile($URI, "PUT", $filePath ) | Out-File -Encoding default -FilePath $upload_log	
}
