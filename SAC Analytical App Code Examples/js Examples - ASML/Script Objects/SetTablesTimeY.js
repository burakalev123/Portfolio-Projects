// function SetTablesTimeY(START: string, END: string, HierarchyLevel: integer, Tables: Table[]) : void

var i = 0;

//==============================================================
// Define Time Range
//==============================================================
var y = 0;

//Convert Strings to Integers, e.g. 202001
var STARTint = ConvertUtils.stringToInteger(START.substr(0, 4));
var ENDint = ConvertUtils.stringToInteger(END.substr(0, 4));

//Get Year members in an array
var members = ArrayUtils.create(Type.MemberInfo);
//loop through each year
for (y = STARTint; y <= ENDint; y++) {
    //add year to the array as single member
    members.push({ id: "[Date].[YHQM].[Date.YEAR].[" + y.toString() + "]", description: y.toString() });
}

//==============================================================
// Apply Time Members to Table Widgets
//==============================================================
for (i = 0; i < Tables.length; i++) {
    var ds = Tables[i].getDataSource();
    ds.removeDimensionFilter("Date");
    ds.setHierarchy("Date", "YHQM");
    ds.setHierarchyLevel("Date", HierarchyLevel);
    ds.setDimensionFilter("Date", members);
}