/**********************************************Application is opened**********************************************/
//Show busy indicator at opening of application
Application.showBusyIndicator("Your application is loading. Please wait a moment...");
//initialize counter for upcomming loops
var i = 0;


/*****************************************Initialize master data objects*****************************************/
//Initialize Icon Repository
cfg_iconRepository = {
    'enterfullscreen': '\ue166', //sap-icon://full-screen
    'exitfullscreen': '\ue1f5', //sap-icon://exit-full-screen
    'arrowdown': '\ue1e2', //sap-icon://navigation-down-arrow
    'arrowright': '\ue066', //sap-icon://navigation-right-arrow
    'arrowleft': '\ue067', //sap-icon://navigation-left-arr
    'refresh': '\ue010'  //sap-icon://refresh
};

//Initialize Display Mode
cfg_displayMode = 'present';
/*
//Initialize Story IDs for Naviagtion Panel
cfg_storyIds = {
	
    //ENTRY PAGE
    SAP_MKT_CommercialPlanning_Overview	: 'A3668126648FA33E6511EE19EBC35F',

    //PORTFOLIO
    SAP_MKT_PortfolioPlanning_Overview 			: 	'8AB66812662E80127DB419BAD47D2A7',	
    SAP_MKT_PortfolioPlanning_ListPricePlanning	:	'A471A787BC7D2D95775148CF63C8DEF6',
    SAP_MKT_PortfolioPlanning_ListPriceAnalysis	:	'97AB5E812667744B8CC30D967B6E6A16',
    SAP_MKT_PortfolioPlanning_AdminPage 		:   '97CA768126617C1B64123441A77F1D75',

    //SALES
    SAP_SD_SalesPlanning_Overview		: 	'A2DA6E812660CF791D8D11552EDDC8F0',
    SAP_SD_SalesDemandPlanning			:	'57A7E812662975D865688527F057F7E' ,
    SAP_SD_SalesActivityPlanning		:	'4B094306E10BC4FBB0598B2AF0F05CA2',
    SAP_SD_SalesActivityAnalysis		: 	'50B10D05CA6D76069F8941BC447A03A4',
    SAP_SD_SalesPerformanceAnalysis		:	'3A712907D435494C93A431B8C5B07B11',
    SAP_SD_SalesActivityROI				: 	'BCD13C03055E9A995136C2B1BD4C304D',
    SAP_SD_SalesBudgetPlanningGlobal	:	'C3427505CA6C3DAEA0E1F459D74A531B',
    SAP_SD_SalesBudgetPlanningRegional	:	'F4181E812665185C4C06EDD81698AFAB',
    SAP_SD_SalesBudgetAnalysis			:	'A1B20505CA6F7F86A05385671B32FA25',
    SAP_SD_SalesPlanning_AdminPage		:   '47491403055E8380A44E1DBBEE7D6CFA',
	
    //MARKETING
    SAP_MKT_Marketing_Overview			:	'9B66812661CF0895B6258E5B6AFC04',
    SAP_MKT_MarketingBudgetPlanning		:	'9AC336812660AD5C3C2FBA0A3BC7E906',
    SAP_MKT_MarketingDemandPlanning		:	'2F126D05CA69C5182B2BC6B0DD3EBAF4',
    SAP_MKT_MarketingCampaignPlanning 	:	'3450B787BC7D99F1AC7009CA7E51F468',
    SAP_MKT_MarketingCampaignAnalysis 	: 	'9F1B5E8126664E87C844ABCC69DE4367',
    SAP_MKT_MarketingPerformanceAnalysis: 	'CF435E8126677C37E3DAC3EC7B07FF03',
    SAP_MKT_Marketing_AdminPage 		: 	'E8D8238530894EB9C5A970062F3BF9F8'
};
*/
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
//initialize global reference version with prefix
if (cfg_referenceVersion === "") {
    cfg_planVersion = "public.Budget";
}


//Initialize all Model Dimension Names.
////Please adjust accordning to the dimensions you have created.
cfg_dimensionMapping = {
    //'dummyNameForApp'		: 'Dimension_Name_In_Data_Model'
    'version': 'Version',
    'date': 'Date',
    'companyCode': 'SFC_COMP_CODE',
    'B2BLevel2': 'SFC_B2B_L2',
    'area': 'SFC_AREA',
    'plant': 'SFC_PLANT',
    'material': 'SFC_MATERIAL',
    'customer': 'SFC_CUSTOMER',
    'salesOrganisation': 'SFC_SALESORG'
};

//Initialize all Model Measure Names
////Please adjust accordning to the measures you have created.
cfg_measureMapping = {
    //"measureNameInApp"			: "Measure_Name_In_Data_Model",
    "grossSales": "GROSS_SALES",
    "salesVolume": "SALES_VOLUME",
    "stdGM": "GM",
    "stdCM1": "CM1"
};


//Initialize selectable options for CheckBox widget Table Settings dialogue.
////retrieve measure descriptions
var measures = p1_table_planningTable.getDataSource().getMeasures();
var measuresDictionary = { "dummy": "dummy" };
for (i = 0; i < measures.length; i++) {
    measuresDictionary[measures[i].id] = measures[i].description;
}


