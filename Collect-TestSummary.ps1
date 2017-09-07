function Collect-TestSummary{
    param(
        [string]$buildId,
        [string]$dbUrl,
        [string]$dbName


    )

    $summary = @{}
    $summary["passing"] = @()
    $summary["failing"] = @()
    $summary["other"] = @()
    $summary["svn"] = ""


    $request = Invoke-WebRequest -Method Get -Uri "$dbUrl/$dbName/_design/tests/_view/all?keys=[%22$buildId%22]&include_docs=true"

    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")
    $jsonserial= New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer
    $jsonserial.MaxJsonLength  = 67108864
    $json = $jsonserial.DeserializeObject($request.content)


   foreach ($row in $json.rows){

       if($row.doc.result -eq "True" -or $row.doc.result -eq "True"){

         $summary["passing"] += $row.doc
         $summary["svn"] = "SVN Rev: " + $row.doc.svn_revision
       } elseif ($row.doc.result -eq "False" -or $row.doc.result -eq "False"){
            $summary["failing"] += $row.doc
            $summary["svn"] = "SVN Rev: " + $row.doc.svn_revision
       } else {
            $summary["other"] += $row.doc
            if($row.doc.svn_revision -ne $null -and $row.doc.svn_revision -ne ""){
              $summary["svn"] = "SVN Rev: " + $row.doc.svn_revision
            }
       }


   }
    return $summary
}

#cls
#$a = Collect-TestSummary -buildId "" -dbUrl "" -dbName "tests"
