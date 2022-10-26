Application.showBusyIndicator("Executing...");

//Version Check -> MOR
if (sVersion === "" || sVersion === dVersion_currentMOR.id) {
    //Execute Data Action ->NEWFCT_ISBP007_L2_COS_PARTS_LABOR
    var resp = datCALC_L2.execute();
    if (resp) {
        Application.showMessage(ApplicationMessageType.Success, "Data Action completed Succesfully! Calculated figures will be Published now!");
    } else {
        Application.showMessage(ApplicationMessageType.Error, "Error running calculations.");
    }
    //--------------------------------------------------------------//	
    switch (resp.status) {
        //Success...
        case DataActionExecutionResponseStatus.Success:
            //Check for Dirty Versions where changes were made
            var tableversions = tblCOSM.getPlanning().getPublicVersions();
            for (var i = 0; i < tableversions.length; i++) {
                if (tableversions[i].isDirty()) {
                    //If there's a dirty version, publish
                    tableversions[i].publish();
                    Application.showMessage(ApplicationMessageType.Success, "Coverage SEED action will be executed!");
                    //--------------------------------------------------------------//	
                    var seed = datSEED_COVERAGE.execute();
                    if (seed) {
                        Application.showMessage(
                            ApplicationMessageType.Success,
                            "Coverage figures have been updated!"
                        );
                    } else {
                        Application.showMessage(
                            ApplicationMessageType.Error, "Coverage figures could not be updated! Please try again or contact IT support."
                        );
                    }
                    //--------------------------------------------------------------//	
                }
            }
            break;
        //Error...
        case DataActionExecutionResponseStatus.Error:
            Application.showMessage(ApplicationMessageType.Error, "Error running calculations.");
            break;
    }
    //--------------------------------------------------------------//	
}
//Version Check -> TAP 
else {
    //Execute Data Action ->NEWBUD_ISBP007_L2_COS_PARTS_LABOR
    var resp_TAP = datCALC_L2_TAP.execute();
    //--------------------------------------------------------------//	
    switch (resp_TAP.status) {
        //Success...	
        case DataActionExecutionResponseStatus.Success:
            //Check for Dirty Versions where changes were made
            var tableversions_TAP = tblCOSM_TAP.getPlanning().getPublicVersions();
            for (var j = 0; j < tableversions_TAP.length; j++) {
                if (tableversions_TAP[j].isDirty()) {
                    //If there's a dirty version, publish
                    tableversions_TAP[j].publish();
                }
            }
            break;
        //Error...	
        case DataActionExecutionResponseStatus.Error:
            Application.showMessage(ApplicationMessageType.Error, "Error running calculations.");
            break;
    }
    //--------------------------------------------------------------//	
}


//Refresh
popPublish.close();
Application.refreshData();
Application.hideBusyIndicator();