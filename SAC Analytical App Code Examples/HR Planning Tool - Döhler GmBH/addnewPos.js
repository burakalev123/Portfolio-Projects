//---------------------------------------
// 0. get selected data from the widgets on Popup
//---------------------------------------

//Filter
//var resultsJobProfile = tbl_Job_Profile_Hidden.getDataSource().getResultSet();
//var globalJobProfile_ID = resultsJobProfile[0]["PD_001_JOB_PROFILE"].id;
//var globalJobProfile = tbl_Job_Profile_Hidden.getDataSource().getMember("PD_001_JOB_PROFILE",globalJobProfile_ID).displayId;

var globalJobProfile = drp_New_Job_Profile.getSelectedKey();
console.log("Global Job Profile: " + globalJobProfile);
//Radio Buttons
var seasonalPosition = rbg_Seasonal.getSelectedKey();
var temporaryPosition = rbg_Temporary.getSelectedKey();
var bonusGroup = rbg_BonusGroup.getSelectedKey();
//Dropdowns
//New Job Profile structure addition on the Position BALEV 17/11/2022 
//Edit on 28/11/2022

for (i = 0; i < gv_JobProfile.length; i++) {
    if (gv_JobProfile[i].id === globalJobProfile) {
        var var_job_profile = gv_JobProfile[i].properties["Job_Profile"];
        console.log("New Job Profile");
        console.log(var_job_profile);
    }
}

for (i = 0; i < gv_JobProfile.length; i++) {
    if (gv_JobProfile[i].id === globalJobProfile) {
        var var_job_sub_family = gv_JobProfile[i].properties["Job_Sub_Family"];
        console.log("New Job Sub Family");
        console.log(var_job_sub_family);
    }
}

for (i = 0; i < gv_JobProfile.length; i++) {
    if (gv_JobProfile[i].id === globalJobProfile) {
        var var_job_family = gv_JobProfile[i].properties["Job_Family"];
        console.log("New Job Family");
        console.log(var_job_family);
    }
}

for (i = 0; i < gv_JobProfile.length; i++) {
    if (gv_JobProfile[i].id === globalJobProfile) {
        var var_leading_attr = gv_JobProfile[i].properties["Leading_Attribute"];
        console.log("Leading Attr.");
        console.log(var_leading_attr);
    }
}

//
var legalEntity = drp_LegalEntity.getSelectedKey();
var department = drp_Department.getSelectedKey();
var costCenter = drp_CostCenter.getSelectedKey();
var currency = drp_Currency.getSelectedKey(); // NH | 13.09.2022 | Currency Implementation
var entryDate = (drp_Entry_Date.getSelectedKey()).substr(0, 6);
var endDatePos = drp_End_Date_Pos.getSelectedKey(); //AM 07.10.22 for End Date temporary position
if (endDatePos === undefined) {
    endDatePos = "";
}
else {
    endDatePos = (drp_End_Date_Pos.getSelectedKey()).substr(0, 6);
}
console.log("endDatePos"); //Annette | 07.10.22 | debugging
console.log(endDatePos); //Annette | 07.10.22 | debugging
console.log("costCenter"); //Lea | 26.08.22 | debugging
console.log(costCenter); //Lea | 26.08.22 | debugging
//Input Fields
var higherLevelPosition = inp_HigherLevel.getValue();
var localJobTitle = inp_LocalJobTitle.getValue();
var comment = inp_comment.getValue();
var AnnualSalary = inp_AnnualSalary.getValue();
var AnnualBonus = inp_AnnualBonus.getValue();

//13th Salary Calculation ALEVB 29/08/2023
switch (drp_frequency.getSelectedKey()) {
    case "MON":
        var Annual13Salary = 0.00;
        break;
    case "M125":
        Annual13Salary = (ConvertUtils.stringToNumber(AnnualSalary) / 12) * 0.5;
        break;
    case "M1296":
        Annual13Salary = (ConvertUtils.stringToNumber(AnnualSalary) / 12) * 0.96;
        break;
    case "M13":
        Annual13Salary = (ConvertUtils.stringToNumber(AnnualSalary) / 12) * 1;
        break;
    case "M1333":
        Annual13Salary = (ConvertUtils.stringToNumber(AnnualSalary) / 12) * 1.33;
        break;
    case "M14":
        Annual13Salary = (ConvertUtils.stringToNumber(AnnualSalary) / 12) * 2;
        break;
    case "M15":
        Annual13Salary = (ConvertUtils.stringToNumber(AnnualSalary) / 12) * 3;
        break;
}

