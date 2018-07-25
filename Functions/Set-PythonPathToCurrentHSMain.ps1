function Set-PythonPathToCurrentHSMain{
  $env:PYTHONPATH=$(Get-CurrentHSMainPath)
}
