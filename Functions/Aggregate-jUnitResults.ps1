

function Aggregate-jUnitResults(){
  param(
    $outputDir = "c:\jUnit",
    $build,
    $stdOutDir = "c:\standard_out"
  )

  $build = $build + "/api/xml?depth=1"

  if (Test-Path $outputDir){
      rm -Recurse -Force $outputDir
  }

  mkdir $outputDir

  if (Test-Path $stdOutDir){
    rm -Recurse -Force $stdOutDir
  }

  mkdir $stdOutDir

  $request = Get-WebRequest -Method GET -URI $build
  $xml = [xml]$request.Content

  $builds = @()
  $errorfile = "errors.txt"

 Write-Host $request
 Write-host $builds
  foreach ($a in $xml.freeStyleBuild.action){

      if (($a -ne $null) -and ($a -ne "")){
          if ($a.InnerXml.Contains("triggeredBuild")){
          $a.triggeredBuild | %{
              if ($_.url.toSTring().toLower().contains("run_test_on_node")){
                  $builds += $_.url
              }
           }

              break
          }
      }

  }

  foreach ($b in $builds){
      $request = Get-WebRequest -Method GET -URI "$($b)api/xml?depth=1"
      $xml = [xml]$request.Content

      write-host -ForegroundColor Cyan $b
      foreach ($artifact in $xml.freeStyleBuild.artifact){
          if(($artifact.fileName.Contains(".xml")) -and (-not $artifact.fileName.Contains("run_times.xml")) -and (-not $artifact.fileName.Contains("aaa"))){
              $url = "$($b)/artifact/$($artifact.relativePath)"
              Write-Host "Downloading $url"

              (New-Object net.webclient).Downloadfile($url, (Join-Path $outputDir $artifact.fileName))
          }

          if(($artifact.fileName.Contains(".txt")) -and (-not $artifact.fileName.Contains("aaa"))){

            $errors = $artifact | Foreach-Object {
                       $content = Get-Content $_.FullName
                       $content | Where-Object {$_ -match '^AssertionError'}
                       $content | Where-Object {$_ -match '^FAILED'}

                    }



              $url = "$($b)/artifact/$($artifact.relativePath)"
              Write-Host "Downloading $url"
              $savePath = (Join-Path $  $artifact.relativePath).ToLower().Replace("standard_out\standard_out", "standard_out")

              if (-not (Test-Path ([System.IO.FileInfo]$savePath).Directory)){
                New-Item -ItemType Directory -Path ([System.IO.FileInfo]$savePath).Directory.FullName
              }
              (New-Object net.webclient).Downloadfile($url, $savePath)
              $outerrorfile = Join-Path $savePath $errorfile
              $errors | Out-File $outerrorfile

          }
      }
  }



}

#Aggregate-jUnitResults -build "http://JenkinsURL/job/Run_Asgard_Tests/66/"

#http://JenkinsURL/job/Run_Test_On_Node/159/artifact/jUnit/bus_apps/aaa_bus_apps.xml

#http://JenkinsURL/job/Run_Test_On_Node/159/artifact/*zip*/archive.zip
