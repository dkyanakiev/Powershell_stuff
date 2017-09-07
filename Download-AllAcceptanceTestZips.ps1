function Download-AllAcceptanceTestZips(){
    param(
        [string]$outputDir = "C:\artifacts",
        [string]$jenkinsBuild= "https://jenkinsURL/job/AcceptanceTests/"
    )

    if (-not (Test-Path $outputDir)){
        mkdir $outputDir
    }

    $request = Get-WebRequest -Method GET -URI "$($jenkinsBuild)/lastSuccessfulBuild/api/xml"  
    $xml = [xml]$request.Content

    foreach ($a in $xml.freeStyleBuild.artifact){
        $artifactUrl = "$jenkinsBuild/lastSuccessfulBuild/artifact/$($a.relativePath)"
        $targetZipLocation = Join-Path $outputDir $a.fileName

        Write-Host "Downloading from $artifactUrl to $targetZipLocation"
        #$wc = New-Object net.webclient
        $(Get-WebClient).Downloadfile($artifactUrl, $targetZipLocation)   
    }
}

#cls
#Download-AllAcceptanceTestZips -outputDir "c:\user"