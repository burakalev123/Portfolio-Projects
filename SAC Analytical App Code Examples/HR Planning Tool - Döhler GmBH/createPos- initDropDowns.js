var i = 0;
var max_members = 20000;
var ds = tbl_Empl_Hidden.getDataSource(); //Lea | 26.08.22 | call getDataSource() only once in the beginning of the script and save it in variable to optimize performance


var arr_Department = ds.getMembers("PD_001_POSITION.T_001_Department", max_members);
for (i = 0; i < arr_Department.length; i++) {
    drp_Department.addItem(arr_Department[i].id, arr_Department[i].description);
}

var arr_CostCenter = ds.getMembers("PD_001_POSITION.T_COSTCENTER", max_members); //Lea | 26.08.22 | zu klären: Sollte das hier aus der Cost Center Dimension gelesen werden?
for (i = 0; i < arr_CostCenter.length; i++) {
    drp_CostCenter.addItem(arr_CostCenter[i].id, arr_CostCenter[i].description);
}

var arr_LegalEntity = ds.getMembers("PD_001_LEGALENTITY", 300);  //Lea | 26.08.22 | zu klären: Sollte das hier aus der Legal Entity Dimension gelesen werden?
for (i = 0; i < arr_LegalEntity.length; i++) {
    if (arr_LegalEntity[i].displayId !== "Not In Hierarchy" && arr_LegalEntity[i].displayId !== "TOTALSAP" && arr_LegalEntity[i].displayId !== "TOTAL" && arr_LegalEntity[i].displayId !== "TOTALNONSAP" && arr_LegalEntity[i].displayId !== "#") {
        drp_LegalEntity.addItem(arr_LegalEntity[i].displayId, arr_LegalEntity[i].displayId + " - " + arr_LegalEntity[i].description);
    }

}

var arr_Currency = ds.getMembers("PD_001_TR_CURRENCY", 300); // NH | 13.09.22 | Currency Implementation

for (i = 0; i < arr_Currency.length; i++) {
    if (arr_Currency[i].id !== "#") {
        drp_Currency.addItem(arr_Currency[i].id, arr_Currency[i].description);
    }
}

//Date Dropdown Initialization
var current_year = new Date(Date.now()).getFullYear();
var next_year = current_year + 1;
var next_year_str = ConvertUtils.numberToString(next_year);

var months = ArrayUtils.create(Type.string);
months = (["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]);
var monthsText = ArrayUtils.create(Type.string);
monthsText = (["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]);
var yearMonth = ArrayUtils.create(Type.string);
drp_Entry_Date.removeAllItems();
for (i = 0; i < months.length; i++) {
    yearMonth.push(next_year_str + months[i] + " (" + monthsText[i] + ")");
    drp_Entry_Date.addItem(next_year_str + months[i] + " (" + monthsText[i] + ")");
}

console.log(yearMonth); //debug