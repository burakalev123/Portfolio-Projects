//OK
if (buttonId === "OK") {

    Application.showBusyIndicator();
    createPos.editNewPosition();
    console.log("new position updated");
    Application.refreshData();

    pop_edit_newPos.close();
    Application.hideBusyIndicator();
}
//CANCEL
else if (buttonId === "Cancel") {
    Application.showBusyIndicator();

    pop_edit_newPos.close();

    Application.hideBusyIndicator();
}



