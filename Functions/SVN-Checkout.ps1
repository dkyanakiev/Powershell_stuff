function SVN-Checkout{
    param(
        [string]$url,
        [string]$username,
        [string]$password,
        [string]$location
    )

    write-host "Checking out from $url"

    if(Test-Path $location){
        cd $location
        svn revert --recursive .
        svn up
    } else {
       New-Item -ItemType Directory -Path $location
       cd $location
       svn co --username $username --password $password $url .
    }



}