//Application.showBusyIndicator();

{
	//ID 
	//newIPID = ThisApp.getAutoIPID();
	//  lblIPID.applyText(newIPID);
	
	//Auto-Assign User ID
	var UserID = Application.getUserInfo().id;
	lblIPUSER.applyText(UserID);
	
	//Current Date to textbox, auto-assign
	
	UserDefault = CAPEXPPREF.getMember("CAPEX_USERS", UserID);	
	var current_dateIP = new Date(Date.now());
 	var year = current_dateIP.getFullYear();
 	var month = current_dateIP.getMonth();; 

	if (month.toString().length === 1 )	{
	DateCreate = 	year.toString() + "0" + month.toString();
	}
 else {DateCreate = 	year.toString() + month.toString();}
 
	var datetext = DateFormat.format(current_dateIP);
 	lblIPDATECREATE.applyText(datetext);
								
	//populate the Investment Proposal type and all the dropdown menus
	//this restricts users to select only predefined values
	var TPPCTypes = ArrayUtils.create(Type.string);
	var TPCompCodeTypes = ArrayUtils.create(Type.string);
	var TPSectorTypes = ArrayUtils.create(Type.string);
	var TPProgramTypes = ArrayUtils.create(Type.string);
	var TPUsers = ArrayUtils.create(Type.string);
	
var CAPEXCCTP = CAPEX.getMembers("CostCenter",{limit: 5000});
var CAPEXWBSTP = CAPEXPPREF.getMembers("DD_Properties",{limit: 3000});


	for (var counter = 0; counter < CAPEXWBSTP.length; counter++)
	  {
	
		
		  
		  var currentPCTP = CAPEXWBSTP[counter].properties.PROFIT_CTR;
		  
		  var currentCompCodeTP = CAPEXWBSTP[counter].properties.COMP_CODE;
		  
		  var currentProgramTP = CAPEXWBSTP[counter].properties.PROGRAM;
		  
		
		  
		 
		   ////Program
		  if(TPProgramTypes.indexOf(currentProgramTP) === -1 && currentProgramTP)
			{
			   TPProgramTypes.push(currentProgramTP);
			   Dropdown_IP_PROGRAM.addItem(currentProgramTP);
			}
		  
		  

		  
		  ////Profit Center
		  if(TPPCTypes.indexOf(currentPCTP) === -1 && currentPCTP)
			{
			   TPPCTypes.push(currentPCTP);
			   Dropdown_IP_PC.addItem(currentPCTP);
			}
		  
		  
		  ////Company Code
		  if(TPCompCodeTypes.indexOf(currentCompCodeTP) === -1 && currentCompCodeTP)
			{
			   TPCompCodeTypes.push(currentCompCodeTP);
		//	   Dropdown_IP_COMPCODE.addItem(currentCompCodeTP);
			}
	  }
 	
	
	  }
/*
for (var counter2 = 0; counter2 < CAPEXCCTP.length; counter2++)
	  { var currentSectorTP = CAPEXCCTP[counter2].properties.ZX_FISEC + " " + CAPEXCCTP[counter2].properties.ZX_FISEC_TXT;
	   var currentidSector = CAPEXCCTP[counter2].properties.ZX_FISEC;
	  	  ////Sector
		    if(TPSectorTypes.indexOf(currentSectorTP) === -1 && currentSectorTP)
			{
			   TPSectorTypes.push(currentSectorTP);
				SectorIP.push(currentidSector); 
			//   Dropdown_IP_SECTOR.addItem(currentidSector, currentSectorTP);
			//	Dropdown_IP_RECSECTOR.addItem(currentidSector, currentSectorTP);
			}
	  }
*/

