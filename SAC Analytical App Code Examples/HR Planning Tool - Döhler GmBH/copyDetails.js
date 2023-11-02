//clean dropdown selections
drp_CostCenter.setSelectedKey("");
drp_LegalEntity.setSelectedKey("");
drp_Department.setSelectedKey("");
drp_CostCenter.setSelectedKey("");
drp_Entry_Date.setSelectedKey("");
drp_Currency.setSelectedKey("");

drp_New_Job_Profile.setSelectedKey("");
drp_Job_Profile.setSelectedKey("");
drp_Job_Sub_Family.setSelectedKey("");
drp_Job_Family.setSelectedKey("");

drp_End_Date_Pos.removeAllItems();
drp_End_Date_Pos.setVisible(false);
txt_End_Date_Pos.setVisible(false);
txt_Warning.setVisible(false);

//clean Input Fields
inp_HigherLevel.setValue("");
inp_LocalJobTitle.setValue("");
inp_comment.setValue("");
inp_AnnualSalary.setValue("");
inp_AnnualBonus.setValue("");
//set Radiobuttons as default "No"
rbg_BonusGroup.setSelectedKey("No");
rbg_Seasonal.setSelectedKey("No");
rbg_Temporary.setSelectedKey("No");

var Results = tbl_hidden.getDataSource().getResultSet();
console.log(Results);

