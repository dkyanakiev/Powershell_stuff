function Parse-OutputXmlStatus{
    param(
        [string]$xml_input,
        [switch]$debug
    )

    try{
        if($debug){ Write-Host "Attempting to read $xml_input"}
        [xml]$test_xml = Get-Content $xml_output

        if($debug){
            write-host "Test Status Attribute: " + $test_xml["batch_run"]["scenario_results"]["scenario_result"].status
        }
        return $test_xml["batch_run"]["scenario_results"]["scenario_result"].status
    } catch [System.Exception]{
        return "error"
    }
}