for (var counter2 = 0; counter2 < CAPEXCCTP.length; counter2++) {
	   var currentSectorTP = CAPEXCCTP[counter2].properties.ZX_FISEC + " " + CAPEXCCTP[counter2].properties.ZX_FISEC_TXT;
	   var currentidSector = CAPEXCCTP[counter2].properties.ZX_FISEC;
	  	  ////Sector
	   if (UserDefault.properties.ZX_FISEC !== "") {
		   
		   var sector = UserDefault.properties.ZX_FISEC;
		   arrSector = sector.split(',');
		   
		   for (var counters =0; counters < arrSector.length; counters++) {
		    if((TPSectorTypes.indexOf(currentSectorTP) === -1 && currentSectorTP) && (CAPEXCCTP[counter2].properties.ZX_FISEC === arrSector[counters]))
			{
			   TPSectorTypes.push(currentSectorTP);
				SectorIP.push(currentidSector); 
			//   Dropdown_IP_SECTOR.addItem(currentidSector, currentSectorTP);
			//	Dropdown_IP_RECSECTOR.addItem(currentidSector, currentSectorTP);
			}
		   }
	   } else if (UserDefault.properties.Sub_Division_Sec !== "")	{
		   var subdiv = UserDefault.properties.Sub_Division_Sec;
		   arrSubDiv = subdiv.split(',');
		   
		   for (var counterd =0; counterd < arrSubDiv.length; counterd++) {
		    if((TPSectorTypes.indexOf(currentSectorTP) === -1 && currentSectorTP) && (CAPEXCCTP[counter2].properties.ZX_FISDIV === arrSubDiv[counterd]))
			{
			   TPSectorTypes.push(currentSectorTP);
				SectorIP.push(currentidSector); 
			//   Dropdown_IP_SECTOR.addItem(currentidSector, currentSectorTP);
			//	Dropdown_IP_RECSECTOR.addItem(currentidSector, currentSectorTP);
			}
		   }
	  } else {
		  if (TPSectorTypes.indexOf(currentSectorTP) === -1 && currentSectorTP)
			{
			   TPSectorTypes.push(currentSectorTP);
				SectorIP.push(currentidSector); 
			//   Dropdown_IP_SECTOR.addItem(currentidSector, currentSectorTP);
			//	Dropdown_IP_RECSECTOR.addItem(currentidSector, currentSectorTP);
  		}
	}
}

TPSectorTypes.sort();
SectorIP.sort();

for (var counterSector = 0; counterSector < SectorIP.length; counterSector++)
	{
		Dropdown_IP_SECTOR.addItem(SectorIP[counterSector], TPSectorTypes[counterSector]);
		Dropdown_IP_RECSECTOR.addItem(SectorIP[counterSector], TPSectorTypes[counterSector]);
	}


//Set default values for users
var defaults = 1;
		    if(defaults === 1)
				
	

