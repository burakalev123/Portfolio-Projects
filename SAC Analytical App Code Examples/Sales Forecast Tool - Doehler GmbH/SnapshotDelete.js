console.log('Start Deletion of History');

// read SourceVersion
var planning = tbl_Hist.getPlanning();

var lv_version = drp_SnapshotVers.getSelectedKey();
console.log(lv_version.substr(7, 3));

var forecastVersion = planning.getPublicVersion(lv_version.substr(7, 3));
console.log("...............forecastVersion...............");
console.log(forecastVersion);
// execute Deleteion
Application.showBusyIndicator('Deleting: ' + lv_version.substr(7, 3));

if (forecastVersion) {
    forecastVersion.deleteVersion();
};
applicationScripts.updateFilterForHistAndRFCPage();
Application.hideBusyIndicator();



console.log('Start Export Ready');

// read SourceVersion
var lv_version = DP_ChooseVersion.getSelectedKey();
console.log(lv_version);

// execute DataAction
Application.showBusyIndicator('Executing Export Ready');

DataAction_ExportReady.setParameterValue("rangeForecast", g_planning_year_hier);
DataAction_ExportReady.setParameterValue("SourceVersion", lv_version);

var returnValue = DataAction_ExportReady.execute();
console.log(returnValue);

if (returnValue.status === DataActionExecutionResponseStatus.Success) {
	Application.showMessage(ApplicationMessageType.Success, 'Export Ready successful');
} else {
	Application.showMessage(ApplicationMessageType.Error, 'Export Ready failed');
}

tbl_Hist.getDataSource().refreshData();
Application.hideBusyIndicator();