function Reserve-DependentDir(){
  param(
        [string]$dbUrl,
        [string]$database,
        [string]$buildId,
        [string]$node
    )
$allDirs = Get-UnreservedTests -dbUrl $dbUrl -database $database -buildId $buildId

foreach ($currentDir in $allDirs){
        $dirUrl = "$($dbUrl)/$($database)/$($currentDir.id)"

        $r = Invoke-WebRequest -Method Get -Uri $dirUrl
        $response = ConvertFrom-Json $r.content

        if ($response.node -eq ""){
            Write-Host "Attempting to reserve $currentDir"
            
            Print-TestStatusSummary -dbUrl $dbUrl `
                                    -dbName $database `
                                    -buildId $buildId

            $response.node = $node
            try{ 
                $updateR = Invoke-WebRequest -Method Put -Uri $dirUrl -Body (ConvertTo-Json $response)
            } catch {
                $exception = $_.Exception.response
            }
            
            if ($updateR -ne $null){
                $updateResponse = ConvertFrom-Json $updateR.Content
            
                if ($updateResponse.ok -eq $true){
                    $returnDir = $currentDir.key
                    return $response.dir
                } else {
                    Write-Host -ForegroundColor Yellow "Reservation failed, trying next"
                    Write-Host -ForegroundColor Yellow $updateResponse
                }
            } else {
                Write-Host -ForegroundColor Yellow "Reservation failed, trying next"
                Write-Host -ForegroundColor Yellow $exception
            }
        }

    }

    return ""
}