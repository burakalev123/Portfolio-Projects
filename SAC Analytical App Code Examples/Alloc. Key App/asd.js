if (sVersion === "" || sVersion === dVersion_currentMOR.id) {

    popPublish.close();
    Application.showBusyIndicator();

    var xyz = DERIVE_Publish.execute();
    Application.refreshData();
    Application.hideBusyIndicator();

    bPublish = false;

    if (xyz) {
        Application.showMessage(
            ApplicationMessageType.Success,
            "Data Action Succesful! Data has been calculated and published."
        );
    } else {
        Application.showMessage(
            ApplicationMessageType.Error, "Data Action failed, please try again or contact IT support."
        );
    }

}
else {

    popPublish.close();
    Application.showBusyIndicator();

    var xyz_tap = DERIVE_Publish_TAP.execute();
    Application.refreshData();
    Application.hideBusyIndicator();

    bPublish = false;

    if (xyz_tap) {
        Application.showMessage(
            ApplicationMessageType.Success,
            "Data Action Succesful! Data has been calculated and published."
        );
    } else {
        Application.showMessage(
            ApplicationMessageType.Error, "Data Action failed, please try again or contact IT support."
        );
    }

}
