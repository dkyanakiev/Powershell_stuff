function Reload-Database{
  param(
    [string]$db
  )
    $DB_SOURCE = $db
    Write-Host "Reloading DB from $DB_SOURCE"

    $timmer = [Diagnostics.Stopwatch]::StartNew()

		$out_file = "reload_db_log.txt"
		sqlcmd -S "server" -U user -P passwd -d MetaData -Q " exec stored.procedure" '$($DB_SOURCE)', 'qa$($env:QA_ENV_1)'" | Out-File -Encoding default -FilePath $out_file
    $sql_reload_exit_code = $?

		$out = Get-Content -Path $out_file
    $timmer.Stop()

    write-host "Took $($timmer.Elapsed.TotalSeconds) seconds"

    if ($sql_reload_exit_code -ne $true -or $out -ne "completed successfuly"){

	    if($out.ToLower().contains("there is an ongoing request")){
		    Write-Host $($out | Out-String)
		    Write-Host "Waiting for previous reload to finish"
		    sleep 300

		    sqlcmd -S "server" -U user -P passwd -d MetaData -Q " exec stored.procedure" '$($DB_SOURCE)', 'qa$($env:QA_ENV_1)'"  | Out-File -Encoding default -FilePath $out_file
		    $sql_reload_exit_code = $?
				$out = Get-Content -Path $out_file

		    if ($sql_reload_exit_code -ne $true -or $out -ne "completed successfuly"){
			    write-host "DB reload from $DB_SOURCE failed"
			    write-host $($out | Out-String)
			    exit 1
		    }
	    }else {
		    write-host "DB reload from $DB_SOURCE failed"
		    write-host $($out | Out-String)
		    exit 1
	    }
    }
}