////Please add all measures you want to be able to select to based on the cfg_measureMapping master data object.
////Note: displayId is an indicator which shows if the measure is checked or not per default when opening the application. 
cfg_tableSettingOptions = [
    { id: cfg_measureMapping.grossSales, description: measuresDictionary[cfg_measureMapping.grossSales], displayId: 'x' },	//id=id in checkbox widget
    { id: cfg_measureMapping.salesVolume, description: measuresDictionary[cfg_measureMapping.salesVolume], displayId: 'x' },
    { id: cfg_measureMapping.stdGM, description: measuresDictionary[cfg_measureMapping.stdGM], displayId: '' },
    { id: cfg_measureMapping.stdCM1, description: measuresDictionary[cfg_measureMapping.stdCM1], displayId: '' },

    //{ id:cfg_measureMapping.cmStoryImpactOnRevenue,	description: 'Imact on Revenue',				displayId: 'x'}, //must be part of tablelayout per default due to existence of conditional formatting rules. please check applyTableSettings script
];
/*
//Initialize selectable measures for the Carry Forward Popup dialogue.
////Please add all measures you want to be able to select to based on the cfg_measureMapping master data object.
////Note: displayId is an indicator which shows if the measure is checked or not per default when opening the application. 
cfg_carryForwarMeasureOptions = [ 
                            { id:cfg_measureMapping.cmListPrice,				description : measuresDictionary[cfg_measureMapping.cmListPrice],						displayId: 'x'}, //id=id in checkbox widget
                            { id:cfg_measureMapping.cmQuantityImpactPercent,	description : measuresDictionary[cfg_measureMapping.cmQuantityImpactPercent], 			displayId: 'x'}
                          ];
*/
/*
//Initialize all chart widgets for the p1-section of this application.
////Please add all chart widget IDs located under the p1 section of this application.
////Note: in case this application contains a p2-section, this must be done for all chart widgets under p2 as well. This is not the case here.
cfg_chartCollection = [// name_of_chart
    p1_barChart_pageHeader_chartTime_1,
    p1_barChart_pageHeader_chartTime_2,
    p1_barChart_pageHeader_chartTime_3
                      ];
*/

//Initialize all table widgets for the p1-section of this application.
////Please add all table widget IDs located under the p1 section of this application.
////Note: in case this application contains a p2-section, this must be done for all table widgets under p2 as well. This is not the case here.
cfg_tableCollection = [p1_table_planningTable];


/*****************************************Initialize widget settings*****************************************/
//pause all visible widgets so user does not see flickering 
for (i = 0; i < cfg_tableCollection.length; i++) {
    if (cfg_tableCollection[i].isVisible() && cfg_tableCollection[i].getPlanning().isEnabled()) {
        cfg_tableCollection[i].getPlanning().setEnabled(false);
        cfg_tableCollection[i].getDataSource().setRefreshPaused(true);
    }
}

/*
for (i=0; i<cfg_chartCollection.length;i++) {
    if (cfg_chartCollection[i].isVisible()) {
        cfg_chartCollection[i].getDataSource().setRefreshPaused(true);
    }
}
*/


//set default measures of cfg_tableSettingOptions to table
applicationScripts.applyTableSettingsOnInit();

//Set Drill Down for Products to L3 in table
utilityScripts.changeHierarchyLevelTableRows([p1_table_planningTable], 3, cfg_dimensionMapping.product);

//Set the InputControl filter to the current system year and next year. First argument represents start year (current year + 0) and second argument represents end year (current year + 1).
utilityScripts.setDateInputControl(1, 0, ic_filterPanel_Date);
/*
//Set the InputControl filter to default versions
ic_filterPanel_Version.getInputControlDataSource().setSelectedMembers([cfg_planVersion]); //Table InputControl
dVersion1_ic_Version.getInputControlDataSource().setSelectedMembers([cfg_planVersion, cfg_referenceVersion]); //Pirce Trend InputControl
*/
/*
//Put price trend charts on date hierarchy level 4 (Period)
utilityScripts.changeHierarchyLevelChart([p1_barChart_pageHeader_chartTime_1,p1_barChart_pageHeader_chartTime_2,p1_barChart_pageHeader_chartTime_3],2,cfg_dimensionMapping.date);
*/

/***********************************************Initialize data***********************************************/
//Populate Quantity Impact (%) measure with zeros in case the relevant cells for user input are unbooked. Necessary as unbooked is turned off for the table. --> Moved to Admin Page
//applicationScripts.populateQuantityImpactPercent();
//Calculate the uplift quantities --> Moved to Admin Page
//applicationScripts.populateUpliftQuantity();
/*
//Refresh charts set to active on startup
for (i=0; i<cfg_chartCollection.length;i++) {
    //if (cfg_chartCollection[i].isVisible() === true) {
        cfg_chartCollection[i].getDataSource().refreshData();
    //}
}
*/
//refresh the table after data actions have run through
p1_table_planningTable.getDataSource().refreshData();


/*****************************************Initialize remaining widgets*****************************************/
//Initialize widgets from the Carry Forward dialogue.
//applicationScripts.initializeCarryForwardPopupStartUp();


/**********************************************Initialization End**********************************************/
//activate all visible widgets 
for (i = 0; i < cfg_tableCollection.length; i++) {
    if (cfg_tableCollection[i].isVisible()) {
        cfg_tableCollection[i].getDataSource().setRefreshPaused(false);
        cfg_tableCollection[i].getPlanning().setEnabled(true);
    }
}
/*
for (i=0; i<cfg_chartCollection.length;i++) {
    if (cfg_chartCollection[i].isVisible()) {
        cfg_chartCollection[i].getDataSource().setRefreshPaused(false);
    }
}
*/
//Hide busy indicator
Application.hideBusyIndicator();
