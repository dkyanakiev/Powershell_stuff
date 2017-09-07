function Stop-TakingScreenshots{

  Get-Job -name ScreenshotTaker | %{
    Write-Host $_
    Stop-Job $_
    Write-Host (Receive-Job $_)
    Remove-Job $_

  }


}


#Stop-TakingScreenshots
