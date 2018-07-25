function SelectFileFromGit{
param(
  [string]$filePath = "",
  [string]$fileFromGit = ""
)
  Write-host "Git selection"

  $fileNames = Get-ChildItem -Path (Join-Path $($env:workspace) "Folder") -Recurse -Include *.*

  foreach($file in $fileNames){
      # Write-host "file: " $file
      # Write-host "File path: " $filePath
    if($file.FullName.contains($filePath) -eq $true){
      Write-host "Found a match with the user: $($filePath)"
      $fileFromGit = $file.FullName
    }

  }
  if($fileFromGit -eq "" -or $fileFromGit -eq $null){
    Write-host "FILE DOES NOT EXIST"
    exit 1
  }

  return $fileFromGit
}
