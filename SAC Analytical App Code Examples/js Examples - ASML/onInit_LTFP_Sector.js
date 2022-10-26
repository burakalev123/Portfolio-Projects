//var i = 0;

//Application settings
Application.setCommentModeEnabled(false);
Application.setAutomaticBusyIndicatorEnabled(false);
Application.showBusyIndicator("Loading...");
bEnableConsole = true;

//-----------------------------------------------
// Version Dimension
//-----------------------------------------------

//Get Version MD
//---------------------
/*
dVersion_all = FIN_PL_LTFP.getMembers("Version",{limit:200});
if (sVersion) {
    //var dVersion = FIN_PL_LTFP.getMember("Version",sVersion);
    /*switch (dVersion.properties.CATEGORY) {
        case "Forecast":
        dVersion_currentMOR = dVersion;
        break;
    }*
}

//Get Current Versions
//---------------------
for (i=0;i<dVersion_all.length; i++) {
    if (dVersion_all[i].properties.PLAN_START.length>0) { //if not actual
    	
        switch (dVersion_all[i].properties.STATUS) {
            case "CURRENT":
                dVersion_current = dVersion_all[i]; //get the current version (where STATUS=CURRENTMOR)
            break;
        }
    }
}*/
dVersion_current = FIN_PL_LTFP.getMember("Version", "public.NewPlan");
//dVersion_previousMOR = FIN_PL_LTFP.getMember("Version", "public."+dVersion_current.properties.PREV);
if (bEnableConsole) { console.log("Current version: "); console.log(dVersion_current); }
//if (bEnableConsole) {console.log("Previous version: "+dVersion_previousMOR.id);}


//====================================================================
// Start Widgets pre-processing
//====================================================================

//Get Sector Filter Member from URL parameter
if (sSector === "") {
    //If not found, scan Master Data
    //ThisApp.GetMDSectors();
    sSector = "TOT_SEC";
}

//Get Sector information
dSector = FIN_PL_LTFP.getMember("Sector", sSector);
if (bEnableConsole) { console.log(dSector); }

//Update Application Header Title
txtHeaderTitle.applyText("Sector Expense Planning \n " + dSector.description);

//Enable Widget Filters & Refresh asynchronously
RefreshTabAsync.start(0);