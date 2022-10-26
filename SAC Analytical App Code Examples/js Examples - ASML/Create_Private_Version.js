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
            if (FCT_value) {
                var privateVersionFCTcreate = publicVersionFCT.copy(FCT_value, PlanningCopyOption.NoData, PlanningCategory.Forecast);
                console.log(privateVersionFCTcreate);
                var FCT_VERS = Table_1.getPlanning().getPrivateVersion(FCT_value).publishAs(FCT_value, PlanningCategory.Forecast);
                console.log(FCT_VERS);
            }
            ///////////////
            if (PLN_value) {
                var privateVersionPLNcreate = publicVersionPLN.copy(PLN_value, PlanningCopyOption.NoData, PlanningCategory.Planning);
                console.log(privateVersionPLNcreate);
                var PLN_VERS = Table_1.getPlanning().getPrivateVersion(PLN_value).publishAs(PLN_value, PlanningCategory.Forecast);
                console.log(PLN_VERS);
            }
            //Publish private version as public with a new name

            break;
            Popup_newVersion.close();
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