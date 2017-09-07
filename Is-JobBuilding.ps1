
function Is-JobBuilding{

    param(
        [string]$jobName,
        [string]$jobNumber
    )


    $request =  Get-WebRequest -Method "GET" -URI "https://jenkinsURL/job/$jobName/$jobNumber/api/xml?tree=building"
    $xml = [xml]$request.Content

    return $xml.freeStyleBuild.building.ToLower() -eq "true"

}
