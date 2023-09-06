//---------------------------------------
// 0. get selected data from the widgets on Popup
//---------------------------------------
var member_id = gv_sel_Position_ID_Tech.substring(gv_sel_Position_ID_Tech.lastIndexOf("[") + 1, gv_sel_Position_ID_Tech.lastIndexOf("]"));

//Radio Buttons
var seasonalPosition = rbg_Seasonal.getSelectedKey();
var temporaryPosition = rbg_Temporary.getSelectedKey();
var bonusGroup = rbg_BonusGroup.getSelectedKey();
//Dropdowns
//New Job Profile structure addition on the Position BALEV 17/11/2022 
//Edit on 28/11/2022


//

//var department = drp_Department.getSelectedKey();
var costCenter = drp_edit_CostCenter.getSelectedKey();
//var currency = drp_Currency.getSelectedKey();
//var entryDate = (drp_Entry_Date.getSelectedKey()).substr(0, 6);
/*
var endDatePos = drp_End_Date_Pos.getSelectedKey(); 
if (endDatePos === undefined) {
    endDatePos = "";
}
else {
    endDatePos = (drp_End_Date_Pos.getSelectedKey()).substr(0, 6);
}
*/
//console.log("endDatePos"); //Annette | 07.10.22 | debugging
//console.log(endDatePos); //Annette | 07.10.22 | debugging
console.log("costCenter"); //Lea | 26.08.22 | debugging
console.log(costCenter); //Lea | 26.08.22 | debugging
//Input Fields
//var higherLevelPosition = inp_HigherLevel.getValue();
//var localJobTitle = inp_LocalJobTitle.getValue();
//var comment = inp_comment.getValue();
var AnnualSalary = inp_edit_AnnualSalary.getValue();
var AnnualBonus = inp_edit_AnnualBonus.getValue();
var Annual13Salary = inp_edit_Annual13thSalary.getValue();

var TotalTargetCash_Int = ConvertUtils.stringToNumber(AnnualSalary) + ConvertUtils.stringToInteger(AnnualBonus); 	// 13th Salary enhancment ALEVB 29/08/2023
var TotalTargetCash = ConvertUtils.numberToString(TotalTargetCash_Int);

var new_AnnualSalary = ConvertUtils.stringToNumber(AnnualSalary) - ConvertUtils.stringToNumber(Annual13Salary);

//---------------------------------------
// 2. Create Master Data/New Position for PD_001_POSITION Dimension
//---------------------------------------
gv_newPositionMember = ({
    id: member_id,
    properties: {
        //T_001_LOCALJOBTITLE: localJobTitle,
        //T_001_SEASONAL: seasonalPosition,
        //T_001_TEMPORARY: temporaryPosition,
        //T_001_BONUSGROUP: bonusGroup,
        //T_001_LEGALENTITY: legalEntity,
        //T_001_HIGHERLEVELPOSITION: higherLevelPosition,
        D_001_YRBASESALARY: new_AnnualSalary.toFixed(2),
        D_001_Y13SALARY: Annual13Salary,  // 13th Salary enhancment ALEVB 29/08/2023
        D_001_YRTARGETBONUS: AnnualBonus,
        D_001_YRTOTALTARGETCASH: TotalTargetCash,
        //T_001_Department: department,
        T_COSTCENTER: costCenter,
        //T_001_COMMENT: comment,
        //End_Date: endDatePos,
    }
});

console.log("New Position member:"); //for debugging
console.log(gv_newPositionMember); //for debugging

var success_creation = PlanningModel_1.updateMembers("PD_001_POSITION", gv_newPositionMember);

if (success_creation) {

} else {
    Application.showMessage(ApplicationMessageType.Error, "An error occured during the update of the new position. The new position has not been updated.");
}
//---------------------------------------

//Continue with this scipt only if the creation of the new position was successful
if (success_creation) {
    //---------------------------------------
    // 3. Create Plan data for the account FTE, SpecifiedAnnualSalary and AnnualBonus
    //---------------------------------------
    DA_NewPosPlan.setParameterValue("Position", "[PD_001_POSITION].[Job_Family_Hiearchie].&[" + newPositionID + "]");
    DA_NewPosPlan.setParameterValue("CostCenter", "[PD_001_COSTCENTER].[FUNC_VIEW].&[" + costCenter + "]");
    DA_NewPosPlan.setParameterValue("LegalEntity", "[PD_001_LEGALENTITY].[H_001_LEGALENTITY].&[" + legalEntity + "]");
    DA_NewPosPlan.setParameterValue("JobProfile", "[PD_001_JOB_PROFILE].[H1].&[" + globalJobProfile + "]");
    DA_NewPosPlan.setParameterValue("FTE", 1);
    DA_NewPosPlan.setParameterValue("AnnualSalary", ConvertUtils.stringToInteger(AnnualSalary) / 12);
    DA_NewPosPlan.setParameterValue("Annual13thSalary", Annual13Salary / 12); 	// 13th Salary enhancment ALEVB 29/08/2023
    DA_NewPosPlan.setParameterValue("AnnualBonus", ConvertUtils.stringToInteger(AnnualBonus) / 12);
    DA_NewPosPlan.setParameterValue("Currency", currency); // NH | 12.09.2022 | Currency Implementation
    DA_NewPosPlan.setParameterValue("Date", "[Date].[YM].&[" + entryDate + "]");

    var executeResponse_NewPosPlan = DA_NewPosPlan.execute();
    console.log("Date Parameter");
    console.log(DA_NewPosPlan.getParameterValue("Date"));

    if (executeResponse_NewPosPlan.status === DataActionExecutionResponseStatus.Success) {

        //---------------------------------------
        // 4. Cost Calculation with the costs from config screen 
        //---------------------------------------
        //var executeResponse_TotalCost = DA_CostCalc.execute();
        DA_CostCalcPos.setParameterValue("Position", "[PD_001_POSITION].[Job_Family_Hiearchie].&[" + newPositionID + "]");
        var executeResponse_TotalCost = DA_CostCalcPos.execute();

        //---------------------------------------

    } else {
        Application.showMessage(ApplicationMessageType.Error, "An error occured during the execution of the data action DA_NewPosPlan.");
    }

    if (executeResponse_TotalCost.status === DataActionExecutionResponseStatus.Success) {
        //Lastly, after waiting for the data actions to finish, show to the user that the position was created
        Application.showMessage(ApplicationMessageType.Success, "The new position is created.");
        createPos.clearPopup();

    } else {
        Application.showMessage(ApplicationMessageType.Error, "An error occured during the execution of the data action DA_CostCalc.");
    }
    //---------------------------------------
}