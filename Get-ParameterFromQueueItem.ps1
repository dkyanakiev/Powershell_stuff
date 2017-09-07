function Get-ParameterFromQueueItem{
    param(
        $queueItem,
        [string]$parameterName
    )


    foreach ($action in $queueItem.action){

        if([bool]($action.PSobject.Properties.name -match "parameter")){
            $action.parameter | %{
                if($_.name -eq $parameterName){
                    return $_.value
                }
            }
        }
    }

}