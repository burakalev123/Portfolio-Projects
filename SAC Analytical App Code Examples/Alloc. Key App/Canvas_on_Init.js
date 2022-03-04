
//====================================================================
// Start Initializing Application
//====================================================================
//var initStart = Date.now(); //Enable time tracking for initializing
bEnableConsole = true; //Enable console log lines for debugging
Application.setCommentModeEnabled(false); //Enable/Disable comments functionality
Application.showBusyIndicator("Initializing the application");

	//Get Version from url parameter//
	if (sVersion) {
		var dVersion = FIN_PLAN_SP.getMember("Version",sVersion);
	} else {
		dVersion = FIN_PLAN_SP.getMember("Version","public.NewForecast");
	}

	if (bEnableConsole){
		console.log(dVersion);
	}

	//Set MOR versions
	dVersion_currentMOR = dVersion;
	dVersion_previousMOR = FIN_PLAN_SP.getMember("Version", "public."+dVersion_currentMOR.properties.PREV);
	if (bEnableConsole) {console.log("Current MOR version: "+dVersion_currentMOR.id);}
	if (bEnableConsole) {console.log("Previous MOR version: "+dVersion_previousMOR.id);}

    //Apply MonthLevel to tables
	ThisApp.SetTablesTimeM(
		dVersion_currentMOR.properties.PLAN_START,
		dVersion_currentMOR.properties.PLAN_END,
		1,
		[tblInstallRev,tblUpgradeRev,tblFTE,tblWIB]); //Tables


	//Tables: Enable Refresh
	ThisApp.SetTabsRefreshPaused(tsContent.getSelectedKey());
	ThisApp.SetTabsRefreshPaused2(Tab_1_1.getSelectedKey());

	//=======================================================================================

Application.hideBusyIndicator();