var publicVersion = Table_1.getPlanning().getPublicVersion("Actual");
//Actual secimi burda dropdowndan olabilir..

var privateVersion = publicVersion.copy("Private_Forecast_10", PlanningCopyOption.AllData, PlanningCategory.Forecast);
console.log(privateVersion);

//Publish private version as public with a new name
var test = Table_1.getPlanning().getPrivateVersion("Private_Forecast_10").publishAs("Public_Forecast_10",PlanningCategory.Forecast);