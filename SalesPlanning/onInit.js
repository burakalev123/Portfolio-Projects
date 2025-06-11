//---------------------------------------------- Application Initialization ----------------------------------------------//

// Show busy indicator at opening of application
Application.showBusyIndicator("Initializing application, please wait...");

// Initialize counter for upcoming loops
var i = 0;

// Initialize Main Navigation Menu
MianNavMenu.initializeNavMenu(Application.getInfo().id, "1");


//---------------------------------------------- Initialize Table & Chart Setup ----------------------------------------------//

// Initializing Icon Repository and items for Navigation Menu
application_IconRepository = {
    'enterfullscreen'  : '\ue166', //sap-icon://full-screen
    'exitfullscreen'   : '\ue1f5', //sap-icon://exit-full-screen
    'comments'         : '\xe0b2', //sap-icon://comment
    'drivers'          : '\xe242', //sap-icon://customize
    'instructions'     : '\xe05c', //sap-icon://hint
    'help'             : '\xe1c4', //sap-icon://sys-help
    'arrowdown'        : '\ue1e2', //sap-icon://navigation-down-arrow
    'arrowright'       : '\ue066', //sap-icon://navigation-right-arrow
    'arrowleft'        : '\ue067'  //sap-icon://navigation-left-arr
};


// Initializing Model Dimension Names
application_DimensionName = {
    'version'           : 'Version',
    'account'           : 'SP_MEASURES',
    'date'              : 'Date',
    'companyCode'       : 'SP_COMP_CODE',
    'customer'          : 'SP_CUSTOMER_L2',
    'customer_resp'     : 'SP_CUSTOMERRESP',
    'salesOrganisation' : 'SP_SALESORG',
    'material'          : 'SP_MATERIAL',
    'B2BLevel'          : 'SP_B2B_LEVEL',
    'B2CLevel'          : 'SP_B2C_LEVEL'
};


cfg_measureMapping = {
    SALES_PRICE_calc : '[SP_MEASURES].[parentId].&[SALES_PRICE_calc]',
    GM_kg            : '[SP_MEASURES].[parentId].&[GM_per_VOL_calc]',
    CM1_kg           : '[SP_MEASURES].[parentId].&[CM1_per_VOL_calc]',
    salesVolume      : '[SP_MEASURES].[parentId].&[SALES_VOLUME]'
};


// Initialize selectable options for CheckBox widget Table Settings dialogue.

// retrieve measure descriptions
var measures = Table_content.getDataSource().getMembers("SP_MEASURES");
var measuresDictionary = { "dummy": "dummy" };

for (i = 0; i < measures.length; i++) {
    measuresDictionary[measures[i].id] = measures[i].description;
}

console.log(measuresDictionary);


// Please add all measures you want to be able to select to based on the cfg_measureMapping master data object.
// Note: displayId is an indicator which shows if the measure is checked or not per default when opening the application. 
cfg_tableSettingOptions = [
    { id: cfg_measureMapping.SALES_PRICE_calc, description: measuresDictionary[cfg_measureMapping.SALES_PRICE_calc], displayId: 'x' },
    { id: cfg_measureMapping.GM_kg,            description: measuresDictionary[cfg_measureMapping.GM_kg],            displayId: 'x' },
    { id: cfg_measureMapping.CM1_kg,           description: measuresDictionary[cfg_measureMapping.CM1_kg],           displayId: 'x' },
    { id: cfg_measureMapping.salesVolume,      description: measuresDictionary[cfg_measureMapping.salesVolume],      displayId: 'x' }
    //id=id in checkbox widget
];


// Initialize all table & chart widgets for the p1-section of this application.
cfg_tableCollection = [Table_content];


// Initialize widget settings

// pause all visible widgets so user does not see flickering 
for (i = 0; i < cfg_tableCollection.length; i++) {
    if (cfg_tableCollection[i].isVisible() && cfg_tableCollection[i].getPlanning().isEnabled()) {
        cfg_tableCollection[i].getPlanning().setEnabled(false);
        cfg_tableCollection[i].getDataSource().setRefreshPaused(true);
    }
}

