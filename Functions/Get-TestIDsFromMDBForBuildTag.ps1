function Get-TestIDsFromMDBForBuildTag{
    param([string]$buildId)

    $request = Invoke-WebRequest -Method Get "https://jenkinsURL:8081/reserved_tests/_design/tests/_view/masterdatabase?keys=[`"$buildId`"]"
    $json = ConvertFrom-Json $request.content

    write-host "Found $($json.rows.Count) for $buildId"

    $testNames = @()

    $json.rows | %{

        $testNames += $_.id
    }

    return $testNames
}
