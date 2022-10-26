// function SetTabsRefreshPaused(SelectedTab: string) : void

switch (tsContent.getSelectedKey()) {
    case "Tab_1":
        ThisApp.SetTablesRefreshPaused(false, [tblServicePLbefore, tblServiceFTE], []);
        chbRevMeasures.setVisible(false);
        chbFTEMeasures.setVisible(true);
        break;
    case "Tab_2":
        ThisApp.SetTablesRefreshPaused(false, [tblServicePLafter], []);
        chbRevMeasures.setVisible(false);
        chbFTEMeasures.setVisible(false);
        break;
    case "Tab_3":
        ThisApp.SetTablesRefreshPaused(false, [tblUpgradePLbefore, tblUpgradePL_Perc], []);
        chbRevMeasures.setVisible(true);
        chbFTEMeasures.setVisible(false);
        break;
    case "Tab_4":
        ThisApp.SetTablesRefreshPaused(false, [tblUpgradePLafter], []);
        chbRevMeasures.setVisible(false);
        chbFTEMeasures.setVisible(false);
        break;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////



if (buttonId === "button1") {

    switch (rbg_selection.getSelectedKey()) {
        case "create":
            var FCT_value = if_newForecastVersion.getValue();
            console.log(FCT_value);

            var PLN_value = if_newPlanVersion.getValue();
            console.log(PLN_value);

            var publicVersionFCT = Table_1.getPlanning().getPublicVersion("Forecast");
            var publicVersionPLN = Table_1.getPlanning().getPublicVersion("Plan");
            ///////////////
            while (FCT_value.length > 0) {
                var privateVersionFCTcreate = publicVersionFCT.copy(FCT_value, PlanningCopyOption.NoData, PlanningCategory.Forecast);
                console.log(privateVersionFCTcreate);
            }
            ///////////////
            while (PLN_value.length > 0) {
                var privateVersionPLNcreate = publicVersionPLN.copy(PLN_value, PlanningCopyOption.NoData, PlanningCategory.Planning);
                console.log(privateVersionPLNcreate);
            }
            //Publish private version as public with a new name
            var test = Table_1.getPlanning().getPrivateVersion(FCT_value).publishAs(FCT_value, PlanningCategory.Forecast);
            console.log(test);
            break;

        case "delete":
            var selected_vers = rbg_vers_selection.getSelectedKey().substr(7, 100);
            console.log("Version will be deleted: " + selected_vers);

            var publicVersiondel = Table_1.getPlanning().getPublicVersion(selected_vers);

            var privateVersiondelete = publicVersiondel.deleteVersion();
            console.log(privateVersiondelete);

            break;

    }
} else {
    Popup_newVersion.close();
}
