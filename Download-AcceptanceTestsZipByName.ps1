
function Download-AcceptanceTestsZipByName{
    param(
        [string]$zip_folder
    )

    $outputDir = Split-Path $zip_folder -Parent
    $stack_name = (Split-Path $zip_folder -leaf).Replace(".zip", "")

    if (-not (Test-Path $outputDir)){
       mkdir $outputDir
    }

    $artifactUrl = Get-ArtifactURL -stack $stack_name
    
    if ($artifactUrl -eq $null){
      Write-Host "Artifact URL returned a NULL"
    }
    
    $targetZipLocation = Join-Path $outputDir "$($stack_name).zip"
    Write-Host "Downloading from $artifactUrl to $zip_folder"

    $(Get-WebClient).Downloadfile($artifactUrl, $zip_folder)
}
