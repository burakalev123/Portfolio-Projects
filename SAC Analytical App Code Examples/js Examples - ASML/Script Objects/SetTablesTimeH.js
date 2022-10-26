// function SetTablesTimeH(START: string, END: string, HierarchyLevel: integer, Tables: Table[]) : void

var i = 0;
//==============================================================
// Define Time Range
//==============================================================
var y = 0;

//Convert Strings to Integers, e.g. 202001
var STARTint = ConvertUtils.stringToInteger(START.substr(0, 4));
var ENDint = ConvertUtils.stringToInteger(END.substr(0, 4));

//Get Quarter members
var members = ArrayUtils.create(Type.MemberInfo);
for (y = STARTint; y <= ENDint; y++) { //loop through each year
    switch (y) {
        case STARTint: //first year
            if (START.substr(4, 2) === "01" || START.substr(4, 2) === "02" || START.substr(4, 2) === "03" || START.substr(4, 2) === "04" || START.substr(4, 2) === "05" || START.substr(4, 2) === "06") {
                members.push({ id: "[Date].[YHQM].[(all)].[" + y.toString() + "].[H1]", description: y.toString() + "H1" }); //add H1
                members.push({ id: "[Date].[YHQM].[(all)].[" + y.toString() + "].[H2]", description: y.toString() + "H2" }); //add H2

            }
            if (START.substr(4, 2) === "07" || START.substr(4, 2) === "08" || START.substr(4, 2) === "09" || START.substr(4, 2) === "10" || START.substr(4, 2) === "11" || START.substr(4, 2) === "12") {
                members.push({ id: "[Date].[YHQM].[(all)].[" + y.toString() + "].[H2]", description: y.toString() + "H2" }); //add H2
            }

            break;
        case ENDint: //last year
            if (END.substr(4, 2) === "01" || END.substr(4, 2) === "02" || END.substr(4, 2) === "03" || END.substr(4, 2) === "04" || END.substr(4, 2) === "05" || END.substr(4, 2) === "06") {
                members.push({ id: "[Date].[YHQM].[(all)].[" + y.toString() + "].[H1]", description: y.toString() + "H1" }); //add H1
            }
            if (END.substr(4, 2) === "07" || END.substr(4, 2) === "08" || END.substr(4, 2) === "09" || END.substr(4, 2) === "10" || END.substr(4, 2) === "11" || END.substr(4, 2) === "12") {
                members.push({ id: "[Date].[YHQM].[(all)].[" + y.toString() + "].[H1]", description: y.toString() + "H1" }); //add H1
                members.push({ id: "[Date].[YHQM].[(all)].[" + y.toString() + "].[H2]", description: y.toString() + "H2" }); //add H2
            }
            break;
        default: //all other years
            members.push({ id: "[Date].[YHQM].[(all)].[" + y.toString() + "].[H1]", description: y.toString() + "H1" }); //add H1
            members.push({ id: "[Date].[YHQM].[(all)].[" + y.toString() + "].[H2]", description: y.toString() + "H2" }); //add H2
            break;
    }
}

//==============================================================
// Apply TimeRange to Table Widgets
//==============================================================

for (i = 0; i < Tables.length; i++) {
    var ds = Tables[i].getDataSource();
    ds.removeDimensionFilter("Date");
    ds.setHierarchy("Date", "YHQM");
    ds.setHierarchyLevel("Date", HierarchyLevel);
    ds.setDimensionFilter("Date", members);
}