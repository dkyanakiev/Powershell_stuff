function Build-HTMLBuildSammary{
    param(
        [string]$dashboardUrl,
        $passingTests,
        $failingTests,
        $otherTests

    )

$listOfFalingTests = ""

$failingTests | %{

    $listOfFalingTests += "<tr><td>"
    $listOfFalingTests += "<a href='"

    $listOfFalingTests += $_.build_url
    $listOfFalingTests += "/standard_out/"

    $listOfFalingTests += $_.test.Replace("`\", "/").replace(".xls", ".txt")
    $listOfFalingTests += "'>"
    $listOfFalingTests += $_.test

    $listOfFalingTests += "</a>"
    $listOfFalingTests += "</td></tr>"
}

$html = @"
<html>
    <body border='1px'>
        <a href='$dashboardUrl'>Full test summary<a><br/><br/>
        Total Tests: $($failingTests.Count + $passingTests.Count + $otherTests.count)<br/>
        Passing: $($passingTests.Count)<br/>
        Failing: $($failingTests.Count)<br/>
        Skipped: $($otherTests.count)<br/>
        <hr/>



        <table>
            <thead>
                <th>List of Failing tests</th>
            </thead>
            <tbody>
                $listOfFalingTests
            </tbody>
        </table>

    </body>
</hmtl>
"@


    return $html
}
