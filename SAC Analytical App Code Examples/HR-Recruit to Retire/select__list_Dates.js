Application.showBusyIndicator("New Date Selected...");

var selectedkey = drp_months_exits.getSelectedKey();
console.log(selectedkey);

//Selected Date
var selectedYear = selectedkey.substr(0, 4);
var selectedYear_int = ConvertUtils.stringToInteger(selectedYear);
console.log(selectedYear_int);

var selectedMonth = selectedkey.substr(4, 2);
var selectedMonth_int = ConvertUtils.stringToInteger(selectedMonth);
console.log(selectedMonth_int);

//var derivedMonth = selectedkey.substr(4,2);
var derivedMonth_int = selectedMonth_int + 1;
console.log(derivedMonth_int);

if (selectedMonth_int < 12) {
    var derivedYear_int = selectedYear_int - 1;
    var derivedMonth_int = selectedMonth_int + 1;
} else {
    derivedYear_int = selectedYear_int;
    derivedMonth_int = 1;
}

var derivedYear = derivedYear_int.toString();

var numbersArray = ArrayUtils.create(Type.integer);

for (var i = 0; month_int <= 12; i++) {

    var month_int = derivedMonth_int + i;
    var month = month_int.toString();
    if (month_int < 10){
        var date = derivedYear + "0" + month;
    }else{
        var date = derivedYear + month;
    }

    var date_int = ConvertUtils.stringToInteger(date);

    numbersArray.push(date_int);

}


var numbersArray = ArrayUtils.create(Type.integer);

for (var i = 0; i < 12; i++) {

    var date = derivedDate_int + i;
    var month = date.toString().substr(0, 4);
    var month_int = month

    if (month_int <= 202312) {
        numbersArray.push(date);
    } else {
        break;
    }
}


//C_InpC_Months_Exits.getInputControlDataSource().setSelectedMembers("[DIM_Calmonth∞0].[YM].&["+selectedkey+"]");

Application.hideBusyIndicator();