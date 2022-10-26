switch (Version) {
    case "TAP":
        switch (SelectedTab) {
            case "Tab_1":
                ThisApp.SetTablesRefreshPaused(false,
                    [], //reports
                    [tblFTEReference_TAP, tblFTEHrs_TAP]
                );
                break;
            case "Tab_2":
                ThisApp.SetTablesRefreshPaused(false,
                    [], //reports
                    [tblCOSLRates_TAP]
                );
                break;
            case "Tab_4":
                ThisApp.SetTablesRefreshPaused(false,
                    [tblCOSReport_TAP, tblCOSReportDetails_TAP], //reports
                    []
                );
                break;
        }
        break;
    case "MOR":
        switch (SelectedTab) {
            case "Tab_1":
                ThisApp.SetTablesRefreshPaused(false,
                    [], //reports
                    [tblFTEReference, tblFTEHrs]
                );
                break;
            case "Tab_2":
                ThisApp.SetTablesRefreshPaused(false,
                    [], //reports
                    [tblCOSLRates]
                );
                break;
            case "Tab_4":
                ThisApp.SetTablesRefreshPaused(false,
                    [tblCOSReport, tblCOSReportDetails], //reports
                    []
                );
                break;
        }
        break;
}