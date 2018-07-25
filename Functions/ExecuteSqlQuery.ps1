# executes a query and populates the $datatable with the data
function ExecuteSqlQuery ($Server, $Database, $SQLQuery, $UserID, $Pass) {
    $Datatable = New-Object System.Data.DataTable

    $Connection = New-Object System.Data.SQLClient.SQLConnection
    $Connection.ConnectionString = "server='$Server';database='$Database';trusted_connection=true;User ID = '$UserID';Password='$Pass';"
    $Connection.Open()
    $Command = New-Object System.Data.SQLClient.SQLCommand
    $Command.Connection = $Connection
    $Command.CommandText = $SQLQuery
    $Reader = $Command.ExecuteReader()
    $Datatable.Load($Reader)
    $Connection.Close()

    return $Datatable
}
