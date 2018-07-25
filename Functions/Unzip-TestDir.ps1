function Unzip-TestDir(){
  param([Parameter(Mandatory=$true)]$tests, 
        [Parameter(Mandatory=$true)]$zip_folder, 
        [Parameter(Mandatory=$true)]$workspace)


  if ((Test-Path $zip_folder) -eq $false){
    Write-Host "Zip folder not there"
    exit 1
  } 

  if (-not (Test-Path $workspace)){
    mkdir $workspace
  }

  $somethingFailed=$false

  foreach($t in $tests){
    write-host "Unzipping tests suite for $t"
    $stack_name = Get-SuiteName -testName $t
    if ($stack_name -eq $null){
      Write-Host -ForegroundColor RED "Can't parse $t"
      $somethingFailed=$true
    }
    
    if(-not (Test-Path (Join-Path $workspace "$($stack_name).zip"))){
      Write-Host "The zip file is not yet downloaded, downloading now"
      Download-AcceptanceTestsZipByName -zip_folder ( join-path $zip_folder "$($stack_name).zip")
    }

    if (Test-Path (Join-Path $workspace $stack_name)){
      Write-Host "$stack_name already unzipped"
    } else {
      Write-Host "Unzipping $stack_name"
      Unzip-TestFiles -stack $stack_name -zip "$stack_name.zip" -artifactsDir $zip_folder -workspace $workspace
    }
  }


  if($somethingFailed){
      Write-Host -ForegroundColor RED "Something failed"
      exit 1
  }
}