var i = 0;

//====================================================================
// Start Initializing Application
//====================================================================
var initStart = Date.now(); //Enable time tracking for initializing
bEnableConsole = true; //Enable console log lines for debugging
Application.setCommentModeEnabled(false); //Enable/Disable comments functionality
Application.showBusyIndicator("Initializing the application");



//Log Progress
if (bEnableConsole) {console.log("First initialization processed after: "+ConvertUtils.numberToString((Date.now()-initStart)/1000)+" seconds");}



//-----------------------------------------------
// Version Dimension
//-----------------------------------------------


//get Version from master data STATUS property
dVersion_all = FIN_PLAN_SP.getMembers("Version",{limit:200});
for (i=0;i<dVersion_all.length; i++) {
	switch (dVersion_all[i].properties.STATUS) {
		case "CURRENTMOR":
			if (dVersion_currentMOR===undefined) {
				dVersion_currentMOR = dVersion_all[i];
			}
			break;
		case "CURRENTTAP":
			if (dVersion_currentTAP===undefined) {
				dVersion_currentTAP = dVersion_all[i];
			}
			break;
	}
}

dVersion_previousMOR = FIN_PLAN_SP.getMember("Version", "public."+dVersion_currentMOR.properties.PREV);
dVersion_previousTAP = FIN_PLAN_SP.getMember("Version", "public."+dVersion_currentTAP.properties.PREV);

if (bEnableConsole) {console.log("Current MOR version: "+dVersion_currentMOR.id); console.log("Previous MOR version: "+dVersion_previousMOR.id);}
if (bEnableConsole) {console.log("Current TAP version: "+dVersion_currentTAP.id); console.log("Previous TAP version: "+dVersion_previousTAP.id);}

//-----------------------------------------------
// CS Products
//-----------------------------------------------
/*var dCSProduct_all = FIN_PLAN_SP.getMembers("CSProduct",{limit:500});
var L2Accounts = ArrayUtils.create(Type.string);
var accparts = "";
var acclabor = "";
for (i=0;i<dCSProduct_all.length; i++) { //Machine Specific
	if (dCSProduct_all[i].properties.CONTRACT_TYPE === "Machine Specific") {
		accparts = "[Account_SP].[parentId].&["+dCSProduct_all[i].properties.COS_PRTS_PLN_ITM+"]";
		acclabor = "[Account_SP].[parentId].&["+dCSProduct_all[i].properties.COS_LB_PLN_ITM+"]";
		if (accparts !== "[Account_SP].[parentId].&[]") {if (!L2Accounts.includes(accparts)){L2Accounts.push(accparts);}}
		if (acclabor !== "[Account_SP].[parentId].&[]") {if (!L2Accounts.includes(acclabor)){L2Accounts.push(acclabor);}}
	}
}
console.log("L2 ACCOUNTS determined");
console.log(L2Accounts);*/
//====================================================================
// Start Widgets pre-processing
//====================================================================


