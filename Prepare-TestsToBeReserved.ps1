function Prepare-TestsToBeReserved(){
    param(
        $buildName,
        $revision,
        $testListOverwrite
    )
    Add-TestsToReservationDb -revision $revision `
                             -testListDb $(Get-TestListDb) `
                             -testReservationDb $(Get-TestReservationDb) `
                             -dbUri $(Get-CouchDBUrl) `
                             -buildId $buildName `
                             -customTestListOverwrite $testListOverwrite
}

#cls
#Prepare-TestsToBeReserved -tests "analytics_processes\1_eq_common_stock_valuation.xls analytics_processes\client_columns_currency_pair_grouper.xls analytics_processes\client_columns_fx_drift_using_both_fo_and_bo_logic.xls" -buildName FromString
#Prepare-TestsToBeReserved -tests "" -buildName test_build_name -revision 674392