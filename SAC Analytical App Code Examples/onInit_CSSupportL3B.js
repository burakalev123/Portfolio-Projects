
//====================================================================
// Start Initializing Application
//====================================================================
//var initStart = Date.now(); //Enable time tracking for initializing
bEnableConsole = true; //Enable console log lines for debugging
Application.setCommentModeEnabled(false); //Enable/Disable comments functionality
Application.showBusyIndicator("Initializing the application");

//Get Version from url parameter//
if (sVersion) {
    var dVersion = FIN_PLAN_SP.getMember("Version", sVersion);
} else {
    dVersion = FIN_PLAN_SP.getMember("Version", "public.NewForecast");
}

if (bEnableConsole) {
    console.log(dVersion);
}
//=======================================================================================
//Set MOR versions
dVersion_currentMOR = dVersion;
dVersion_previousMOR = FIN_PLAN_SP.getMember("Version", "public." + dVersion_currentMOR.properties.PREV);
if (bEnableConsole) { console.log("Current MOR version: " + dVersion_currentMOR.id); }
if (bEnableConsole) { console.log("Previous MOR version: " + dVersion_previousMOR.id); }
//=======================================================================================
/*
    //Apply QuarterLevel to tables
    ThisApp.SetTablesTimeQ(
        dVersion_currentMOR.properties.PLAN_START,
        dVersion_currentMOR.properties.PLAN_END,
        1,
        [tblServicePLbefore,tblServicePLafter,tblInstallPLbefore,tblInstallPLafter,tblUpgradePLbefore,tblUpgradePLafter]); //Tables
*/

ThisApp.SetTablesTimeRange(
    dVersion_currentMOR.properties.PLAN_START,
    dVersion_currentMOR.properties.PLAN_END,
    TimeRangeGranularity.Month, [tblServicePLbefore, tblServicePLafter, tblInstallPLbefore, tblInstallPLafter, tblUpgradePLbefore, tblUpgradePLafter]);


//Apply MonthLevel to tables
ThisApp.SetTablesTimeM(
    dVersion_currentMOR.properties.PLAN_START,
    dVersion_currentMOR.properties.PLAN_END,
    1,
    [tblServiceFTE, tblInstallPL_Perc, tblUpgradePL_Perc]); //Tables
//=======================================================================================
var i = 0;
var allZones = FIN_PLAN_SP.getMembers("CSZone", { limit: 1000 });

//Get all CS Zones into Checkbox Group
//chbCSZone2.removeAllItems();

for (i = 0; i < allZones.length; i++) {

    if (allZones[i].id.substr(0, 2) === "C0" ||
        allZones[i].id.substr(0, 2) === "CM" ||
        allZones[i].id.substr(0, 2) === "M0") {

        chbCSZone.addItem(allZones[i].id, allZones[i].id + " " + "(" + allZones[i].description + ")");
    }
}
//=======================================================================================
//Tables: Enable Refresh
ThisApp.SetTabsRefreshPaused(tsContent.getSelectedKey());
//=======================================================================================

//=======================================================================================

Application.hideBusyIndicator();