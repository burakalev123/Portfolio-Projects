switch (this.getSelectedKey()) {
	case "Q":
		ThisApp.SetTablesTimeQ(
			dVersion_currentMOR.properties.PLAN_START,
			dVersion_currentMOR.properties.PLAN_END,
			1,
			[tblServicePLbefore, tblServicePLafter, tblInstallPLbefore, tblInstallPLafter, tblUpgradePLbefore, tblUpgradePLafter]);
		break;
	case "H":
		ThisApp.SetTablesTimeH(
			dVersion_currentMOR.properties.PLAN_START,
			dVersion_currentMOR.properties.PLAN_END,
			1,
			[tblServicePLbefore, tblServicePLafter, tblInstallPLbefore, tblInstallPLafter, tblUpgradePLbefore, tblUpgradePLafter]);
		break;
	case "Y":
		ThisApp.SetTablesTimeY(
			dVersion_currentMOR.properties.PLAN_START,
			dVersion_currentMOR.properties.PLAN_END,
			0,
			[tblServicePLbefore, tblServicePLafter, tblInstallPLbefore, tblInstallPLafter, tblUpgradePLbefore, tblUpgradePLafter]);
		break;
	case "M":
		ThisApp.SetTablesTimeM(
			dVersion_currentMOR.properties.PLAN_START,
			dVersion_currentMOR.properties.PLAN_END,
			1,
			[tblServicePLbefore, tblServicePLafter, tblInstallPLbefore, tblInstallPLafter, tblUpgradePLbefore, tblUpgradePLafter]);
		break;
}