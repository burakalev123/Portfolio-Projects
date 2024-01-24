//====================================================================
// Start Initializing Application
//====================================================================
//var initStart = Date.now(); //Enable time tracking for initializing
bEnableConsole = true; //Enable console log lines for debugging
//Application.setCommentModeEnabled(true); //Enable/Disable comments functionality
Application.showBusyIndicator("Initializing the application");

//Log Progress
//if (bEnableConsole) {console.log("First initialization processed after: "+ConvertUtils.numberToString((Date.now()-initStart)/1000)+" seconds");}
pnl_warning.setVisible(false);

//Key user access
sKeyUsers = ["BURAKALEV"];

if (sKeyUsers.includes(Application.getUserInfo().id)) {
    Button_1.setVisible(true);
    Button_2.setVisible(true);
}

//Closed month
var current_year = new Date(Date.now()).getFullYear();
var pre_year = current_year - 1;
var current_year_str = ConvertUtils.numberToString(current_year);
var pre_year_str = ConvertUtils.numberToString(pre_year);
console.log(current_year);

//getMonth() function returns month as a value between 0 – 11 for January to December.
var pre_month = new Date(Date.now()).getMonth();
var pre_month_str = ConvertUtils.numberToString(pre_month);
console.log(pre_month);
console.log(pre_month_str);
console.log(pre_month_str.length);

if (pre_month_str.length >= 2) {
    var pre_month_year = current_year_str + pre_month_str;
} else {
    if (pre_month_str === "0") {
        pre_month_year = pre_year_str + "12";
    }
    else { pre_month_year = current_year_str + "0" + pre_month_str; }
}

console.log(pre_month_year);

inc_date_prompt.getInputControlDataSource().setSelectedMembers(pre_month_year);
//

pop_prompt.open();