/*
for (i = 0; i < cfg_chartCollection.length; i++) {
    if (cfg_chartCollection[i].isVisible()) {
        cfg_chartCollection[i].getDataSource().setRefreshPaused(true);
    }
}
*/

// set default measures of cfg_tableSettingOptions to table
ActionScripts.applyTableSettingsOnInit();


//---------------------------------------------- End of Table & Chart Setup ----------------------------------------------//


// Reading Version & Attributes
Table_Version_Dimension.getDataSource().refreshData();

var DS = Table_Version_Dimension.getDataSource().getResultSet();

if (planning_year === '') {
    planning_year = DS[0]["Version"].properties["Version.Year"];
}

gv_planning_year_hier = "[Date].[YM].[Date.YEAR].[" + planning_year + "]";

console.log("Planning Year:");
console.log(gv_planning_year_hier);

var g_planning_year_int = ConvertUtils.stringToInteger(planning_year);


// Determine Budget Year
var bud_year_int = g_planning_year_int + 1;
var bud_year = bud_year_int.toString();

console.log("Budget Year: " + bud_year);

var bud_year_hier = "[Date].[YM].[Date.YEAR].[" + bud_year + "]";


// Determine Previous Year
var pre_year_int = g_planning_year_int - 1;
var pre_year = pre_year_int.toString();

console.log("Previous Year: " + pre_year);

var pre_year_hier = "[Date].[YM].[Date.YEAR].[" + pre_year + "]";


if (g_planning_month === '') {
    g_planning_month = DS[0]["Version"].properties["Version.plan_Month"];
}

console.log("Planning Start Month: " + g_planning_month);

var year = ConvertUtils.stringToInteger(g_planning_month.substr(0, 4));
var month = ConvertUtils.stringToInteger(g_planning_month.substr(4, 2));

var calenderCCD = CurrentDateTime.createCalendarDateTime({ granularity: CalendarTimeGranularity.Month, year: year, month: month });

Application.setCurrentDateTime(calenderCCD);


// Determine Previous Year-Month
var g_planning_month_CY = g_planning_month.substr(4, 2);
var g_planning_month_PY = pre_year + g_planning_month_CY;

console.log("Previous Year-Month: " + g_planning_month_PY);


//---------------------------------------------- Filters for Input Controls ----------------------------------------------//

// Selection Previous Year & Current Forecast Year
// InputControl_Date.getInputControlDataSource().setSelectedMembers([pre_year_hier,gv_planning_year_hier]);

CInpC_CurrYearMonth.getInputControlDataSource().setSelectedMembers("[Date].[YM].&[" + g_planning_month + "]");
CInpC_PrevYearMonth.getInputControlDataSource().setSelectedMembers("[Date].[YM].&[" + g_planning_month_PY + "]");
CInpC_PrevYear.getInputControlDataSource().setSelectedMembers(pre_year_hier);
// CInpC_CurrYear.getInputControlDataSource().setSelectedMembers(gv_planning_year_hier);
CInpC_BudYear.getInputControlDataSource().setSelectedMembers(bud_year_hier);


//---------------------------------------------- Filters for Table/Charts ----------------------------------------------//

/*
// Retrieve Page Filters
ActionScripts.PageFilters_Update();
*/


// Ensure Comment Mode is enabled
Application.setCommentModeEnabled(true);


// End of initialization

// activate all visible widgets 
for (i = 0; i < cfg_tableCollection.length; i++) {
    if (cfg_tableCollection[i].isVisible()) {
        cfg_tableCollection[i].getDataSource().setRefreshPaused(false);
        cfg_tableCollection[i].getPlanning().setEnabled(true);
    }
}

/*
for (i = 0; i < cfg_chartCollection.length; i++) {
    if (cfg_chartCollection[i].isVisible()) {
        cfg_chartCollection[i].getDataSource().setRefreshPaused(false);
    }
}
*/


Application.hideBusyIndicator();
