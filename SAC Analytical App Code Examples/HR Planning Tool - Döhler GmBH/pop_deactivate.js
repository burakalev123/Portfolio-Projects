//OK
if (buttonId === "OK") {
    //
    var deleted = "X";

    //Set Data Action Parameter and execute Data Action
    DA_deactivatePos.setParameterValue("Position", gv_sel_Position_ID_Tech);
    DA_deactivatePos.setParameterValue("Month", "[Date].[YM].&[" + gv_deacMonth + "]");
    //

    Application.showBusyIndicator("Inactivating Position " + gv_sel_Position_ID_Disp);
    var DA_Response = DA_deactivatePos.execute();

    //Show Data Action Status and Refresh if successfull
    if (DA_Response.status === DataActionExecutionResponseStatus.Success) {

        // Added on 28/10/2022 - Burak Alev - Begin
        // If the data action is OK, Update the Position Member
        var member_id = gv_sel_Position_ID_Tech.substring(gv_sel_Position_ID_Tech.lastIndexOf("[") + 1, gv_sel_Position_ID_Tech.lastIndexOf("]"));

        //Updating Deleted and Deleted from (month) columns--BEGIN--//
        gv_delPositionMember = ({
            id: member_id,
            properties: {
                T_001_DELETED: deleted,
                T_001_DELETED_FROM: gv_deacMonth
            }
        });

        var result = PlanningModel_1.updateMembers("PD_001_POSITION", gv_delPositionMember);

        tbl_Existing_Positions.getDataSource().refreshData();

        if (result) {
            Application.showMessage(ApplicationMessageType.Success, "The status of the new position has been changed successfully.");
        } else {
            Application.showMessage(ApplicationMessageType.Warning, "The status of the new position could not be changed.");
        }
        //Updating Deleted and Deleted from (month) columns--END--//
        // Added on 28/10/2022 - Burak Alev - End
        //console.log ("Data Action erfolgreich");
        Application.hideBusyIndicator();
        Application.showMessage(ApplicationMessageType.Success, "Deactivation of Position " + gv_sel_Position_ID_Disp + " successful!");
        pop_deactivate.close();
        Application.refreshData();
    }
    else {
        Application.hideBusyIndicator();
        Application.showMessage(ApplicationMessageType.Error, "An error occured during the execution of the data action DA_deactivatePos");
        pop_deactivate.close();
    }
}

//CANCEL
else if (buttonId === "Cancel") {
    pop_deactivate.close();
}
