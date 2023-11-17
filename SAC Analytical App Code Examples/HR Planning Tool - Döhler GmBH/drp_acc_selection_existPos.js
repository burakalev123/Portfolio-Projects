var AccMeasure = drp_acc_selection_existPos.getSelectedKey();

if (AccMeasure === "fte") {
	tbl_Existing_Positions.getDataSource().setDimensionFilter("PD_001_ACCOUNT", ["[PD_001_ACCOUNT].[parentId].&[KN_001_FTE]"]);
} else {
	tbl_Existing_Positions.getDataSource().setDimensionFilter("PD_001_ACCOUNT", ["[PD_001_ACCOUNT].[parentId].&[KN_001_FTE]", "[PD_001_ACCOUNT].[parentId].&[KN_002_TOTAL_COSTS]"]);
};







