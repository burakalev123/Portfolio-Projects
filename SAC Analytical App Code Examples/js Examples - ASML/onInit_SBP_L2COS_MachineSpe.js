var i = 0;

//====================================================================
// Start Initializing Application
//====================================================================
var initStart = Date.now(); //Enable time tracking for initializing
bEnableConsole = true; //Enable console log lines for debugging
Application.setCommentModeEnabled(false); //Enable/Disable comments functionality
Application.showBusyIndicator("Initializing the application");

//Log Progress
if (bEnableConsole) { console.log("First initialization processed after: " + ConvertUtils.numberToString((Date.now() - initStart) / 1000) + " seconds"); }

btnPublish.setVisible(false);

//-----------------------------------------------
// Version Dimension
//-----------------------------------------------

//Get Version MD
//---------------------
if (sVersion !== "") {
	var dVersion = FIN_PLAN_SP.getMember("Version", sVersion);
} else {
	dVersion = FIN_PLAN_SP.getMember("Version", "public.NewForecast");
}
console.log(dVersion);
//Get Current Versions
//---------------------
dVersion_currentMOR = FIN_PLAN_SP.getMember("Version", "public.NewForecast");
dVersion_currentTAP = FIN_PLAN_SP.getMember("Version", "public.NewBudget");

//-----------------------------------------------
// CS Products
//-----------------------------------------------
/*
var dCSProduct_all = FIN_PLAN_SP.getMembers("CSProduct", { limit: 500 });
var L2Accounts = ArrayUtils.create(Type.string);
var accparts = "";
var acclabor = "";

for (i = 0; i < dCSProduct_all.length; i++) { //Fab Specific
	
	if (dCSProduct_all[i].properties.CONTRACT_TYPE === "Fab Specific") {
		
		accparts = "[Account_SP].[parentId].&[" + dCSProduct_all[i].properties.COS_PRTS_PLN_ITM + "]";
		acclabor = "[Account_SP].[parentId].&[" + dCSProduct_all[i].properties.COS_LB_PLN_ITM + "]";
		
		if (accparts !== "[Account_SP].[parentId].&[]") {
			if (!L2Accounts.includes(accparts)) {
				L2Accounts.push(accparts);
			}
		}
		
		if (acclabor !== "[Account_SP].[parentId].&[]") {
			if (!L2Accounts.includes(acclabor)) {
				L2Accounts.push(acclabor);
			}
		}
	}
}

console.log("L2 ACCOUNTS");
console.log(L2Accounts);
*/
//====================================================================
// Start Widgets pre-processing
//====================================================================

//=========initialization of TABs for MOR=============================
if (sVersion === "" || sVersion === dVersion_currentMOR.id) {

	tsContent.setVisible(true);
	tsContent_TAP.setVisible(false);

	//Tables: Set Filter Member
	if (sZone) { //From URL parameter
		dZone = FIN_PLAN_SP.getMember("CSZone", sZone);
		txtHeaderTitle.applyText(txtHeaderTitle.getPlainText() + " | " + dZone.description);
		ThisApp.SetTablesFilterMember("CSZone", "[CSZone].[H1].&[" + sZone + "]",
			[tblFTEHrs, tblCOSLRates, tblCOSReportDetails, tblCOSReport, tblFTEReference]);
	}

	//Setting up the Drop Down List of Quarters 
	ThisApp.SetDropDownTimeQ(dVersion_currentMOR.properties.PLAN_START,
		dVersion_currentMOR.properties.PLAN_END,
		ddQuarter);

	//Setting up Table filters for Date-> Quarters
	ThisApp.SetTablesTimeQ(dVersion_currentMOR.properties.ACT_START,
		dVersion_currentMOR.properties.PLAN_END,
		[tblFTEHrs]);

	//Setting up Table filters for Date-> Years
	ThisApp.SetTablesTimeY(dVersion_currentMOR.properties.ACT_START,
		dVersion_currentMOR.properties.PLAN_END,
		[tblCOSLRates, tblCOSReport, tblCOSReportDetails]);

	//Set Account members for report tables
	//ThisApp.SetTablesMembers("@MeasureDimension",L2Accounts,
	//		[tblCOSReportDetails]
	//	);

	var ds = tblFTEReference.getDataSource();
	ds.setDimensionFilter("Date", "[Date].[YQM].&[" + ddQuarter.getSelectedKey() + "]");

	//Tables: Enable Refresh on Tables
	//Enable/Disable key-user functionality
	switch (Application.getUserInfo().id) {
		case "ARNKERST": case "HANJACOB": case "AAMBAUM": case "RZWEKARS": case "RESMITH":
		case "JBAEYENS": case "ALOBO": case "LDAM": case "ISOTA": case "JREIJNEN": case "RUROMBOU": case "BALEV":
			ThisApp.PauseRefreshPerTab(tsContent.getSelectedKey(), "MOR");
			break;
		default:
			ThisApp.PauseRefreshPerTab(tsContent.getSelectedKey(), "MOR");
	}
}
//====================================================================
//=========initialization of TABs for TAP=============================
else {
	tsContent.setVisible(false);
	tsContent_TAP.setVisible(true);

	//Tables: Set Filter Member
	if (sZone) { //From URL parameter
		dZone = FIN_PLAN_SP.getMember("CSZone", sZone);
		txtHeaderTitle.applyText(txtHeaderTitle.getPlainText() + " | " + dZone.description);
		ThisApp.SetTablesFilterMember("CSZone", "[CSZone].[H1].&[" + sZone + "]",
			[tblFTEHrs_TAP, tblCOSLRates_TAP, tblCOSReportDetails_TAP, tblCOSReport_TAP, tblFTEReference_TAP]
		);
	}

	//Setting up the Drop Down List of Quarters 
	ThisApp.SetDropDownTimeQ(dVersion_currentTAP.properties.PLAN_START,
		dVersion_currentTAP.properties.PLAN_END,
		ddQuarter_TAP);

	//Setting up Table filters for Date-> Quarters
	ThisApp.SetTablesTimeQ(dVersion_currentTAP.properties.ACT_START,
		dVersion_currentTAP.properties.PLAN_END,
		[tblFTEHrs_TAP]);

	//Setting up Table filters for Date-> Years
	ThisApp.SetTablesTimeY(dVersion_currentTAP.properties.ACT_START,
		dVersion_currentTAP.properties.PLAN_END,
		[tblCOSLRates_TAP, tblCOSReport_TAP, tblCOSReportDetails_TAP]);

	//Set Account members for report tables
	//ThisApp.SetTablesMembers("@MeasureDimension",L2Accounts,
	//		[tblCOSReportDetails]
	//	);

	var ds_TAP = tblFTEReference_TAP.getDataSource();
	ds_TAP.setDimensionFilter("Date", "[Date].[YQM].&[" + ddQuarter_TAP.getSelectedKey() + "]");

	ThisApp.PauseRefreshPerTab(tsContent_TAP.getSelectedKey(), "TAP");
}
//====================================================================
//====================================================================
//End Initialization
//====================================================================

//Hide Indicator
Application.hideBusyIndicator();