if (Results.length === 0) {

    Application.showMessage(ApplicationMessageType.Error, "Please select another employee as template, or fill in the details manually.");

} else if (Results.length > 1) {

}
else {
    //get Dimension and/or property Values
    var LocalJobTitle = Results[0]["PD_001_POSITION.T_001_LOCALJOBTITLE"].description;
    var seasonalPosition = Results[0]["PD_001_POSITION.T_001_SEASONAL"].description;
    var temporaryPosition = Results[0]["PD_001_POSITION.T_001_TEMPORARY"].description;
    var bonusGroup = Results[0]["PD_001_POSITION.T_001_BONUSGROUP"].description;
    var higherLevelPosition = Results[0]["PD_001_POSITION.T_001_HIGHERLEVELPOSITION"].description;
    console.log(higherLevelPosition);
    var LegalEntity_id = Results[0]["PD_001_LEGALENTITY"].id;  //Lea | 26.08.22 | zu klären: Sollte das hier aus der Legal Entity Dimension gelesen werden?
    var LegalEntity = tbl_Empl_Hidden.getDataSource().getMember("PD_001_LEGALENTITY", LegalEntity_id).displayId;
    var Department = Results[0]["PD_001_POSITION.T_001_Department"].description;
    var CostCenter = Results[0]["PD_001_POSITION.T_COSTCENTER"].description;  //Lea | 26.08.22 | zu klären: Sollte das hier aus der Cost Center Dimension gelesen werden?
    var Currency = Results[0]["PD_001_TR_CURRENCY"].id; // NH | 12.09.22 | Currency Implementation
    var AnnualBaseSalary = Results[0]["PD_001_POSITION.D_001_YRBASESALARY"].description;
    var AnnualBonus = Results[0]["PD_001_POSITION.D_001_YRTARGETBONUS"].description;
    var Annual13Salary = Results[0]["PD_001_POSITION.D_001_Y13SALARY"].description;
    var GlobalJobProfile = Results[0]["PD_001_POSITION.Mapping_New_Job_Profile"].description;
    var End_Date = Results[0]["PD_001_POSITION.End_Date"].description; //AM 07.10.22 End Date Temporary Positions
    console.log("GlobalJobProfile");
    console.log(GlobalJobProfile);

    var AnnualSalary = ConvertUtils.stringToNumber(AnnualBaseSalary) + ConvertUtils.stringToNumber(Annual13Salary);
    var AnnualSalary_str = ConvertUtils.numberToString(AnnualSalary);
    /*   
       //Set Filter
       if(GlobalJobProfile !== ""){
           tbl_Job_Profile_Hidden.getDataSource().setDimensionFilter("PD_001_JOB_PROFILE","[PD_001_JOB_PROFILE].[H1].&["+GlobalJobProfile+"]");
       }
   */
    ///////////////////////////////////////////////////////

    for (i = 0; i < gv_JobProfile.length; i++) {
        if (gv_JobProfile[i].id === GlobalJobProfile) {
            drp_New_Job_Profile.addItem(gv_JobProfile[i].id, gv_JobProfile[i].description);
            Text_1.applyText(gv_JobProfile[i].description);
        }
    }

    for (i = 0; i < gv_CostCenter.length; i++) {
        if (gv_CostCenter[i].properties["T_001_LEGALENTITY"] === LegalEntity) {
            drp_CostCenter.addItem(gv_CostCenter[i].id, gv_CostCenter[i].id + " " + "(" + gv_CostCenter[i].description + ")");
        }
    }

    ///////////////////////////////////////////////////////		
    //set Dropdowns

    ScriptObject_1.hide_Job_Prof_selection();
    drp_New_Job_Profile.setSelectedKey(GlobalJobProfile);
    drp_CostCenter.setSelectedKey(CostCenter);
    drp_LegalEntity.setSelectedKey(LegalEntity);
    drp_Department.setSelectedKey(Department);
    drp_CostCenter.setSelectedKey(CostCenter);
    drp_Currency.setSelectedKey(Currency); // NH | 13.09.22 | Currency Implementation
    if (temporaryPosition === "Yes") { //AM 07.10.22 End Date Temporary Positions
        //Initialize Dropdown for End Date selection
        //Initialize Dropdown for End Date selection
        var current_year = new Date(Date.now()).getFullYear();
        var next_year = current_year + 1;
        var next_year_plus1 = next_year + 1;
        var next_year_str = ConvertUtils.numberToString(next_year);
        var next_year_str_plus1 = ConvertUtils.numberToString(next_year_plus1);

        var months = ArrayUtils.create(Type.string);
        months = (["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]);
        var monthsText = ArrayUtils.create(Type.string);
        monthsText = (["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]);
        var yearMonth = ArrayUtils.create(Type.string);
        drp_End_Date_Pos.removeAllItems();
        //add months next year 
        var i = 0;
        for (i = 0; i < months.length; i++) {
            yearMonth.push(next_year_str + months[i] + " (" + monthsText[i] + ")");
            drp_End_Date_Pos.addItem(next_year_str + months[i] + " (" + monthsText[i] + ")");
        }
        //add months next+1 year 
        var z = 12;
        for (z = 12; z < months.length; z++) {
            yearMonth.push(next_year_str_plus1 + months[z] + " (" + monthsText[z] + ")");
            drp_End_Date_Pos.addItem(next_year_str_plus1 + months[z] + " (" + monthsText[z] + ")");
        }
        drp_End_Date_Pos.setVisible(true);
        txt_End_Date_Pos.setVisible(true);
        txt_Warning.setVisible(true);

        //set End Date
        var End_Date_month_nr = End_Date.substr(4, 2);
        var y = 0;
        for (y = 0; y < months.length; y++) {
            if (End_Date_month_nr === months[y]) {
                var sel_End_Date = End_Date + " (" + monthsText[y] + ")";
                var drp_includes = yearMonth.includes(sel_End_Date);
                if (drp_includes === false) {
                    drp_End_Date_Pos.addItem(sel_End_Date);
                }
                drp_End_Date_Pos.setSelectedKey(sel_End_Date);
            }
            drp_End_Date_Pos.setVisible(true);
            txt_End_Date_Pos.setVisible(true);
            txt_Warning.setVisible(true);
        }
    }


    //set Input Fields
    inp_HigherLevel.setValue(higherLevelPosition);
    inp_LocalJobTitle.setValue(LocalJobTitle);
    inp_AnnualSalary.setValue(AnnualSalary_str);
    inp_AnnualBonus.setValue(AnnualBonus);


    //set Radio BUttons
    if (seasonalPosition === "Yes") {
        rbg_Seasonal.setSelectedKey("Yes");
    } else {
        rbg_Seasonal.setSelectedKey("No");
    }

    if (temporaryPosition === "Yes") {
        rbg_Temporary.setSelectedKey("Yes");
    } else {
        rbg_Temporary.setSelectedKey("No");
    }

    if (bonusGroup === "Yes") {
        rbg_BonusGroup.setSelectedKey("Yes");
    } else {
        rbg_BonusGroup.setSelectedKey("No");
    }

}