{
//	UserDefault = CAPEXPPREF.getMember("CAPEX_USERS", UserID);				  
	Dropdown_IP_PROGRAM.setSelectedKey(UserDefault.properties.PROGRAM);
	
	if (UserDefault.properties.PGP_WBS){
	ddPGPWBS.setSelectedKey(UserDefault.properties.PGP_WBS);
	}
	Dropdown_IP_SECTOR.setSelectedKey(UserDefault.properties.SECTOR);
	Dropdown_IP_RECSECTOR.setSelectedKey(UserDefault.properties.SECTOR);
	
	
	Dropdown_IP_PC.setSelectedKey(UserDefault.properties.PROFIT_CENTER);
	inputIPLeadTime.setValue(UserDefault.properties.DELAY);
	if (UserDefault.properties.ASSET_TYPE){
	ddIPAsset.setSelectedKey(UserDefault.properties.ASSET_TYPE);
	}
	
	


CurrentDimension_TP = CAPEX.getMembers("CostCenter", {limit: 6000});

Dropdown_IP_CC.removeAllItems();
Dropdown_IP_RESCC.removeAllItems();

if (UserDefault.properties.SECTOR){
	
var selection = Dropdown_IP_SECTOR.getSelectedKey().substr(0, 4);
//console.log(selection);

for (var z = 0;z < CurrentDimension_TP.length;z++){
	if (CurrentDimension_TP[z].properties.ZX_FISEC === selection)
	{Dropdown_IP_CC.addItem(CurrentDimension_TP[z].id, CurrentDimension_TP[z].id + " " + CurrentDimension_TP[z].description);
	 Dropdown_IP_RESCC.addItem(CurrentDimension_TP[z].id, CurrentDimension_TP[z].id + " " + CurrentDimension_TP[z].description);
}}

	newIPID = ThisApp.getAutoIPID();
	   lblIPID.applyText(newIPID);

}	
	if (UserDefault.properties.COSTCENTER){
	
	Dropdown_IP_RESCC.setSelectedKey(UserDefault.properties.COSTCENTER);

	
	
	var selection5 = Dropdown_IP_RESCC.getSelectedKey();


for (var zy = 0;zy < CurrentDimension_TP.length;zy++){
	if (CurrentDimension_TP[zy].id === selection5)
	{ //Dropdown_IP_COMPCODE.addItem(CurrentDimension_TP[z].properties.COMP_CODE_ID, CurrentDimension_TP[z].properties.COMP_CODE_ID + " " + CurrentDimension_TP[z].properties.COMP_CODE);
//	 Dropdown_IP_COMPCODE.setSelectedKey(CurrentDimension_TP[z].properties.COMP_CODE_ID);
	 IPCompCode = CurrentDimension_TP[zy].properties.COMP_CODE_ID;
}}

Dropdown_IP_RECSECTOR.setSelectedKey(Dropdown_IP_SECTOR.getSelectedKey());
Dropdown_IP_CC.removeAllItems();

		

var selection6 = Dropdown_IP_RECSECTOR.getSelectedKey().substr(0, 4);
//console.log(selection);

for (var yz = 0;yz < CurrentDimension_TP.length;yz++){
	if (CurrentDimension_TP[yz].properties.ZX_FISEC === selection6 && CurrentDimension_TP[yz].properties.COMP_CODE_ID === IPCompCode)
	{Dropdown_IP_CC.addItem(CurrentDimension_TP[yz].id, CurrentDimension_TP[yz].id + " " + CurrentDimension_TP[yz].description);
}}
	
	Dropdown_IP_CC.setSelectedKey(UserDefault.properties.REC_CC);
	

	}

Popup_IP.open();	

	if (UserDefault.properties.SECTOR)
		
		{

Dimension_PC_IP = CAPEXPPREF.getMembers("DD_Properties", {limit: 3000});
//Dimension_SECTOR_IP = CAPEXPPREF.getMember()("Sector", {limit: 200});
ddIPSSC.removeAllItems();

var arraySectorSpecific = ArrayUtils.create(Type.string);

var selection2 = CAPEXPPREF.getMember("Sector", Dropdown_IP_SECTOR.getSelectedKey().substr(0, 4)).hierarchies.H1.parentId;
//console.log("Hierarchy" + selection2);

for (var y = 0;y < Dimension_PC_IP.length;y++){
	if (Dimension_PC_IP[y].properties.SEC_SPEC_ID === selection2){
		console.log(Dimension_PC_IP[y].properties.SEC_SPEC_ID);
		ddIPSSC.addItem(Dimension_PC_IP[y].properties.SSC);
		arraySectorSpecific.push(Dimension_PC_IP[y].properties.SSC);
}
}

if (arraySectorSpecific.length < 1){
	var selection3 = CAPEXPPREF.getMember("Sector", selection2).hierarchies.H1.parentId;
	
	for (var x = 0;x < Dimension_PC_IP.length;x++){
	if (Dimension_PC_IP[x].properties.SEC_SPEC_ID === selection3){
	//	console.log("Tweede lookup" + Dimension_PC_IP[x].properties.SEC_SPEC_ID);
		ddIPSSC.addItem(Dimension_PC_IP[x].properties.SSC);
		arraySectorSpecific.push(Dimension_PC_IP[x].properties.SSC);
	
}
}
}
if (arraySectorSpecific.length < 1){
//	console.log("ERROR");
ddIPSSC.addItem("#", "Empty, please contact Key-user")	;
	
}

//if ddIPSSC. === 0 {ddIPSCC.addItem(Empty, reach out to key-user)}
ddIPSSC.setSelectedKey(UserDefault.properties.SSC);	
	
		}	

			}
//	  }


var lhi = ArrayUtils.create(Type.number);
for (var l = 0; l <= 10; l++) {
   lhi.push(l);
}for(var d=5;d<=10;d++) // Add items to Checkbox
        { 
			ddUseful.addItem(lhi[d].toString());
		ddUseful.setSelectedKey("5");}


	var CAPEXUsers = CAPEXPPREF.getMembers("CAPEX_USERS",{limit: 200});

for (var counter3 = 0; counter3 < CAPEXUsers.length; counter3++)
	  { var Users = CAPEXUsers[counter3].description;
	   var UsersID = CAPEXUsers[counter3].id;
	  	  ////Sector
		    if(TPUsers.indexOf(Users) === -1 && Users && Users !== "Unassigned")
			{
			   TPUsers.push(Users);
			   ddRequest.addItem(UsersID, Users);

			}
	  }

//Application.hideBusyIndicator();

//Dropdown_IP_COMPCODE.removeAllItems();









