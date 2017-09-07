function Send-CompileFailureSummary{

    param(
        [string]$buildUrl,
        [string]$buildId,
        [string]$compileBuildUrl
    )
    Write-host "Failed compile summary"
    Write-host "Build url " $buildUrl
    write-host "Build id " $buildId
    Write-host "Compile url " $compileBuildUrl

     $testfinderUrl = "$($buildUrl)/api/xml"
     Write-host "Build URL is " $testfinderUrl
     $request = Get-WebRequest -URI $testfinderUrl -Method Get
     $xml1 = [xml]$request.Content
     $author = $xml1.freeStyleBuild.changeSet.item.user
     $commitId = $xml1.freeStyleBuild.changeSet.item.commitId

     Write-host "Commit triggered by: " $author

     Write-host "Building Hip chat Message"
     $hipchatMessage = "Per Commit Build Failure, "
     $hipchatMessage += "Author: $author, SVN revision: $commitId "
     $hipchatMessage += "<a href='http://url/$commitId'>http://url/$commitId</a> "
     $hipchatMessage += " <a href='$compileBuildUrl'>$compileBuildUrl</a>"

     $color = "red"

     Send-Hipchat -color $color `
               -apitoken "" `
               -room "" `
               -from "" `
               -notify $hipchatMessage



}

#cls
