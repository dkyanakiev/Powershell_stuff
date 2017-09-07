function Print-TestStatusSummary(){
  param(
    [string]$buildId,
    [string]$dbUrl,
    [string]$dbName
  )

  $old_error_action = $ErrorActionPreference
  $ErrorActionPreference = "Continue"
  $r = Invoke-WebRequest -Method Get -Uri "$($dbUrl)/$($dbName)/_design/tests/_view/unreserved?keys=[`"$($buildId)`"]"
  $notStarted = ConvertFrom-Json $r.content

  $r = Invoke-WebRequest -Method Get -Uri "$($dbUrl)/$($dbName)/_design/tests/_view/reserved?keys=[`"$($buildId)`"]"
  $started = ConvertFrom-Json $r.content

  $finished = 0
  $running = 0
  $summary = @{}

  $started.rows | %{

    if($summary[$_.value] -eq $null){
      $summary[$_.value] = 0
    }

    $summary[$_.value] += 1
    }

  Write-Host "Test Run Summary"
  Write-Host "Not Started: $($notStarted.rows.Length), Reserved: $($started.rows.Length)"
  Write-Host ($summary | Out-String)

  $ErrorActionPreference = $old_error_action
}
