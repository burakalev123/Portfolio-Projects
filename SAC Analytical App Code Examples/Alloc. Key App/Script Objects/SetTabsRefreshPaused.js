//==============================================================
// function SetTabsRefreshPaused(selectedTab: String) : void
//==============================================================


switch(tsContent.getSelectedKey()){
	case "Tab_1":
ThisApp.SetTablesRefreshPaused(false,[], [tblFTE,tblFTE_MPS]);
	break;
	case "Tab_2":
ThisApp.SetTablesRefreshPaused(false,[], [tblWIB]);
	break;
}