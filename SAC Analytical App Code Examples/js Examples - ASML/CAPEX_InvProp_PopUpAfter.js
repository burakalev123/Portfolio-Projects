//console.log(Dropdown_IP_PROGRAM.getSelectedKey());


if (buttonId === "bttnNext") {
	if (ddDepOption.getSelectedKey() === "Cash-out timing") {
		InputField_IP_PTDYEAR.setValue("1900");
		InputField_IP_DATE.setValue("1900");
		if (inputIPLeadTime.getValue().length === 0) {
			inputIPLeadTime.setValue("0");
		}
	}
	if (InputAmountYear = true) {
		//	if(ddDepOption.getSelectedKey() === "Cash-out timing" && inputIPLeadTime.getValue().length === 0)
		if (inputIPLeadTime.getValue().length === 0) { inputIPLeadTime.setValue("0"); }
		if (InputField_IP_DESC.getValue().length > 0 && ((InputField_IP_DATE.getValue().length > 0 && InputField_IP_PTDYEAR.getValue().length > 0 || inputIPLeadTime.getValue().length > 0))
			//  && InputField_IP_REASON.getValue().length>0
			&& Dropdown_IP_SECTOR.getSelectedKey().substr(0, 4).length > 1
			// && Dropdown_IP_PC.getSelectedKey() !== undefined  && Dropdown_IP_CC.getSelectedKey() !== undefined && Dropdown_IP_PROGRAM.getSelectedKey() !== undefined
			&& Dropdown_IP_CC.getSelectedKey() !== undefined


		) {
			if (InputValidMin = true) {
				if (ThisAppInputValid = true) {
					if (InputAmountValid = true) {
						panIPMandatory.setVisible(false);
						panIPOptional.setVisible(true);
						Popup_IP.setButtonVisible("bttnAdd", true);
						Popup_IP.setButtonVisible("bttnPrev", true);
						Popup_IP.setButtonVisible("bttnNext", false);
					}
					else {
						Application.showMessage(ApplicationMessageType.Error, "One of the inputfields exceeds the limit of 127 characters, please check this in order to advance");
					}
				}
				else {
					Application.showMessage(ApplicationMessageType.Error, "Input is not valid, please check and try again");
				}
			}
			else {
				Application.showMessage(ApplicationMessageType.Error, "Some required fields have not been filled out properly, please check and try again");
			}
		}
		else {
			Application.showMessage(ApplicationMessageType.Error, "Some required fields have not been filled in properly, please check and try again");
		}
	}


	else { Application.showMessage(ApplicationMessageType.Error, "The input years are invalid, please try again."); }

}



if (buttonId === "bttnPrev") {
	panIPMandatory.setVisible(true);
	panIPOptional.setVisible(false);
	Popup_IP.setButtonVisible("bttnAdd", false);
	Popup_IP.setButtonVisible("bttnPrev", false);
	Popup_IP.setButtonVisible("bttnNext", true);
}



