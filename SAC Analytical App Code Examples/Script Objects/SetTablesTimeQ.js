// function SetTablesTimeQ(START: string, END: string, HierarchyLevel: integer, Tables: Table[]) : void

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
        case STARTint: //if first year
            switch (START.substr(4, 2)) {
                case "01": case "02": case "03":
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "1]", description: y.toString() + "Q1" }); //add Q1
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "2]", description: y.toString() + "Q2" }); //add Q2
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "3]", description: y.toString() + "Q3" }); //add Q3
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "4]", description: y.toString() + "Q4" }); //add Q4
                    break;
                case "04": case "05": case "06":
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "2]", description: y.toString() + "Q2" }); //add Q2
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "3]", description: y.toString() + "Q3" }); //add Q3
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "4]", description: y.toString() + "Q4" }); //add Q4
                    break;
                case "07": case "08": case "09":
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "3]", description: y.toString() + "Q3" }); //add Q3
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "4]", description: y.toString() + "Q4" }); //add Q4
                    break;
                case "10": case "11": case "12":
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "4]", description: y.toString() + "Q4" }); //add Q4
                    break;
            }
            break;
        case ENDint: //if last year
            switch (END.substr(4, 2)) {
                case "01": case "02": case "03":
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "1]", description: y.toString() + "Q1" }); //add Q1
                    break;
                case "04": case "05": case "06":
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "1]", description: y.toString() + "Q1" }); //add Q1
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "2]", description: y.toString() + "Q2" }); //add Q2
                    break;
                case "07": case "08": case "09":
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "1]", description: y.toString() + "Q1" }); //add Q1
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "2]", description: y.toString() + "Q2" }); //add Q2
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "3]", description: y.toString() + "Q3" }); //add Q3
                    break;
                case "10": case "11": case "12":
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "1]", description: y.toString() + "Q1" }); //add Q1
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "2]", description: y.toString() + "Q2" }); //add Q2
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "3]", description: y.toString() + "Q3" }); //add Q3
                    members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "4]", description: y.toString() + "Q4" }); //add Q4
                    break;
            }
            break;
        default: //all other years
            members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "1]", description: y.toString() + "Q1" }); //add Q1
            members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "2]", description: y.toString() + "Q2" }); //add Q2
            members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "3]", description: y.toString() + "Q3" }); //add Q3
            members.push({ id: "[Date].[YHQM].[Date.CALQUARTER].[" + y.toString() + "4]", description: y.toString() + "Q4" }); //add Q4
            break;
    }
}

console.log(members);

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