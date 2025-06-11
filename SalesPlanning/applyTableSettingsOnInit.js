
/**********************************************Retrieve selected Keys**********************************************/
var table = Table_content.getDataSource();


/**********************************************Validation Steps**********************************************/
//Clear measure array (this array will be filled with all the measures from the checkbox and used as argument for setDimensionFilter later as well as for cancel button to restore latest selection)

g_measureArrayTableSettings.splice(0, g_measureArrayTableSettings.length);
var measureArrayTableSettings = ArrayUtils.create(Type.string); //for technical reasons, local array is used as argument for setDimensonFilter


//Loop through customization array of possible table setting elements from onInit() script
for (var i = 0; i < cfg_tableSettingOptions.length; i++) {

    //if measure[i] from customization table is in selected keys, then push measure to measure array
    if (cfg_tableSettingOptions[i].displayId === "x") {
        var measureID = cfg_tableSettingOptions[i].id;
        g_measureArrayTableSettings.push(measureID);
        measureArrayTableSettings.push(measureID);
    }
}


//set new measures to table
table.setDimensionFilter(Alias.MeasureDimension, measureArrayTableSettings);



