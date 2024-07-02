//----------------------------------------------Application is opened----------------------------------------------//
//Show busy indicator at opening of application
Application.showBusyIndicator("Initializing application, please wait...");

cfg_ValueType === "Region";

//initialize counter for upcomming loops
var i = 0;

//Initializing Composite for Main Navigation Menu
MianNavMenu.initializeNavMenu(Application.getInfo().id, "1");
//-----------------------------------------Initialize master data objects-----------------------------------------//
// Initializing Icon Repository and items for Navigation Menu
application_IconRepository = {
    'enterfullscreen': '\ue166', //sap-icon://full-screen
    'exitfullscreen': '\ue1f5', //sap-icon://exit-full-screen
    'comments': '\xe0b2', //sap-icon://comment
    'drivers': '\xe242', //sap-icon://customize
    'instructions': '\xe05c', //sap-icon://hint
    'help': '\xe1c4', //sap-icon://sys-help
    'arrowdown': '\ue1e2', //sap-icon://navigation-down-arrow
    'arrowright': '\ue066', //sap-icon://navigation-right-arrow
    'arrowleft': '\ue067' //sap-icon://navigation-left-arr
};

//Initialize all Model Measure Names
////Please adjust accordning to the measures you have created.
cfg_measureMapping = {
    //"measureNameInApp"	: "Measure_Name_In_Data_Model",
    "ACT_PY": "13996122-1925-4646-3457-418957004981",
    "ACT_YTD": "24102003-0221-4367-3798-723059847868",
    "BUD": "17803798-5037-4078-3968-623996392971",
    "Demand_FC": "19819739-9850-4720-3323-387505795421",
    "NewFC": "24585272-5313-4519-3781-226688968273",
    "PriorFC": "38661947-9338-4339-3233-392148620024"
};

//Initialize selectable options for CheckBox widget Table Settings dialogue.
////retrieve measure descriptions
var measures = chrt_Comparison.getDataSource().getMeasures();
var measuresDictionary = { "dummy": "dummy" };
for (i = 0; i < measures.length; i++) {
    measuresDictionary[measures[i].id] = measures[i].description;
}

////Please add all measures you want to be able to select to based on the cfg_measureMapping master data object.
////Note: displayId is an indicator which shows if the measure is checked or not per default when opening the application. 
cfg_tableSettingOptions = [
    { id: cfg_measureMapping.ACT_PY, description: measuresDictionary[cfg_measureMapping.ACT_PY], displayId: 'x' },	//id=id in checkbox widget
    { id: cfg_measureMapping.ACT_YTD, description: measuresDictionary[cfg_measureMapping.ACT_YTD], displayId: 'x' },
    { id: cfg_measureMapping.BUD, description: measuresDictionary[cfg_measureMapping.BUD], displayId: 'x' },
    { id: cfg_measureMapping.Demand_FC, description: measuresDictionary[cfg_measureMapping.Demand_FC], displayId: 'x' },
    { id: cfg_measureMapping.NewFC, description: measuresDictionary[cfg_measureMapping.NewFC], displayId: 'x' },
    { id: cfg_measureMapping.PriorFC, description: measuresDictionary[cfg_measureMapping.PriorFC], displayId: 'x' },

];

// Load planning year from Forecast Version attribute/property and set filter on tables (Example: [Date].[YQM].[Date.YEAR].[2022])
if (g_planning_year === '') {
    g_planning_year = SalesFC.getMember("Version", "public.Forecast").properties["Year"];
}
console.log("Planning Year" + g_planning_year);
////////////////////////////////////////////////////////
if (g_planning_month === '') {
    g_planning_month = SalesFC.getMember("Version", "public.Forecast").properties["StartDate"];
}
console.log("Planning Start Month" + g_planning_month);

ic_filterPanel_Date_DSEComp.getInputControlDataSource().setSelectedMembers("[Date].[YM].&[" + g_planning_month + "]");
////////////////////////////////////////////////////////
if (g_priorFCVers === '') {
    g_priorFCVers = SalesFC.getMember("Version", "public.Forecast").properties["priorFCVers"];
}
console.log("Previous FC Version: " + g_priorFCVers);

ic_priorFCVers.getInputControlDataSource().setSelectedMembers("public." + g_priorFCVers + "");

////////////////////////////////////////////////////////
//Set the InputControl filter to the current system year and next year. First argument represents start year (current year + 0) and second argument represents end year (current year + 1).
utilityScripts.setDateInputControl(1, 0, ic_filterPanel_Date);

//-----------------------------------------------Initialize data-----------------------------------------------//
//Chart_1.getDataSource().setRefreshPaused(false);
//Table_1.getDataSource().setRefreshPaused(false);
//Chart_2.getDataSource().setRefreshPaused(false);
//-----------------------------------------Initialize remaining widgets-----------------------------------------//

//----------------------------------------------Initialization End----------------------------------------------//
//Hide busy indicator
Application.hideBusyIndicator();
