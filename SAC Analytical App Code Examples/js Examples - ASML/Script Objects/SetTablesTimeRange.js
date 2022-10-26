// function SetTablesTimeRange(START: string, END: string, Granularity: TimeRangeGranularity, Tables: Table[]) : void


var i = 0;
//==============================================================
// Define Time Range
//==============================================================
//Convert Strings to Integers, e.g. 202001
var STARTint = ConvertUtils.stringToInteger(START);
var ENDint = ConvertUtils.stringToInteger(END);
//Convert Integers to Dates
var STARTd = new Date(Math.trunc(STARTint / 100), STARTint - Math.trunc(STARTint / 100) * 100, 0);
var ENDd = new Date(Math.trunc(ENDint / 100), ENDint - Math.trunc(ENDint / 100) * 100, 0);
//Convert Dates to TimeRange
var TR = TimeRange.create(Granularity, STARTd, ENDd);
if (bEnableConsole) { console.log(TR); }

//==============================================================
// Apply TimeRange to Table Widgets
//==============================================================
for (i = 0; i < Tables.length; i++) {
    var ds = Tables[i].getDataSource();
    ds.removeDimensionFilter("Date");
    ds.setDimensionFilter("Date", TR);
}