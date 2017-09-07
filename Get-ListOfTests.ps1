function Get-ListOfTests(){
    param(
        [Parameter(Mandatory=$true)]$url,
        $maximum = -1
    )

    $tempFile = "C:\temp\fileList.txt"

   #$wc = New-Object net.webclient
   $(Get-WebClient).Downloadfile($url, $tempFile)

   $tests = Get-Content $tempFile

   if ($maximum -eq -1){
        return $tests
   } else {
        if ($tests.Length -le $maximum){
            #If the current test lenght is less then or equal to maximum, then return it as is
            return $tests
        }

        $returnArray = @()
        for ($i = 1; $i -le $maximum; $i++){
            $returnArray += ($tests | Get-Random)
        }
        return $returnArray
   }

}

#cls
