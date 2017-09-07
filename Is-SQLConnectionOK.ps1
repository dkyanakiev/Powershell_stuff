function Is-SQLConnectionOK{
  param(
    [string]$Server ,
    [string]$Database ,
    [string]$UserSqlQuery = $("select db_name()"),
    [string]$UserID,
    [string]$Pass
  )

  $resultsDataTable = New-Object System.Data.DataTable
  $resultsDataTable = ExecuteSqlQuery $Server $Database $UserSqlQuery $UserId $Pass

  #validate we got data
  if($resultsDataTable.Column1 -eq $database)
  {
  return $true
  }
  else
  {
  return $false
  }

}

#$connectionStatus = Is-SQLConnectionOK -UserID "" -Pass
