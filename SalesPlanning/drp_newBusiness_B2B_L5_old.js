// Initialize selection and index
var i = 0;
var sel_B2B = drp_newBusiness_B2B_L5.getSelectedKey();


if(sel_B2B === "#"){
	
}else{
Application.showBusyIndicator("Loading...");

// Switch based on current B2B hierarchy level
switch (gv_B2B_HierLevel) {
    case 1:
        // Increment the hierarchy level
        gv_B2B_HierLevel = 2;
		
        // Retrieve B2B level members from the SalesPlan model
        var var_B2B_L2 = SalesPlan.getMembers("SP_B2B_LEVEL", {
            limit: 1000,
            hierarchyId: "H_B2B",
            parentId: sel_B2B
        });

        // Populate dropdown with B2B level members
		drp_newBusiness_B2B_L5.removeAllItems();
		drp_newBusiness_B2B_L5.addItem("#", "Please select B2B Level 2...");
        for (i = 0; i < var_B2B_L2.length; i++) {
            var var_B2B_L2_ID = var_B2B_L2[i].id;
            var var_B2B_L2_Desc = var_B2B_L2[i].description;

            drp_newBusiness_B2B_L5.addItem(
                var_B2B_L2_ID,
                var_B2B_L2_ID + " - " + var_B2B_L2_Desc
            );
        }
		drp_newBusiness_B2B_L5.setSelectedKey("#");

        break;
	
	case 2:
		// Increment the hierarchy level
        gv_B2B_HierLevel = 3;

		// Retrieve B2B level members from the SalesPlan model
        var var_B2B_L3 = SalesPlan.getMembers("SP_B2B_LEVEL", {
            limit: 1000,
            hierarchyId: "H_B2B",
            parentId: sel_B2B
        });

        // Populate dropdown with B2B level members
		drp_newBusiness_B2B_L5.removeAllItems();
		drp_newBusiness_B2B_L5.addItem("#", "Please select B2B Level 3...");
        for (i = 0; i < var_B2B_L3.length; i++) {
            var var_B2B_L3_ID = var_B2B_L3[i].id;
            var var_B2B_L3_Desc = var_B2B_L3[i].description;

            drp_newBusiness_B2B_L5.addItem(
                var_B2B_L3_ID,
                var_B2B_L3_ID + " - " + var_B2B_L3_Desc
            );
        }

		drp_newBusiness_B2B_L5.setSelectedKey("#");
        break;
		
	case 3:
        // Increment the hierarchy level
        gv_B2B_HierLevel = 4;
		

		// Retrieve B2B level members from the SalesPlan model
        var var_B2B_L4 = SalesPlan.getMembers("SP_B2B_LEVEL", {
            limit: 1000,
            hierarchyId: "H_B2B",
            parentId: sel_B2B
        });

        // Populate dropdown with B2B level members
		drp_newBusiness_B2B_L5.removeAllItems();
		drp_newBusiness_B2B_L5.addItem("#", "Please select B2B Level 4...");
        for (i = 0; i < var_B2B_L4.length; i++) {
            var var_B2B_L4_ID = var_B2B_L4[i].id;
            var var_B2B_L4_Desc = var_B2B_L4[i].description;

            drp_newBusiness_B2B_L5.addItem(
                var_B2B_L4_ID,
                var_B2B_L4_ID + " - " + var_B2B_L4_Desc
            );
        }

		drp_newBusiness_B2B_L5.setSelectedKey("#");
        break;
		
	case 4:
        // Increment the hierarchy level
        gv_B2B_HierLevel = 5;
		

		// Retrieve B2B level members from the SalesPlan model
        var var_B2B_L5 = SalesPlan.getMembers("SP_B2B_LEVEL", {
            limit: 1000,
            hierarchyId: "H_B2B",
            parentId: sel_B2B
        });

        // Populate dropdown with B2B level members
		drp_newBusiness_B2B_L5.removeAllItems();
		drp_newBusiness_B2B_L5.addItem("#", "Please select B2B Level 5...");
        for (i = 0; i < var_B2B_L5.length; i++) {
            var var_B2B_L5_ID = var_B2B_L5[i].id;
            var var_B2B_L5_Desc = var_B2B_L5[i].description;

            drp_newBusiness_B2B_L5.addItem(
                var_B2B_L5_ID,
                var_B2B_L5_ID + " - " + var_B2B_L5_Desc
            );
        }

		drp_newBusiness_B2B_L5.setSelectedKey("#");
        break;


	
}
Application.hideBusyIndicator();
}