//==================================================================================================
// function SetTablesTimeY(START: string, END: string, HierarchyLevel: integer, Tables: Table[]) : void
//==================================================================================================

var i =0;
//==============================================================
// Define Time Range
//==============================================================
var y = 0;
var m = 0;

//Convert Strings to Integers, e.g. 202001
var STARTint = ConvertUtils.stringToInteger(START.substr(0,4));
var ENDint = ConvertUtils.stringToInteger(END.substr(0,4));
var STARTm_int = ConvertUtils.stringToInteger(START.substr(4,2));
var ENDm_int = ConvertUtils.stringToInteger(END.substr(4,2));

//Get Month members
var members = ArrayUtils.create(Type.MemberInfo);
for (y=STARTint;y<=ENDint;y++){ //loop through each year
	switch (y){
		case STARTint:
			for (m=STARTm_int;m<=12;m++){
				if (m < 10) {
					members.push({id:"[Date].[YHQM].[Date.CALMONTH].["+y.toString()+"0"+m.toString()+"]",description:y.toString()+m.toString()}); 
				}
				else {
					members.push({id:"[Date].[YHQM].[Date.CALMONTH].["+y.toString()+m.toString()+"]",description:y.toString()+m.toString()}); 
				}
			}
		break;	
		case ENDint:
			for (m=1;m<=ENDm_int;m++){
				if (m < 10) {
					members.push({id:"[Date].[YHQM].[Date.CALMONTH].["+y.toString()+"0"+m.toString()+"]",description:y.toString()+m.toString()}); 
				}
				else {
					members.push({id:"[Date].[YHQM].[Date.CALMONTH].["+y.toString()+m.toString()+"]",description:y.toString()+m.toString()}); 
				}
			}
		break;	
		default:
			for (m=1;m<=12;m++){
				if (m < 10) {
					members.push({id:"[Date].[YHQM].[Date.CALMONTH].["+y.toString()+"0"+m.toString()+"]",description:y.toString()+m.toString()}); 
				}
				else {
					members.push({id:"[Date].[YHQM].[Date.CALMONTH].["+y.toString()+m.toString()+"]",description:y.toString()+m.toString()}); 
				}
			}
		break;
	}

}

console.log(members);

//==============================================================
// Apply TimeRange to Table Widgets
//==============================================================

for (i=0;i<Tables.length;i++){
	var ds = Tables[i].getDataSource();
	ds.removeDimensionFilter("Date");
	ds.setHierarchy("Date","YHQM");
	ds.setHierarchyLevel("Date",HierarchyLevel);
	ds.setDimensionFilter("Date",members);
}