/*****************************************************************************
 * Sales Planning Application - initApplication Script
 *****************************************************************************/

//==============================
// Initialization
//==============================

// Show busy indicator during initialization
Application.showBusyIndicator("Initializing Sales Planning application...");

//==============================
// Widget Settings Initialization
//==============================
SO_onInit.InipApp01_WidgetSettings();
SO_onInit.InitApp02_WidgetSettings_apply();
SO_onInit.InitApp03_userDetect();

//==============================
// Admin-Specific Setup
//==============================
if (adminTeam === true) {
    SO_onInit.InitApp04_promptVar();
} else {
    //==============================
    // Non-Admin Setup
    //==============================

    //===== Refresh Customer Table Data =====//
    // Resume refresh and refresh customer response table data
    tbl_CustomerResp.getDataSource().refreshData();
    var ds_CustResp = tbl_CustomerResp.getDataSource().getResultSet();

    // Set global variable if not already set
    if (gv_sel_CustResp === '') {
        gv_sel_CustResp = ds_CustResp[0]["SP_CUSTOMERRESP"].id;
        var ConfirmCheck = ds_CustResp[0]["SP_CUSTOMERRESP"].properties["SP_CUSTOMERRESP.Confirm"];
        if (ConfirmCheck === "X") {
            console.log("Selected Account Manager has already confirmed the Budget...");
            Application.showMessage(ApplicationMessageType.Warning, "Selected Account Manager has already confirmed the Budget...");
            pnl_noSaveAfterConfirm.setVisible(true);
            btn_ConfirmBudget.setVisible(false);
            txt_ConfirmedBudget.setVisible(true);
        }
    }
    inpc_CustResp.getInputControlDataSource().setSelectedMembers(gv_sel_CustResp);

    SO_onInit.InitApp05_dateSelections();
    SO_onInit.InitApp06_WidgetSettings_activate();
    pnl_InitBackground.setVisible(false);
    txt_ShellBar_CustomerResp.setVisible(true);
//	ActionScripts.PlanningErrors();
}

gv_Customer_check = false;
gv_Article_check = false;

//==============================
// Final Application Setup
//==============================
// Enable comment mode
Application.setCommentModeEnabled(true);
// Hide busy indicator
Application.hideBusyIndicator();
/*****************************************************************************
 * End
 *****************************************************************************/