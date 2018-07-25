function Notify-DeployToNodesFailed{
  param(
    [string]$failureRate,
    $failedNodes
  )

  Send-MailMessage -SmtpServer "mail.Directorytest.com" `
                   -Subject "More than $($failureRate)% of nodes failed to deploy" `
                   -To $(Get-TestReducerEnvironmentFailureEmail) `
                   -From "ME"`
                   -Body "Build: $($env:BUILD_URL)`r`n`r`n $($failedNodes -join ',')"


}
