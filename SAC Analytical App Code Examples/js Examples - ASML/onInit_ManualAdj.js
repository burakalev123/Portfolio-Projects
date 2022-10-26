
//====================================================================
// Start Initializing Application
//====================================================================
//var initStart = Date.now(); //Enable time tracking for initializing
bEnableConsole = true; //Enable console log lines for debugging
Application.setCommentModeEnabled(false); //Enable/Disable comments functionality
Application.showBusyIndicator("Initializing the application");

//Log Progress
//if (bEnableConsole) {console.log("First initialization processed after: "+ConvertUtils.numberToString((Date.now()-initStart)/1000)+" seconds");}

//Get Version from url parameter//
/*
if (sVersion) {
    var dVersion = FIN_PLAN_SP.getMember("Version", sVersion);
} else {
    dVersion = FIN_PLAN_SP.getMember("Version", "public.NewForecast");
}
*/
//=======================================================================================
//-----------------------------------------------
// Version Dimension
//-----------------------------------------------
dVersion_currentMOR = FIN_PLAN_SP.getMember("Version", "public.NewForecast");
dVersion_currentTAP = FIN_PLAN_SP.getMember("Version", "public.NewBudget");

dVersion_previousMOR = FIN_PLAN_SP.getMember("Version", "public." + dVersion_currentMOR.properties.PREV);
dVersion_previousTAP = FIN_PLAN_SP.getMember("Version", "public." + dVersion_currentTAP.properties.PREV);

if (bEnableConsole) { console.log("Current MOR version: " + dVersion_currentMOR.id); }
if (bEnableConsole) { console.log("Current TAP version: " + dVersion_currentTAP.id); }
if (bEnableConsole) { console.log("Selected Version: " + sVersion); }
//=======================================================================================

if (sVersion === "" || sVersion === dVersion_currentMOR.id) {

    tsContent.setVisible(true);
    tsContent_TAP.setVisible(false);

    //Set TimeRange for input tables
    ThisApp.SetTablesTimeRange(
        dVersion_currentMOR.properties.PLAN_START,
        dVersion_currentMOR.properties.PLAN_END,
        TimeRangeGranularity.Month, [tblManualInput1, tblManualInput2, tblManualInput_Report]);

    //Set current MOR version for input tables
    ThisApp.SetTablesVersion([dVersion_currentMOR.id],
        [tblManualInput1, tblManualInput2]
    );

    //Enable Refresh for all tables
    ThisApp.SetTablesRefreshPaused(false, [], [tblManualInput1, tblManualInput2]);
} else {

    tsContent.setVisible(false);
    tsContent_TAP.setVisible(true);

    //Set TimeRange for input tables
    ThisApp.SetTablesTimeRange(
        dVersion_currentTAP.properties.ACT_START,
        dVersion_currentTAP.properties.PLAN_END,
        TimeRangeGranularity.Month,
        [tblInput_TAP]
    );
    //Set current MOR version for input tables
    ThisApp.SetTablesVersion([dVersion_currentTAP.id],
        [tblInput_TAP]
    );

    //Enable Refresh for all tables
    ThisApp.SetTablesRefreshPaused(false, [], [tblInput_TAP]);
}
//=======================================================================================

//=======================================================================================
//Tables: Enable Refresh
ThisApp.SetTabsRefreshPaused(tsContent.getSelectedKey());
//=======================================================================================

//=======================================================================================

Application.hideBusyIndicator();