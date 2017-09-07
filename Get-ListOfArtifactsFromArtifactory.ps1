function Get-ListOfArtifactsFromArtifactory{
    param(
        [string]$artifactoryBaseUrl= "https://artifactory/artifactory",
        [string]$repositoryName,
        [string]$username,
        [string]$password
    )
    Write-host "Base URL " $artifactoryBaseUrl

    $URI = "$artifactoryBaseUrl/api/storage/$($repositoryName)/?list&deep=1"

    Write-Host "Checking URI: $URI"

    $request = Get-WebRequestArtifactory -Method "GET" -URI $URI -user $username -passwd $password

    $json = ConvertFrom-Json $request.toString()

    $returnHash = @{}

    $json.files | %{
        $date = [datetime]$_.lastModified
        $returnHash[$_.uri] = $date
    }


    return $returnHash
}
