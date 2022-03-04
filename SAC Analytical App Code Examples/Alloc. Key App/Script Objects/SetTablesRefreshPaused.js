//==============================================================
// function SetTablesRefreshPaused(setRefreshPaused: boolean, ReportTables: Table[], InputTables: Table[]) : void
//==============================================================

var i =0;

//==============================================================
// Set Table Widgets to refresh or not
//==============================================================
for (i=0;i<InputTables.length;i++){
	InputTables[i].getDataSource().setRefreshPaused(setRefreshPaused);
	InputTables[i].getPlanning().setEnabled(!setRefreshPaused);
}

for (i=0;i<ReportTables.length;i++){
	ReportTables[i].getDataSource().setRefreshPaused(setRefreshPaused);
}