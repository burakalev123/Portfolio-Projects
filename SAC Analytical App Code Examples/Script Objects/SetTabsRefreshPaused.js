// function SetTabsRefreshPaused(SelectedTab: string) : void

switch (tsContent.getSelectedKey()) {
    case "Tab_1":
        ThisApp.SetTablesRefreshPaused(false, [tblServicePLbefore, tblServiceFTE], []);
        chbRevMeasures.setVisible(false);
        chbFTEMeasures.setVisible(true);
        break;
    case "Tab_2":
        ThisApp.SetTablesRefreshPaused(false, [tblServicePLafter], []);
        chbRevMeasures.setVisible(false);
        chbFTEMeasures.setVisible(false);
        break;
    case "Tab_3":
        ThisApp.SetTablesRefreshPaused(false, [tblUpgradePLbefore, tblUpgradePL_Perc], []);
        chbRevMeasures.setVisible(true);
        chbFTEMeasures.setVisible(false);
        break;
    case "Tab_4":
        ThisApp.SetTablesRefreshPaused(false, [tblUpgradePLafter], []);
        chbRevMeasures.setVisible(false);
        chbFTEMeasures.setVisible(false);
        break;
}