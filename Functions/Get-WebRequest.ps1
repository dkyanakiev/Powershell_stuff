function Get-WebRequest(){
	param (
		[string]$Method = "GET",
		[string]$URI,
		[string]$Body = "",
		[string]$outFile,
		$user = "serviceaccount",
		$passwd = $($env:serviceaccount_pass)
	)

	#Forcing TLS1.2 because NetScalr is only accepting 1.2  for .....
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

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
