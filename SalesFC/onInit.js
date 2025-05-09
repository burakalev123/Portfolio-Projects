//----------------------------------------------Application is opened----------------------------------------------//
//Show busy indicator at opening of application
//Application.showBusyIndicator("Your application is loading. Please wait a moment...");
//initialize counter for upcomming loops
var i = 0;
//Test

//-----------------------------------------Initialize master data objects-----------------------------------------//
//Initialize Icon Repository
cfg_iconRepository = {
    'enterfullscreen'	: '\ue166', //sap-icon://full-screen
    'exitfullscreen'	: '\ue1f5', //sap-icon://exit-full-screen
    'arrowdown'			: '\ue1e2', //sap-icon://navigation-down-arrow
    'arrowright'		: '\ue066', //sap-icon://navigation-right-arrow
    'arrowleft'			: '\ue067', //sap-icon://navigation-left-arr
    'refresh'			: '\ue010'  //sap-icon://refresh
};

//Initialize Display Mode
cfg_displayMode = 'present';

//initialize global plan version with prefix
if (cfg_planVersion === "") {
    cfg_planVersion = "public.Forecast";
}
console.log(cfg_planVersion);
//initialize global plan version without prefix (for the publish/revert API)
if (g_versionText === "") {
    g_versionText = cfg_planVersion.split(".")[1];
}
console.log(g_versionText);

//Initialize all Model Dimension Names.
////Please adjust accordning to the dimensions you have created.
cfg_dimensionMapping = {
    //'dummyNameForApp'		: 'Dimension_Name_In_Data_Model'
    'version'			: 'Version',
    'date'				: 'Date',
    'companyCode'		: 'SFC_COMP_CODE',
    'B2BLevel2'			: 'SFC_B2B_L2',
    'area'				: 'SFC_AREA',
    'plant'				: 'SFC_PLANT',
    'material'			: 'SFC_MATERIAL',
    'customer'			: 'SFC_CUSTOMER',
    'salesOrganisation'	: 'SFC_SALESORG',
	'scope'				: 'SCOPE'
};

//Initialize all Model Measure Names
////Please adjust accordning to the measures you have created.
cfg_measureMapping = {
    //"measureNameInApp"	: "Measure_Name_In_Data_Model",
    "grossSales"	: "GROSS_SALES",
    "salesVolume"	: "SALES_VOLUME",
    "stdGM"			: "GM",
    "stdCM1"		: "CM1",
	"salesPrice"	: "CM_SALES_PRICE",
	"GM_rate"		: "CM_GM_RATE",
	"CM1_rate"		: "CM_CM1_RATE"
	
};

//Initialize selectable options for CheckBox widget Table Settings dialogue.
////retrieve measure descriptions
var measures = table.getDataSource().getMeasures();
var measuresDictionary = { "dummy": "dummy" };
for (i = 0; i < measures.length; i++) {
    measuresDictionary[measures[i].id] = measures[i].description;
}

////Please add all measures you want to be able to select to based on the cfg_measureMapping master data object.
////Note: displayId is an indicator which shows if the measure is checked or not per default when opening the application. 
cfg_tableSettingOptions = [
    { id: cfg_measureMapping.grossSales,  description: measuresDictionary[cfg_measureMapping.grossSales],  displayId: 'x' },	//id=id in checkbox widget
    { id: cfg_measureMapping.salesVolume, description: measuresDictionary[cfg_measureMapping.salesVolume], displayId: 'x' },
    { id: cfg_measureMapping.stdGM, 	  description: measuresDictionary[cfg_measureMapping.stdGM],       displayId: '' },
    { id: cfg_measureMapping.stdCM1,      description: measuresDictionary[cfg_measureMapping.stdCM1],      displayId: '' },
	{ id: cfg_measureMapping.salesPrice,  description: measuresDictionary[cfg_measureMapping.salesPrice],  displayId: '' },
	{ id: cfg_measureMapping.GM_rate,     description: measuresDictionary[cfg_measureMapping.GM_rate],     displayId: '' },
	{ id: cfg_measureMapping.CM1_rate,    description: measuresDictionary[cfg_measureMapping.CM1_rate],    displayId: '' },
];

//Initialize all table widgets for the p1-section of this application.
////Please add all table widget IDs located under the p1 section of this application.
////Note: in case this application contains a p2-section, this must be done for all table widgets under p2 as well. This is not the case here.
cfg_tableCollection = [table];


//-----------------------------------------Initialize widget settings-----------------------------------------//
//pause all visible widgets so user does not see flickering 
for (i = 0; i < cfg_tableCollection.length; i++) {
    if (cfg_tableCollection[i].isVisible() && cfg_tableCollection[i].getPlanning().isEnabled()) {
        cfg_tableCollection[i].getPlanning().setEnabled(false);
        cfg_tableCollection[i].getDataSource().setRefreshPaused(true);
    }
}

//set default measures of cfg_tableSettingOptions to table
applicationScripts.applyTableSettingsOnInit();

//Set the InputControl filter to the current system year and next year. First argument represents start year (current year + 0) and second argument represents end year (current year + 1).
utilityScripts.setDateInputControl(1, 0, ic_filterPanel_Date);

//-----------------------------------------------Initialize data-----------------------------------------------//


//-----------------------------------------Initialize remaining widgets-----------------------------------------//


//----------------------------------------------Initialization End----------------------------------------------//
//activate all visible widgets 
for (i = 0; i < cfg_tableCollection.length; i++) {
    if (cfg_tableCollection[i].isVisible()) {
        cfg_tableCollection[i].getDataSource().setRefreshPaused(false);
        cfg_tableCollection[i].getPlanning().setEnabled(false);
    }
}



//Hide busy indicator
//Panel_1.setVisible(false);
Application.hideBusyIndicator();

