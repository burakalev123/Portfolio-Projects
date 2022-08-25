//ISBP102 SBP - Manual Input Schedule
var sNewTabs = ""; if (bNewTabs) { sNewTabs = "true"; } else { sNewTabs = "false"; }
var sVersion = dVersion_currentMOR.id; if (rbgVersion.getSelectedKey() === 'TAP') { sVersion = dVersion_currentTAP.id; }
NavigationUtils.openApplication("1EA0EF02F2A92EF61CB04A28558E976D",
    [
        UrlParameter.create("p_bNewTabs", sNewTabs),
        UrlParameter.create("mode", "embed"),
        UrlParameter.create("p_sVersion", sVersion)
    ],
    bNewTabs);