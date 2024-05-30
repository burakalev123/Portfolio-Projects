//----Start----//
console.log('checkForChanges');
//-----------------------------------------------------------//

var selectedDates = ArrayUtils.create(Type.string);
var selectedAreas = ArrayUtils.create(Type.string);
var selectedB2BL2 = ArrayUtils.create(Type.string);

//-----------------------------------------------------------//

var ds = Table_Background_aggr.getDataSource();
var changes = false;

ds.refreshData();
var resultSet = ds.getResultSet({ [Alias.MeasureDimension]: "SALES_VOLUME_DELTA_AGGR" });

//-----------------------------------------------------------//

var selectedAreas_filter = ic_filterPanel_Area.getInputControlDataSource().getActiveSelectedMembers();
var Area = selectedAreas_filter[0].id;
selectedAreas.push("[SFC_AREA].[H1].&[" + Area + "]");

//-----------------------------------------------------------//

for (var i = 0; i < resultSet.length; i++) {
    var B2BL2 = resultSet[i]["SFC_B2B_L2"].id;
    var rawValue = resultSet[i][Alias.MeasureDimension].rawValue;
    var measure = resultSet[i][Alias.MeasureDimension];

    if (rawValue !== '0' && measure.id === 'SALES_VOLUME_DELTA_AGGR') {
        changes = true;

        var date = resultSet[i]["Date"].id;

        selectedDates.push("[Date].[YQM].&[" + date + "]");
        //		selectedAreas.push("[SFC_AREA].[H1].&["+Area+"]");
        selectedB2BL2.push("[SFC_B2B_L2].[H1].&[" + B2BL2 + "]");

        console.log('Changed: Area: ' + Area + ' B2B Level2: ' + B2BL2 + ' for Date: ' + date + '; Value: ' + rawValue);
    }
}

if (!changes) {
    Application.hideBusyIndicator();
    return;
}

Application.showBusyIndicator('Loading...');

var dataActionReCalc = da_re_calc_GS_GM_CM1;

//--Setting up the Parameters--??
dataActionReCalc.setParameterValue("Area", selectedAreas);
dataActionReCalc.setParameterValue("Date", selectedDates);
dataActionReCalc.setParameterValue("B2BLevel2", selectedB2BL2);

//--Data Action Execution--//
var daResult = dataActionReCalc.execute();
if (daResult.status === DataActionExecutionResponseStatus.Success) {
    Application.showMessage(ApplicationMessageType.Success, "Calculation was successful.");
} else {
    Application.showMessage(ApplicationMessageType.Error, "Error in calculation.");
}

p1_table_planningTable.getDataSource().refreshData();

Application.hideBusyIndicator();