if (buttonId === "bttnAdd") {
	if (ddDepOption.getSelectedKey() === "Cash-out timing") {
		InputField_IP_PTDYEAR.setValue("1900");
		InputField_IP_DATE.setValue("1900");
		if (inputIPLeadTime.getValue().length === 0) {
			inputIPLeadTime.setValue("0");
		}
	}
	if (InputAmountYear = true) {



		if (InputField_IP_DESC.getValue().length > 0 && ((InputField_IP_DATE.getValue().length > 0 && InputField_IP_PTDYEAR.getValue().length > 0) || inputIPLeadTime.getValue().length > 0) && InputField_IP_REASON.getValue().length > 0 && Dropdown_IP_PROGRAM.getSelectedKey() !== undefined && Dropdown_IP_PC.getSelectedKey() !== undefined && ddIPSSC.getSelectedKey() !== undefined && (Dropdown_IP_TRIGGER.getSelectedKey() === "Volume" && (InputField_IP_MRF.getValue() && inputIPMRT) || Dropdown_IP_TRIGGER.getSelectedKey() !== "Volume")
		) {
			if (InputValidMin = true) {
				if (ThisAppInputValid = true) {
					if (InputAmountValid = true) {

						//set Default values for empty properties
						if (inputQuantity.getValue().length === 0) {
							inputQuantity.setValue("0");
						}
						if (inputLink.getValue().length === 0) {
							inputLink.setValue("#");
						}
						if (inputIPLeadTime.getValue().length === 0) {
							inputIPLeadTime.setValue("0");
						}
						if (inputIP12NC.getValue().length === 0) {
							inputIP12NC.setValue("#");
						}
						if (InputField_IP_MRF.getValue().length === 0) {
							InputField_IP_MRF.setValue("#");
						}
						if (inputIPMRT.getValue().length === 0) {
							inputIPMRT.setValue("#");
						}
						if (InputField_IP_DATE.getValue().length === 0) {
							InputField_IP_DATE.setValue("1900");
						}
						if (InputField_IP_PTDYEAR.getValue().length === 0) {
							InputField_IP_PTDYEAR.setValue("1900");
						}



						//Insert the new proposal
						IPMember = ({
							id: newIPID, description: InputField_IP_DESC.getValue(), hierarchies: { PARENTID: { parentId: "TOTAL_IPS" } }, properties:
							{
								//Activity
								ACTIVITY: Dropdown_IP_ACTIVITY.getSelectedKey(),

								//Description as text for export	  
								TXT_DESC: InputField_IP_DESC.getValue(),
								//Status
								STATUS: "Requested",
								//Trigger
								TRIGGER: Dropdown_IP_TRIGGER.getSelectedKey(),
								//Profit Center
								PROFIT_CTR: Dropdown_IP_PC.getSelectedKey(),
								//CC
								REC_COSTCENTER: Dropdown_IP_CC.getSelectedKey(),
								RES_COSTCENTER: Dropdown_IP_RESCC.getSelectedKey(),
								//Project Type
								P_TYPE: rbgCAPEX.getSelectedKey(),
								//Program
								COMP_CODE: IPCompCode,
								//Reason
								INV_REASON: InputField_IP_REASON.getValue(),
								//Completion Date
								PROJECT_ENDDATE: InputField_IP_DATE.getValue() + Dropdown_IP_DC.getSelectedKey(),
								//MR to
								MRTO: inputIPMRT.getValue(),
								//MR from
								MRFROM: InputField_IP_MRF.getValue(),
								//PGPWBS
								PGPWBS: ddPGPWBS.getSelectedKey(),
								//Article Code
								MATERIAL: inputIP12NC.getValue(),
								//Project Profile
								PPROFILE: rbgIPprofile.getSelectedKey(),
								//SECTOR
								ZX_FISEC: Dropdown_IP_SECTOR.getSelectedKey(),
								ZX_FISECREC: Dropdown_IP_RECSECTOR.getSelectedKey(),
								//Sector Specific
								SECTORSC: ddIPSSC.getSelectedKey(),
								SECTORSC2: ddIPSSC.getSelectedKey(),
								//User ID
								RQUSER_ID: lblIPUSER.getPlainText(),
								//Date
								PROJECT_CREATEDATE: DateCreate,
								//Planned Transfer date
								PROJECT_TRANSDATE: InputField_IP_PTDYEAR.getValue() + Dropdown_IP_PTD.getSelectedKey(),
								//Start Date
								PROJECT_STARTDATE: "190001",
								//Source System
								SOURSYSTEM: "S1",
								//Useful Life
								USEFULL: ddUseful.getSelectedKey(),
								//Inv Account
								INVACC: InvAcc,
								//Depreciation Account	  
								DEPACC: DepAcc,
								//Program ID
								PROGRAM: ProgramID,
								//Asset Class
								ASSET_CLAS: ddIPAsset.getSelectedKey().substr(0, 4),
								//Balance Off-Sheet
								BS_OFFSET: "F_FBS18",
								//Business Line
								BUS_LINE: BusLine,
								//Supplier
								SUPPLIER: "N.A.",
								//Location
								LOCATION: "#",
								//Quantity	  
								QUANTT: inputQuantity.getValue(),
								//URL	  
								URLINK: inputLink.getValue(),
								//URL	  
								DEPOFF: inputIPLeadTime.getValue(),
								DEPOPT: ddDepOption.getSelectedText(),
								CC_VALIDATION: Dropdown_IP_CC.getSelectedKey() + "," + Dropdown_IP_RESCC.getSelectedKey(),

							}
						});
						console.log(result2);
						////Create member
						var result2 = CAPEX.createMembers("Investment", IPMember);
						if (result2) {
							//Application.refreshData([CapExTable.getDataSource(),]);
							Application.showMessage(ApplicationMessageType.Success, "Investment Proposal Successfully Created");
							tblIPPlan.getDataSource().setDimensionFilter("Investment", "[Investment].[PARENTID].&[" + newIPID + "]");
							var FilterPC = Dropdown_IP_PC.getSelectedKey();
							var FilterCC = Dropdown_IP_RESCC.getSelectedKey();
							console.log(FilterPC);
							tblIPPlan.getDataSource().setDimensionFilter("ProfitCenter", "[ProfitCenter].[H1].&[" + FilterPC + "]");
							tblIPPlan.getDataSource().setDimensionFilter("CostCenter", "[CostCenter].[H_COSTCENTER].&[" + FilterCC + "]");
							tblIPPlan.getDataSource().setDimensionFilter("Program", "[Program].[PARENTH1].&[" + ProgramID + "]");
							//		IP_WBS = ({id: newIPID, description: InputField_IP_DESC.getValue(),hierarchies: {PARENTH1: {parentId: "TOTAL"}}});
							//		CAPEX.updateMembers("WBS_Elements", IP_WBS);
							Popup_IP.close();
							panIPMandatory.setVisible(true);
							panIPOptional.setVisible(false);
							Popup_IP.setButtonVisible("bttnAdd", false);
							Popup_IP.setButtonVisible("bttnPrev", false);
							Popup_IP.setButtonVisible("bttnNext", true);
							Popup_IP_PLAN.open();
							submitchecker = false;
							clickcheck = false;





							//finally Close popup
							//Empty the text box and labels and dropdowns
							lblIPID.applyText("<auto ID>");
							lblIPDATECREATE.applyText("<auto ID>");
							InputField_IP_DESC.setValue("");
							inputIPMRT.setValue("");
							InputField_IP_MRF.setValue("");
							InputField_IP_DATE.setValue("");
							InputField_IP_REASON.setValue("");
							inputLink.setValue("");
							inputQuantity.setValue("");
							Dropdown_IP_CC.removeAllItems();
							//	  Dropdown_IP_COMPCODE.removeAllItems();
							Dropdown_IP_PROGRAM.removeAllItems();
							Dropdown_IP_PC.removeAllItems();
							Dropdown_IP_SECTOR.setSelectedKey("#");
							Dropdown_IP_RESCC.removeAllItems();
							Dropdown_IP_RECSECTOR.setSelectedKey("#");
							inputIPLeadTime.setValue("");
							rbgIPprofile.setSelectedKey("Off-the-Shelf (Statistical)");
							ddDepOption.setSelectedKey("Cash-out timing");
							InputField_IP_PTDYEAR.setValue("");
							ddIPSSC.setSelectedKey("");
							inputIPMRT.setValue("");
							inputIP12NC.setValue("");
							inputQuantity.setValue("");
							inputLink.setValue("");
							ddPGPWBS.setSelectedKey("NA");
							rbgCAPEX.setSelectedKey("CAPEX");
							ddRequest.setSelectedKey("");

						}
						else {
							Application.showMessage(ApplicationMessageType.Error, "Failed to Insert Investment Proposal");
						}




					}

					else {
						Application.showMessage(ApplicationMessageType.Error, "One of the inputfields exceeds the limit of 127 characters, please check this in order to advance");
					}
				}
				else {
					Application.showMessage(ApplicationMessageType.Error, "Input is not valid, please check and try again");
				}
			}
			else {
				Application.showMessage(ApplicationMessageType.Error, "Some required fields have not been filled out properly, please check and try again");
			}
		}
		else {
			Application.showMessage(ApplicationMessageType.Error, "Some required fields have not been filled in properly, please check and try again");
		}
	}


	else { Application.showMessage(ApplicationMessageType.Error, "The input years are invalid, please try again."); }

}


if (buttonId === "bttnClose") {
	Popup_IP.close();
	panIPMandatory.setVisible(true);
	panIPOptional.setVisible(false);
	Popup_IP.setButtonVisible("bttnAdd", false);
	Popup_IP.setButtonVisible("bttnPrev", false);
	Popup_IP.setButtonVisible("bttnNext", true);

}

Application.refreshData();
