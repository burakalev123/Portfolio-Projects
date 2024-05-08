if (buttonId === 'OK') {
    Application.showBusyIndicator('Please wait.');

    //Retrieve current year from system 
    var currentYear = new Date().getFullYear();
    var year = currentYear.toString();

    var numberOfMonthsActual = Slider_1.getValue();
    var monthsActual = ArrayUtils.create(Type.string);
    var monthsForecast = ArrayUtils.create(Type.string);

    for (var monthInt = 1; monthInt <= 12; monthInt++) {
        var monthString = '';
        if (monthInt < 10) {
            //Leading zero
            monthString = '0';
        }
        monthString = monthString + ConvertUtils.numberToString(monthInt);
        // Example: "[Date].[YQM].&[202201]"
        var selection = "[Date].[YQM].&[" + year + monthString + "]";

        if (monthInt <= numberOfMonthsActual) {
            monthsActual.push(selection);
        } else {
            monthsForecast.push(selection);
        }
    }
    console.log(monthsActual);

    DataAction_Copy_Actual_to_Forecast.setParameterValue("ActualMonths", monthsActual);

    var var_DataAction = DataAction_Copy_Actual_to_Forecast.execute();

    if (var_DataAction.status === DataActionExecutionResponseStatus.Success) {
        Application.showMessage(ApplicationMessageType.Success, 'Selected Actual Months have been copied to Forecast.');
        MultiAction_DataLock_Actual.setParameterValue("param_lockDate", monthsActual);

        var var_MultiAction = MultiAction_DataLock_Actual.execute();

        if (var_MultiAction.status === MultiActionExecutionResponseStatus.Success) {
            Application.showMessage(ApplicationMessageType.Success, 'Selected Actual Months have been locked.');
        } else {
            Application.showMessage(ApplicationMessageType.Error, 'Error. during Data Lock action. Please report this issue to the development team');
        }
    } else {
        Application.showMessage(ApplicationMessageType.Error, 'Error during Data Action action. Please report this issue to the development team');
    }



    Application.hideBusyIndicator();
    this.close();
} else {
    this.close();
}

