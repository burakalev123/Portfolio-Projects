//get Position

var sel_Position = tbl_Existing_Positions.getSelections();
console.log(sel_Position);

if (sel_Position[0]["PD_001_POSITION"] !== undefined) {
    gv_sel_Position_ID_Tech = sel_Position[0]["PD_001_POSITION"];
    gv_sel_Position_ID_Disp = tbl_Existing_Positions.getDataSource().getMember("PD_001_POSITION", gv_sel_Position_ID_Tech).displayId;

    // Addon Burak Alev 11.11.2022
    // Toggle status switch on or off based on existing record
    if (this.getSelections().length > 0) {
        // Enable switch
        swt_budtype_existPos.setEnabled(true);

        // Get result set for selection
        var result_set = this.getDataSource().getResultSet({ "PD_001_POSITION": this.getSelections()[0]["PD_001_POSITION"] });

        // Read status from property
        var status = result_set[0]["PD_001_POSITION"].properties["PD_001_POSITION.T_001_BUDTYPE_PLNYEAR"];
        console.log(status);
        // Set switch
        if (status === "Yes") {
            swt_budtype_existPos.setOn(true);
        } else if (status === "No") {
            swt_budtype_existPos.setOn(false);
        } else {
            swt_budtype_existPos.setOn(false);
        }
    }
}
//}
