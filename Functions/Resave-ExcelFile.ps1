function Resave-ExcelFile{
	param(
		[string]$file,
		[switch]$debug
	)
	
	if ($debug){
		Write-Host "Updating file $file"
	}

	#Set security
	$objExcel=New-Object -ComObject Excel.Application
	$objExcel.Visible=$false #Keep the Excel Window invisible
	$objExcel.DisplayAlerts = $false #Disable any alerts such as save/error dialogs
	$objExcel.AutomationSecurity = "msoAutomationSecurityLow" #Allow all macros to run
	
	$WorkBook=$objExcel.Workbooks.Open($file)

	$WorkBook.UpdateLinks = 3 #Set the update links property for external links in cell. No clue what 3 means.
	
	if ($debug -and $WorkBook.ReadOnly){
		Write-Host -foreground red "File $file is READ ONLY"
	}
	
	$WorkBook.CheckCompatibility = $false
	
	
	
	$WorkBook.Save()
	$WorkBook.Close()
	
	
	$objExcel.Quit()
	Get-Process -Name *excel* | %{ 			
			if ($debug){
				write-host "Force killing $($_.ProcessName) PID: $($_.Id)"
			}
			Stop-Process -Id $_.Id -Force 
		
		}
	
}