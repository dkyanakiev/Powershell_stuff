function Add-TestsToReservationDb(){
    param(
        [string]$revision,
        [string]$testListDb,
        [string]$testReservationDb,
        [string]$dbUri,
        [string]$buildId,
        [string]$customTestListOverwrite
    )

    write-host "Custom overwrite: ' $customTestListOverwrite '"

    if($customTestListOverwrite -eq $null -or $customTestListOverwrite -eq ""){
        $queryView = "_design/test/_view/sort_by_revision?keys=[`"$revision`"]"
        $listUrl = "$($dbUri)/$($testListDb)/$($queryView)"

        write-host "List DB $listUrl"

        $responsse = Invoke-WebRequest -Method GET -Uri $listUrl

        $parsedContent = ConvertFrom-Json $responsse.Content
        $tests = $parsedContent.rows[0].value

        $test_hashmap = Convert-TestsToHash $tests

    } else {
        Write-Host "Custome test list overwrite was triggered. The test value is $customTestListOverwrite"
        $test_hashmap = @{}

        Write-Host "Fixing slashes"
        $customTestListToOverwrite = $customTestListOverwrite.Replace('/', '\')
        Write-Host $customTestListToOverwrite
        $test_hashmap["manually_triggered"] = $customTestListToOverwrite.split(" ").split(",")
    }

    $allIsGood = $true

    $bulk_doc = @{"docs" = @()}

    $unique_test_collapsing_hash = @{}

    foreach ($class in $test_hashmap.keys){
        foreach ($t in $test_hashmap[$class]){
            if ($unique_test_collapsing_hash[$t] -ne $null){
              $unique_test_collapsing_hash[$t]["affected_class"] += ",$class"
            } else {

            $payload = @{"svn_revision" = $revision}
            $payload["build_id"] = $buildId
            $payload["test"] = $t
            $payload["node"] = ""
            $payload["status"] = "Not Started"
            $payload["result"] = ""
            $payload["rerun_result"] = ""
            $payload["start_time"] = ""
            $payload["finish_time"] = ""
            $payload["build_url"] = ""
            $payload["base_build_url"] = "$ENV:BUILD_URL"
            $payload["affected_class"] = $class

            #if (Should-SkipClass $class){
            #    $payload["status"] = "Skipped"
            #    $payload["skip_reason"] = "$class is on ignore list"
            #    $payload["node"] = $(hostname)
            #}

            $unique_test_collapsing_hash[$t] = $payload
            }
        }
    }

    foreach ($test_hash in $unique_test_collapsing_hash.Values){
      $bulk_doc["docs"] += $test_hash
    }

    $targetUrl = "$($dbUri)/$($testReservationDb)/_bulk_docs"
    write-host "Saving test to $targetUrl"

    $r = Invoke-WebRequest -Method Post -ContentType "application/json" -Uri $targetUrl  -Body (ConvertTo-Json $bulk_doc)

    $response = ConvertFrom-Json $r.Content

    write-host "$($dbUri)/$($testReservationDb)/_design/tests/_view/unreserved?keys=[`"$buildId`"]"
    foreach ($row in $response){
        if ($row.ok -eq $true){
            Write-Host -ForegroundColor Green "Saved $($row.id)"
        }else {
            $allIsGood = $false
            Write-Host -ForegroundColor RED "Error saving $row to $targetUrl"
        }
    }
    return $allIsGood

}

#cls
#Add-TestsToReservationDb -revision 2 -testListDb "test" -testReservationDb "testreserve" -dbUri "http://localhost:5984" -buildId abc
