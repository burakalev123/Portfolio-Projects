//force Embed mode?
switch (Application.getMode()) {
	case ApplicationMode.View:
	case ApplicationMode.Present:
		NavigationUtils.openApplication(Application.getInfo().id, [UrlParameter.create("mode", "embed")], false);
		break;
}

//Application settings
Application.setCommentModeEnabled(false);
Application.setAutomaticBusyIndicatorEnabled(false);

//Variables
var i = 0;
var homepagetext = "";

//Harcoded list of USERID's that have more rights
//In future -> this has to be automated by looking up TEAM membership!
//----------------------------------------------------------------------------------
//Key user access
sKeyUsers = ["JBAEYENS", "ALOBO", "HANJACOB", "AAMBAUM", "DIWOLTER", "RZWEKARS", "SNIJSKEN", "RESMITH", "ISOTA", "JREIJNEN", "RUROMBOU", "ARNKERST", "LDAM", "SAPSACT4", "QNIE", "BALEV", "FURAZ", "GALEKSAN"];
//HMI planners
sHMIUsers = ["ARNBOER"];

//Enable/Disable key-user functionality
if (sKeyUsers.includes(Application.getUserInfo().id)) {
	txtKeyUsers.setVisible(true);
	btnProcessExec.setVisible(true);
	//	btnReports.setVisible(true);
	btnRebate.setVisible(true);
	btn_HMI.setVisible(true);
	btnMOR_ManualInp.setVisible(true);
	btnL3BALLOC.setVisible(true);
} else {
	if (sHMIUsers.includes(Application.getUserInfo().id)) {
		btn_HMI.setVisible(true);
	} else {
		txtKeyUsers.setVisible(false);
		btnProcessExec.setVisible(false);
		//		btnReports.setVisible(false);
		btnMOR_ManualInp.setVisible(false);
		btnL3BALLOC.setVisible(false);
	}
}


//Get All Versions
//---------------------
//var dVersion_all = FIN_PLAN_SP.getMembers("Version",{limit:200});
dVersion_currentMOR = FIN_PLAN_SP.getMember("Version", "public.NewForecast");
dVersion_currentTAP = FIN_PLAN_SP.getMember("Version", "public.NewBudget");

//Set Current Version
//---------------------
/*for (i=0;i<dVersion_all.length; i++) {
		switch (dVersion_all[i].properties.STATUS) {
			case "CURRENTMOR":
				dVersion_currentMOR = dVersion_all[i]; //get the current MOR version (where STATUS=CURRENTMOR)
			break;
			case "CURRENTTAP":
				dVersion_currentTAP = dVersion_all[i]; //get the current TAP version (where STATUS=CURRENTTAP)
			break;
		}
}*/
if (bEnableConsole) { console.log("Current MOR version: " + dVersion_currentMOR.id); }
if (bEnableConsole) { console.log("Current TAP version: " + dVersion_currentTAP.id); }

//Set Previous versions
//---------------------
dVersion_previousMOR = FIN_PLAN_SP.getMember("Version", "public." + dVersion_currentMOR.properties.PREV);
dVersion_previousTAP = FIN_PLAN_SP.getMember("Version", "public." + dVersion_currentTAP.properties.PREV);

if (bEnableConsole) { console.log("Previous MOR version: " + dVersion_previousMOR.id); }
if (bEnableConsole) { console.log("Previous TAP version: " + dVersion_previousTAP.id); }

//Get CustomerShipTo Sales Account Groups
//----------------------
//Retrieve Sales Account Groups from CustomerShipTo hierarchy Master Data
dSAGs = FIN_PLAN_SP.getMembers("CustomerShipTo", { hierarchyId: "H1", parentId: "TOT_AG", limit: 50 });

//Populate RadioButton
rbgSAG.removeAllItems();
for (i = 0; i < dSAGs.length; i++) {
	if (dSAGs[i].id !== "#") {
		rbgSAG.addItem(dSAGs[i].id, dSAGs[i].description);
		//Set default item
		if (rbgSAG.getSelectedKey() === undefined) {
			rbgSAG.setSelectedKey(dSAGs[i].id);
		}
	}

}
//Hide CS COS input for Sales Account controllers (who see only 1 or 2 SAG's)
if (dSAGs.length < 5) {
	txtCSControl.setVisible(false);
	btnCSL2COS.setVisible(false);
	btnCSCovAlloc.setVisible(false);
	btnCSL3Opex.setVisible(false);
	btnCSL4COS.setVisible(false);
	btnCSReports.setVisible(false);
}


//Set Text on homepage
//---------------------
if (dVersion_currentMOR.properties.ALTDESC.length > 0) {
	homepagetext = dVersion_currentMOR.description + " = " + dVersion_currentMOR.properties.ALTDESC;
} else {
	homepagetext = dVersion_currentMOR.description;
}
if (dVersion_previousMOR.properties.ALTDESC.length > 0) {
	homepagetext = homepagetext + "\n" + dVersion_previousMOR.description + " = " + dVersion_previousMOR.properties.ALTDESC;
} else {
	homepagetext = homepagetext + "\n" + dVersion_previousMOR.description;
}
txtVersion.applyText(homepagetext);

//Check for unpublished data
var pl = tblPublish.getPlanning();
if (pl.getPublicVersion("NewForecast").isDirty()) { txtPublishVersion.applyText("NewForecast"); popPublish.open(); }