var TotalTargetCash_Int = ConvertUtils.stringToNumber(AnnualSalary) + ConvertUtils.stringToInteger(AnnualBonus); 	// 13th Salary enhancment ALEVB 29/08/2023
var TotalTargetCash = ConvertUtils.numberToString(TotalTargetCash_Int);
var new_AnnualSalary = ConvertUtils.stringToNumber(AnnualSalary) - Annual13Salary;

//---------------------------------------
// POSITION CREATION STEPS
//---------------------------------------
var numofnewPos = ConvertUtils.stringToInteger(drp_num_of_newPos.getSelectedKey());
for (var count = 1; count <= numofnewPos; count++) {
    //---------------------------------------
    // 1. create new Position ID
    //---------------------------------------
    //Retrieve all New Members of Dimension Position, Default limit is 200 --> therefore set to 100000
    var mem = PlanningModel_1.getMembers("PD_001_POSITION", {
        limit: 100000
    });

    //Count of New Positions
    var highestID = 0;
    for (var i = 0; i < mem.length; i++) {
        if (mem[i].id.substr(0, 3) === "PL_") {
            highestID = highestID + 1;
        }
    }

    //Create new Position ID
    var newID = highestID + 1;
    var newPositionID = "PL_" + costCenter + "_" + ConvertUtils.numberToString(newID);
    //---------------------------------------


    //---------------------------------------
    // 2. Create Master Data/New Position for PD_001_POSITION Dimension
    //---------------------------------------
    gv_newPositionMember = ({
        id: newPositionID,
        properties: {
            Mapping_New_Job_Profile: globalJobProfile,
            T_001_LOCALJOBTITLE: localJobTitle,
            T_001_SEASONAL: seasonalPosition,
            T_001_TEMPORARY: temporaryPosition,
            T_001_BONUSGROUP: bonusGroup,
            T_001_LEGALENTITY: legalEntity,
            T_001_HIGHERLEVELPOSITION: higherLevelPosition,
            D_001_YRBASESALARY: new_AnnualSalary.toFixed(2),
            D_001_Y13SALARY: Annual13Salary.toFixed(2),  // 13th Salary enhancment ALEVB 29/08/2023
            D_001_YRTARGETBONUS: AnnualBonus,
            D_001_YRTOTALTARGETCASH: TotalTargetCash,
            T_001_Department: department,
            T_COSTCENTER: costCenter,
            T_001_COMMENT: comment,
            T_001_NEWPOSITION: "Yes",
            T_001_STAFFED: "No",
            End_Date: endDatePos,
            // Addon Erhard Ludwig 07.10.2022 - neue Property "Status New Position", mögliche Werte: "in proposal" oder "denied"
            T_001_STATUS_NEW_POSITION: "in proposal",
            T_001_BUDTYPE_PLNYEAR: "No",
            //New Job Profile structure addition on the Position BALEV 17/11/2022
            T_001_NJOBPROFILE: var_job_profile,
            T_001_NJOBSUBFAMILY: var_job_sub_family,
            T_001_NJOBFAMILY: var_job_family,
            T_001_LEADATTR: var_leading_attr,
            //Back to Original Job Profile structure ALEVB 29/08/2023
            T_001_JOBPROFILE: var_job_profile,
            T_JOBSUBFAMILY: var_job_sub_family,
            T_001_JOBFAMILY: var_job_family,
            T_001_LEADATTR2: var_leading_attr
        }
    });

    console.log("New Position member:"); //for debugging
    console.log(gv_newPositionMember); //for debugging

    var success_creation = PlanningModel_1.updateMembers("PD_001_POSITION", gv_newPositionMember);

    if (success_creation) {
        //Application.showMessage(ApplicationMessageType.Success, "The new position has been created."); //Lea | 26.08.22 | Show success message later after Data Actions
    } else {
        Application.showMessage(ApplicationMessageType.Error, "An error occured during the creation of the new position. The new position was not created.");
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
            Application.showMessage(ApplicationMessageType.Success, "The new position(s) has been created.");
            createPos.clearPopup();

        } else {
            Application.showMessage(ApplicationMessageType.Error, "An error occured during the execution of the data action DA_CostCalc.");
        }
        //---------------------------------------
    }
}