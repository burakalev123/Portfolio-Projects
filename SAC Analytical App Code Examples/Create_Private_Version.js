var publicVersion = Table_1.getPlanning().getPublicVersion("Actual");
//Actual secimi burda dropdowndan olabilir..

var privateVersion = publicVersion.copy("Private_Forecast_10", PlanningCopyOption.AllData, PlanningCategory.Forecast);
console.log(privateVersion);