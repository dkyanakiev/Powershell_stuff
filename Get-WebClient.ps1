function Get-WebClient(){
	$user = "serviceaccount"
	$passwd = $($env:serviceaccount_pass).toString()
	$webClient = new-object System.Net.WebClient
	$credentialAsBytes = [System.Text.Encoding]::ASCII.GetBytes($user + ":" + $passwd)
	$credentialAsBase64String = [System.Convert]::ToBase64String($credentialAsBytes);
	$webClient.Headers[[System.Net.HttpRequestHeader]::Authorization] = "Basic " + $credentialAsBase64String;
	return $webClient
}
