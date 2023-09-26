/*
if (Application.getMode()!== ApplicationMode.View){
 NavigationUtils.openApplication(Application.getInfo().id,UrlParameter.create("mode","view"),false);	
}
*/
var filter = inp_ctr_Legal_Entity.getInputControlDataSource().getActiveSelectedMembers();
var txt_arr = "";

for (var i = 0; i < filter.length; i++) {
    var filterId = filter[i].displayId;
    var currency = PlanningModel_1.getMember("PD_001_LEGALENTITY", filterId).properties["currency"];
    txt_arr = txt_arr.concat(currency/* + ", "*/);
    console.log(txt_arr);
}

txt_Local_Currency.applyText("Local Currency: " + txt_arr);