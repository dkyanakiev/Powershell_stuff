
function Get-TestIDsFromDbForBuildTag{
    param([string]$buildId)

    $request = Invoke-WebRequest -Method Get "https://jenkinsURL:8081/reserved_tests/_design/tests/_view/all?keys=[%22$buildId%22]"
    $json = ConvertFrom-Json $request.content

    write-host "Found $($json.rows.Count) for $buildId"

    $testNames = @()

    $json.rows | %{
    
        $testNames += $_.id
    }

    return $testNames
}

#cls
#$a = Get-TestIDsFromDbForBuildTag -buildId "jenkins-TestBuildOpt-228"