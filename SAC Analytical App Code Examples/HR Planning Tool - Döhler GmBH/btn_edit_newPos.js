//No Position selected
if (gv_sel_Position_ID_Disp === "") {
    pop_NoPosSelec.open();
}

//Position selected
else {
    var member_id = gv_sel_Position_ID_Tech.substring(gv_sel_Position_ID_Tech.lastIndexOf("[") + 1, gv_sel_Position_ID_Tech.lastIndexOf("]"));
    if (member_id.substring(0, 2) === "PL") {
        Application.showBusyIndicator();
        //Dropdown Initialization
        console.log(gv_sel_Position_ID_Tech);

        var i = 0;

        var legal_entity = PlanningModel_1.getMember("PD_001_POSITION", member_id).properties.T_001_LEGALENTITY;
        var cost_center = PlanningModel_1.getMember("PD_001_POSITION", member_id).properties.T_COSTCENTER;
        var AnnualBaseSalary = PlanningModel_1.getMember("PD_001_POSITION", member_id).properties.D_001_YRBASESALARY;
        var Annual13thSalary = PlanningModel_1.getMember("PD_001_POSITION", member_id).properties.D_001_Y13SALARY;
        var AnnualBonus = PlanningModel_1.getMember("PD_001_POSITION", member_id).properties.D_001_YRTARGETBONUS;

        console.log("Legal Entity selected " + ": " + legal_entity);
        console.log("Cost Center selected " + ": " + cost_center);
        console.log("Annual Base Salary selected " + ": " + AnnualBaseSalary);
        console.log("Annual 13th Salary selected " + ": " + Annual13thSalary);
        console.log("Annual Bonus selected " + ": " + AnnualBonus);

        drp_edit_CostCenter.removeAllItems();
        inp_edit_AnnualSalary.setValue("");
        inp_edit_AnnualBonus.setValue("");
        inp_edit_Annual13thSalary.setValue("");

        //Populate the Attributes of the selected Position
        //Cost Center --Start
        for (i = 0; i < gv_CostCenter.length; i++) {
            if (gv_CostCenter[i].properties["T_001_LEGALENTITY"] === legal_entity) {
                drp_edit_CostCenter.addItem(gv_CostCenter[i].id, gv_CostCenter[i].id + " " + "(" + gv_CostCenter[i].description + ")");
            }
        }
        drp_edit_CostCenter.setSelectedKey(cost_center);
        //Cost Center --End

        //Salary Info --Start
        inp_edit_AnnualSalary.setValue(AnnualBaseSalary);
        inp_edit_Annual13thSalary.setValue(Annual13thSalary);
        inp_edit_AnnualBonus.setValue(AnnualBonus);
        //Salary Info --End

        //Hide Indicator
        Application.hideBusyIndicator();
        //open popup 
        pop_edit_newPos.open();
    }
    else {
        Application.showMessage(ApplicationMessageType.Error, "Only New Positions can be selected for this action.");
    }
}