function Unzip-TestFiles{
    param(
        [string]$stack,
        [string]$zip,
        [string]$artifactsDir,
        [string]$workspace
    )

    $zipLocation = Join-Path $artifactsDir $zip
    ## Adding a check for nav zip
    if($zip -eq "123.zip")
    {
      $testLocation = Join-Path $workspace "Tests"
    }elseif($zip -eq "123.zip")
    {
      $testLocation = Join-Path $workspace "123"
    }elseif($zip -eq "123.zip")
    {
      $testLocation = Join-Path $workspace "321"
    }
    #
    #if($stack -eq $null -or $stack -eq "")
    #{
    #  $testLocation = Join-Path $workspace $zip.Replace(".zip","")
    #}
    else{
    $testLocation = Join-Path $workspace $stack
    }

    New-Item -ItemType Directory -Path $testLocation

    write-host "Unzipping stack $stack to $testLocation from $zipLocation"

    Add-Type -Assembly "system.io.compression.filesystem"
    [io.compression.zipfile]::ExtractToDirectory($zipLocation, $testLocation)
}
