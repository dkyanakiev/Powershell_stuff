function Get-WebRequestArtifactory(){
	param (
		[string]$Method = "GET",
		[string]$URI,
		[string]$Body = "",
		$user ,
		$passwd
	)

	$credentialAsBytes = [System.Text.Encoding]::ASCII.GetBytes($user + ":" + $passwd)
	$credentialAsBase64String = [System.Convert]::ToBase64String($credentialAsBytes);
	$Headers=@{Authorization = "Basic " + $credentialAsBase64String}

	if ($Method.ToUpper() -eq "POST") {
		$webRequest = Invoke-WebRequest -Method POST -ErrorAction SilentlyContinue -URI $URI -Body $body -Headers $Headers
		return $webRequest
	}
	elseif ($Method.ToUpper() -eq "GET") {
		$webRequest = Invoke-WebRequest -Method GET -ErrorAction SilentlyContinue -URI $URI -Headers $Headers
		return $webRequest
	} else {
		$webRequest = Invoke-WebRequest -Method $Method.ToUpper() -ErrorAction SilentlyContinue -URI $URI -Headers $Headers
		return $webRequest
	}
}
