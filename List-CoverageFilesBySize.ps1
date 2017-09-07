function List-CoverageFilesBySize(){
    param(
        [string]$dirLocation,
        [string]$outputFile
    )

    $sortedFiles = @{}
    $csvFiles = Get-ChildItem -Recurse $dirLocation | where {$_.Extension -eq ".csv"}

    foreach($f in $csvFiles){

        Write-Host -ForegroundColor Cyan "Reading $($f.FullName)"
        $content = Get-Content $f.FullName

        if ($sortedFiles[$content.count] -eq $null){
            $sortedFiles[$content.count] = @()
        }

        $sortedFiles[$content.count] += (($f.FullName).ToString().ToLower()).Replace($dirLocation.ToLower(), "")
    }



    Write-Host -ForegroundColor Green "Finshed reading in all files"
    Write-Host "Writing to $outputFile"

    "Generated $(Get-Date)" | Out-File -FilePath $outputFile -Encoding default

    $sortedFiles.Keys | Sort-Object -Descending | %{
        Write-Host "Writing group $($_)"
        "`n`n $($_)" | Out-File -Append -FilePath $outputFile -Encoding default
        $sortedFiles[$_] -join "`n" | Out-String | Out-File -Append -FilePath $outputFile -Encoding default
    }


}

# cls
