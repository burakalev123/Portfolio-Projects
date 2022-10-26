
	popPublish.close();
	Application.showBusyIndicator();

	var xyz = CALC_ALLOC_KEY_REV_Publish.execute();
	Application.refreshData();
	Application.hideBusyIndicator();
	
	bPublish = false;
	
	if(xyz){
		Application.showMessage(
			ApplicationMessageType.Success,
			"Data Action Succesful! Revenue % has been calculated and published."
		);
	} else {
		Application.showMessage(
			ApplicationMessageType.Error, "Data Action failed, please try again or contact IT support."
		);
	}
