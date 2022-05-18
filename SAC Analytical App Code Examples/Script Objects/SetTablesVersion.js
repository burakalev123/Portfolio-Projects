// function SetTablesVersion(Verison: string[], Tables: Table[]) : void

var i = 0;

//==============================================================
// Apply Version selection to Planning Table Widgets
//==============================================================
for (i = 0; i < Tables.length; i++) {
    var ds = Tables[i].getDataSource();
    ds.setDimensionFilter("Version", Version);
}