function Start-TakingScreenshots{
    param($outputdir,$interval,$screenshotfunction)

    if(-not (test-path $outputdir))
    {
        New-Item $outputdir -ItemType Directory
    }

    Start-Job -name ScreenshotTaker -ScriptBlock {
       param($outputdir,$interval,$screenshotfunction)
       . $screenshotfunction
       while($true)
       {

          Take-ScreenShot -file (Join-Path $outputdir ("$(Get-Date -Format yyyy-MM-dd-hh-mm-ss).png")) -screen -imagetype png
          sleep $interval
       }



    } -argumentlist $outputdir,$interval,$screenshotfunction

}
