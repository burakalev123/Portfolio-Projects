// Erhard Ludwig 07.10.2022
// Basierend auf dem Switch wird für das ausgewählte Element die Property direkt im Modell verändert (in proposal oder denied)

var status = "";

// Element war auf denied, also im Modell auf in proposal setzen
if (this.isOn()) {
    status = "in proposal";
    // Element war auf in proposal, also im Modell auf denied setzen
} else if (!this.isOn()) {
    status = "denied";
}

// Only pull the member ID from the global variable without hierarchy (via substring & lastIndexOf), since this is what is required for updateMembers
var member_id = gv_sel_Position_ID_Tech.substring(gv_sel_Position_ID_Tech.lastIndexOf("[") + 1, gv_sel_Position_ID_Tech.lastIndexOf("]"));

gv_newPositionMember = ({
    id: member_id,
    properties: {
        T_001_STATUS_NEW_POSITION: status
    }
});

var result = PlanningModel_1.updateMembers("PD_001_POSITION", gv_newPositionMember);

tbl_New_Positions.getDataSource().refreshData();

if (result) {
    Application.showMessage(ApplicationMessageType.Success, "The status of the new position has been changed successfully.");
} else {
    Application.showMessage(ApplicationMessageType.Warning, "The status of the new position could not be changed.");
}

// Je nach Wunsch entweder nach einer Änderung den Switch resetten oder so lassen wie er war (man sieht in der Tabelle die Selection nur nicht mehr)
//swt_status_newPos.setOn(false);
//swt_status_newPos.setEnabled(false);