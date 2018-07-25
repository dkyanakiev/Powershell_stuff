function Generate-JunitOutputFile{
    param(
        [string]$junit_output_file,
        [string]$classname,
        [string]$test_name,
        [string]$standard_error_string,
        [string]$duration,
        [string]$total_tests,
        [string]$failures,
        [string]$errors,
        [string]$status,
        [string]$failure_type,
        [string]$skipped,
        [switch]$debug
    )


#<testsuite errors="0" failures="0" name="Name" skipped="Classname" tests="150" time="278.7243015">
#	<testcase classname="classname" name="Test_Name.xls" time="1"></testcase>	
#	<testcase classname="classname" name="stack trace" time="378.7243015">
#		<error message="Error type" type="Error Type">
#			<![CDATA[
#				
#				TEXT HERE
#			]]>
#		</error>
#	</testcase>
#	
#</testuite>

    [System.XML.XMLDocument]$oXMLDocument=New-Object System.XML.XMLDocument
    [System.XML.XMLElement]$oXMLRoot=$oXMLDocument.CreateElement("testsuite")
    $oXMLDocument.appendChild($oXMLRoot)

    $oXMLRoot.SetAttribute("errors", $errors)
    $oXMLRoot.SetAttribute("failures", $failures)
    $oXMLRoot.SetAttribute("skipped", $skipped)
    $oXMLRoot.SetAttribute("tests", $total_tests)
    $oXMLRoot.SetAttribute("time", $duration)
    $oXMLRoot.SetAttribute("name", $test_name)

    [System.XML.XMLElement]$oXmlTestCase=$oXMLDocument.CreateElement("testcase")
    $oXMLRoot.appendChild($oXmlTestCase)

    $oXmlTestCase.SetAttribute("time", $duration)
    $oXmlTestCase.SetAttribute("name", $test_name)
    $oXmlTestCase.SetAttribute("classname", $classname)


    if($skipped.ToLower() -ne "0"){
        [System.XML.XMLElement]$skipped=$oXMLDocument.CreateElement("skipped")
        $oXmlTestCase.appendChild($skipped)
    } elseif (($failures.ToLower() -ne "0") -or ($errors.ToLower() -ne "0")) {
        [System.XML.XMLElement]$oXmlFailure=$oXMLDocument.CreateElement("error")
        $oXmlTestCase.appendChild($oXmlFailure)
        
        $message = "Test Failure Type: $failure_type"
        $oXmlFailure.setAttribute("message", $message)
        $oXmlFailure.setAttribute("type", $message)   

        $oXmlFailure.InnerXml = '<![CDATA[' + $standard_error_string + ']]>'
    }


    if($debug){
        write-host ($oXMLDocument.outerxml | out-string)
    }
    
    $parent_dir = [System.IO.FileInfo]$junit_output_file
    if ((Test-Path $parent_dir.Directory) -eq $false){
      New-Item -ItemType Directory -Path $parent_dir.Directory.FullName
    }
    
    $oXMLDocument.Save($junit_output_file)
}