if (sVersion==="" || sVersion === dVersion_currentMOR.id){
	
	tsContent_TAP.setVisible(false);
	tsContent.setVisible(true);
	
	//Tables: Set Filter Member
	if (sZone) { //From URL parameter
		dZone = FIN_PLAN_SP.getMember("CSZone",sZone);
		txtHeaderTitle.applyText(txtHeaderTitle.getPlainText()+" | "+dZone.description);
		ThisApp.SetTablesFilterMember("CSZone",
									  "[CSZone].[H1].&["+sZone+"]",
									  [tblInstallBase,tblInstallBaseCS,tblCOSM,tblCOSMQ,tblCOSLHrs,tblCOSLHrsQ,tblCOSLRates,tblCOSReport,tblCOSReport2]
		);
		console.log("CS Zone Filter Applied");
		/*ThisApp.SetTablesFilterMember("SiteCluster.Z_KATR9",
									  sZone,
									  [tblCOSLRates]
		);*/
	}


	//Tables: Apply Time horizon
	/*ThisApp.SetTablesTimeRange(dVersion_currentMOR.properties.ACT_START,
							   dVersion_currentMOR.properties.PLAN_END,
							   TimeRangeGranularity.Year,2,
							   [tblCOSLRates]);
	ThisApp.SetTablesTimeRange(dVersion_currentMOR.properties.ACT_START,
							   dVersion_currentMOR.properties.PLAN_END,
							   TimeRangeGranularity.Quarter,3,
							   [tblCOSM,tblCOSLHrs]);*/
	ThisApp.SetDropDownTimeQ(dVersion_currentMOR.properties.PLAN_START,
							   dVersion_currentMOR.properties.PLAN_END,
							ddQuarter);
	ThisApp.SetDropDownTimeQ(dVersion_currentMOR.properties.PLAN_START,
							   dVersion_currentMOR.properties.PLAN_END,
							ddQuarterB);
	
	ThisApp.SetTablesTimeQ(dVersion_currentMOR.properties.ACT_START,
							   dVersion_currentMOR.properties.PLAN_END,
							   [tblCOSM,tblCOSLHrs]);
	ThisApp.SetTablesTimeY(dVersion_currentMOR.properties.PLAN_START,
							   dVersion_currentMOR.properties.PLAN_END,
							   [tblInstallBase,tblInstallBaseCS,tblCOSLRates,tblCOSReport,tblCOSReport2]);

	tblCOSMQ.getDataSource().setDimensionFilter("Date","[Date].[YQM].&["+ddQuarter.getSelectedKey()+"]");
	tblCOSLHrsQ.getDataSource().setDimensionFilter("Date","[Date].[YQM].&["+ddQuarterB.getSelectedKey()+"]");
	console.log("Time Filter Applied");

	//Tables: Set Version
	ThisApp.SetTablesVersion([dVersion_currentMOR.id],
							 [tblCOSM,tblCOSLHrs,tblCOSLRates]
	);

	//Set Account members for report tables
	/*ThisApp.SetTablesMembers("@MeasureDimension",L2Accounts,
			[tblCOSReport,tblCOSReport2]
		);
	console.log("L2 Accounts Applied");*/

	//Tables: Enable Refresh on Tables
	//Enable/Disable key-user functionality
	switch (Application.getUserInfo().id) {
		case"DIWOLTER":case"HANJACOB":case"AAMBAUM":case"RZWEKARS":case"RESMITH":
		case"JBAEYENS":case"ALOBO":case"LDAM":case"ISOTA":case"JREIJNEN":case"RUROMBOU":case"IVRIJ":
/*		ThisApp.SetTablesRefreshPaused(false,
									   [tblInstallBase,tblInstallBaseCS,tblCOSReport,tblCOSReport2], //reports
									   [tblCOSM,tblCOSMQ,tblCOSLHrs,tblCOSLHrsQ,tblCOSLRates]
									  ); */
ThisApp.PauseRefreshPerTab(tsContent.getSelectedKey(), "MOR");
		break;
		default:
		btnCalcIB.setVisible(true); //hide manual install base calculation
/*		ThisApp.SetTablesRefreshPaused(false,
									   [tblInstallBase,tblInstallBaseCS,tblCOSReport,tblCOSReport2], //reports
									   [tblCOSM,tblCOSMQ,tblCOSLHrs,tblCOSLHrsQ,tblCOSLRates]
									  ); //input*/
ThisApp.PauseRefreshPerTab(tsContent.getSelectedKey(), "MOR");
	}
	
} else {
	
	tsContent.setVisible(false);
	tsContent_TAP.setVisible(true);
	
	//Tables: Set Filter Member
	if (sZone) { //From URL parameter
		dZone = FIN_PLAN_SP.getMember("CSZone",sZone);
		txtHeaderTitle.applyText(txtHeaderTitle.getPlainText()+" | "+dZone.description);
		ThisApp.SetTablesFilterMember("CSZone",
									  "[CSZone].[H1].&["+sZone+"]",
									  [tblInstallBase_TAP, tblInstallBaseCS_TAP, tblCOSM_TAP, tblCOSMQ_TAP, tblCOSLHrs_TAP, tblCOSLHrsQ_TAP, tblCOSLRates_TAP, tblCOSReport_TAP, tblCOSReport2_TAP]
		);
		console.log("CS Zone Filter Applied");
		/*ThisApp.SetTablesFilterMember("SiteCluster.Z_KATR9",
									  sZone,
									  [tblCOSLRates]
		);*/
	}


	//Tables: Apply Time horizon
	/*ThisApp.SetTablesTimeRange(dVersion_currentMOR.properties.ACT_START,
							   dVersion_currentMOR.properties.PLAN_END,
							   TimeRangeGranularity.Year,2,
							   [tblCOSLRates]);
	ThisApp.SetTablesTimeRange(dVersion_currentMOR.properties.ACT_START,
							   dVersion_currentMOR.properties.PLAN_END,
							   TimeRangeGranularity.Quarter,3,
							   [tblCOSM,tblCOSLHrs]);*/
	ThisApp.SetDropDownTimeQ(dVersion_currentTAP.properties.PLAN_START,
							   dVersion_currentTAP.properties.PLAN_END,
							ddQuarter_TAP);
	ThisApp.SetDropDownTimeQ(dVersion_currentTAP.properties.PLAN_START,
							   dVersion_currentTAP.properties.PLAN_END,
							ddQuarterB_TAP);
	
	ThisApp.SetTablesTimeQ(dVersion_currentTAP.properties.ACT_START,
							   dVersion_currentTAP.properties.PLAN_END,
							   [tblCOSM_TAP,tblCOSLHrs_TAP]);
	ThisApp.SetTablesTimeY(dVersion_currentTAP.properties.PLAN_START,
							   dVersion_currentTAP.properties.PLAN_END,
							   [tblInstallBase_TAP,tblInstallBaseCS_TAP,tblCOSLRates_TAP,tblCOSReport_TAP,tblCOSReport2_TAP]);

	//tblCOSMQ.getDataSource().setDimensionFilter("Date","[Date].[YQM].[Date.CALMONTH].["+ddQuarter.getSelectedKey()+"]");
	tblCOSMQ_TAP.getDataSource().setDimensionFilter("Date","[Date].[YQM].&["+ddQuarter_TAP.getSelectedKey()+"]");
	tblCOSLHrsQ_TAP.getDataSource().setDimensionFilter("Date","[Date].[YQM].&["+ddQuarterB_TAP.getSelectedKey()+"]");
	console.log("Time Filter Applied");

	//Tables: Set Version
	ThisApp.SetTablesVersion([dVersion_currentTAP.id],
							 [tblCOSM_TAP,tblCOSLHrs_TAP,tblCOSLRates_TAP]
	);

	//Set Account members for report tables
	/*ThisApp.SetTablesMembers("@MeasureDimension",L2Accounts,
			[tblCOSReport,tblCOSReport2]
		);
	console.log("L2 Accounts Applied");*/

	//Tables: Enable Refresh on Tables
	//Enable/Disable key-user functionality
	switch (Application.getUserInfo().id) {
		case"DIWOLTER":case"HANJACOB":case"AAMBAUM":case"RZWEKARS":case"RESMITH":case"AVRIJ":
		case"JBAEYENS":case"ALOBO":case"LDAM":case"ISOTA":case"JREIJNEN":case"RUROMBOU":
/*		ThisApp.SetTablesRefreshPaused(false,
									   [tblInstallBase_TAP,tblInstallBaseCS_TAP,tblCOSReport_TAP,tblCOSReport2_TAP], //reports
									   [tblCOSM_TAP,tblCOSMQ_TAP,tblCOSLHrs_TAP,tblCOSLHrsQ_TAP,tblCOSLRates_TAP]
									  ); */
ThisApp.PauseRefreshPerTab(tsContent_TAP.getSelectedKey(), "TAP");
		break;
		default:
		btnCalcIB.setVisible(true); //hide manual install base calculation
/*		ThisApp.SetTablesRefreshPaused(false,
									   [tblInstallBase_TAP,tblInstallBaseCS_TAP,tblCOSReport_TAP,tblCOSReport2_TAP], //reports
									   [tblCOSM_TAP,tblCOSMQ_TAP,tblCOSLHrs_TAP,tblCOSLHrsQ_TAP,tblCOSLRates_TAP]
									  ); //input*/
ThisApp.PauseRefreshPerTab(tsContent_TAP.getSelectedKey(), "TAP");
	}
}


console.log("Refresh Widgets Enabled");


//====================================================================
//End Initialization
//====================================================================

//Hide Indicator
Application.hideBusyIndicator();
if (bEnableConsole) {console.log("Application initialized in: "+ConvertUtils.numberToString((Date.now()-initStart)/1000)+" seconds");}
//popRecalc.open();