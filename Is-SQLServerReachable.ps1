function Is-SQLServerReachable{
  param(
    [string]$DB_SOURCE
  )
  Write-Host "Checking DB: $DB $DB_SOURCE"
  $sql_output_string = sqlcmd -S "Server" -U "user" -P "passwd" -d hsfaqa9037 -Q ( "select db_name() '$($DB_SOURCE)'")
  Write-Host $sql_output_string
  if ($sql_output_string -eq $DB_SOURCE){
    return $true
  } else {
    return $false
  }

}
