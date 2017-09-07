function Get-CurrentHSMainPath{
    return "C:\Directory\" + $(Get-Content "C:\Directory\version.file")
}
