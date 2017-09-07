###WArning, this will not work on HST nodes


#Requires -Version 2.0

<#
    .PARAMETER  message
     Required. The message body. 10,000 characters max.

    .PARAMETER  color
     The background colour of the HipChat message. One of "yellow", "green", "red", "purple", "gray", or "random". (default: gray)

    .PARAMETER  notify
     Set whether or not this message should trigger a notification for people in the room. (default: false)

    .PARAMETER  apitoken
     Required. This must be a HipChat API token created by a Room Admin for the room you are sending notifications to (default: API key for Test room).

    .PARAMETER  room
     Required. The id or URL encoded name of the HipChat room you want to send the message to (default: Test).

    .PARAMETER  retry
     The number of times to retry sending the message (default: 0)

    .PARAMETER  retrysecs
     The number of seconds to wait between tries (default: 30)
#>

#Required only for Powershell 2
if ($PSVersionTable.PSVersion.Major -lt 3 ){

    function ConvertTo-Json([object] $item){
        add-type -assembly system.web.extensions
        $ps_js=new-object system.web.script.serialization.javascriptSerializer
        return $ps_js.Serialize($item)
    }

}

function Send-Hipchat {

    [CmdletBinding()]
    [OutputType([Boolean])]
	Param(
        [Parameter(Mandatory = $True)][string]$message,
        [ValidateSet('yellow', 'green', 'red', 'purple', 'gray','random')][string]$color = 'gray',
        [switch]$notify,
        [Parameter(Mandatory = $True)][string]$apitoken = "",
        [Parameter(Mandatory = $True)][string]$room = "",
        [int]$retry = 5,
        [int]$retrysecs = 30,
        [string]$from = "",
        [string]$ErrorActionForThisRun = "Continue"
    )

    $old_error_action = $ErrorActionPreference
    $ErrorActionPreference = $ErrorActionForThisRun
    $messageObj = @{
        "message" = $message;
        "color" = $color;
        "notify" = [string]$notify;
        "from" = $from
    }

    $uri = "https://api.hipchat.com/v2/room/$room/notification?auth_token=$apitoken"
    $Body = ConvertTo-Json $messageObj
    $Post = [System.Text.Encoding]::UTF8.GetBytes($Body)

    $Retrycount = 0

    While($RetryCount -le $retry){
	    try {
            if ($PSVersionTable.PSVersion.Major -gt 2 ){
                Write-Host "1"
                $Response = Invoke-WebRequest -Method Post -Uri $uri -Body $Body -ContentType "application/json" -ErrorAction SilentlyContinue
            }else{
                Write-Host "2"
                $Request = [System.Net.WebRequest]::Create($uri)
                $Request.ContentType = "application/json"
                $Request.ContentLength = $Post.Length
                $Request.Method = "POST"

                $requestStream = $Request.GetRequestStream()
                $requestStream.Write($Post, 0,$Post.length)
                $requestStream.Close()

                $Response = $Request.GetResponse()

                $stream = New-Object IO.StreamReader($Response.GetResponseStream(), $Response.ContentEncoding)
                $stream.ReadToEnd() | Out-Null
                $stream.Close()
                $Response.Close()
            }
            Write-Verbose "'$message' sent!"
            $ErrorActionPreference = $old_error_action
            Return $true

        } catch {
            Write-Error "Could not send message: `r`n $_.Exception.ToString()"

             If ($retrycount -lt $retry){
                Write-Verbose "retrying in $retrysecs seconds..."
                Start-Sleep -Seconds $retrysecs
            }
        }
        $Retrycount++
    }

    Write-Verbose "Could not send after $Retrycount tries. I quit."
    $ErrorActionPreference = $old_error_action
    Return $false
}
