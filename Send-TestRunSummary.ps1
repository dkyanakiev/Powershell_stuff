function Send-TestRunSummary{

    param(
        [string]$buildId
    )

     $summary = Collect-TestSummary -buildId $buildId -dbUrl "https://jenkinsURL:8081" -dbName "reserved_tests"

     $htmlSummary = Build-HTMLBuildSammary  -dashboardUrl "https://jenkinsURL/userContent/Dashboard/summary.html?build_id=$buildId" -passingTests $summary["passing"] -failingTests $summary["failing"] -otherTests $summary["other"]


     write-host "Sending out summary email for $buildId"


     $subject = "Build: $($buildId.split('-')[2]) " + $summary["svn"] + " (Ran: $($summary['passing'].Count + $summary['failing'].Count + $summary['other'].Count), $($summary['passing'].Count)/$($summary['failing'].Count)) "

     $hipchatMessage = "Test Reducer Build Number: $($buildId.split('-')[2]) SVN Rev: $($summary['svn'])<br/>"
     $hipchatMessage += "Total: $($summary['passing'].Count + $summary['failing'].Count + $summary['other'].Count), "
     $hipchatMessage += "Pass: $($summary['passing'].Count), "
     $hipchatMessage += "Fail: $($summary['failing'].Count), "
     $hipchatMessage += "Skipped: $($summary['other'].Count)<br/>"
     $hipchatMessage += "<a href='https://jenkinsURL/userContent/Dashboard/summary.html?build_id=$buildId'>https://jenkinsURL/userContent/Dashboard/summary.html?build_id=$buildId</a>"

     $color = "gray"

    if (($summary['failing'].Count -eq 0) -and ($summary['passing'].Count -ne 0) -and ($summary['other'].Count -eq 0) ){
        $color = "green"
     } elseif(($summary['failing'].Count -eq 0) -and ($summary['passing'].Count -ne 0) -and ($summary['other'].Count -ne 0)){
        $color = "yellow"
     }elseif ($summary['failing'].Count -gt 0){
        $color = "red"
     }

     Send-Hipchat -color $color `
               -apitoken "ggABIbuvVAXi6vbsNCAbEYMrvIBlKEJ1pu9zRkhd" `
               -room "HsMain Test Reducer" `
               -from "Asgard Test Reducer" `
               -notify $hipchatMessage


     #Send-MailMessage -SmtpServer "mail.$($env:userdnsdomain)" `
     #              -Subject $subject `
     #              -To "test-reducer-errors@Directory.com" `
     #              -From "HS-Dev-Release@Directory.com"`
     #              -BodyAsHtml $htmlSummary

                   # -To "" `
}

#cls
#Send-TestRunSummary -buildId "jenkins-TestBuildOpt-215"
