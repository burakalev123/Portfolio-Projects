/**********************************************
 * Retrieve selected Keys
 **********************************************/
var table = Table_content.getDataSource();

/**********************************************
 * Validation Steps
 **********************************************/

// Clear global measure array for reuse
g_measureArrayTableSettings.splice(0, g_measureArrayTableSettings.length);

// Local array used for setDimensionFilter
var measureArrayTableSettings = ArrayUtils.create(Type.string);

// Loop through customization array of possible table setting elements from onInit() script
for (var i = 0; i < cfg_tableSettingOptions.length; i++) {
    var option = cfg_tableSettingOptions[i];

    // Push measures to arrays if marked as selected ("x")
    if (option.displayId === "x") {
        var measureID = option.id;
        g_measureArrayTableSettings.push(measureID);
        measureArrayTableSettings.push(measureID);
    }
}

// Set new measures to table
table.setDimensionFilter(Alias.MeasureDimension, measureArrayTableSettings);