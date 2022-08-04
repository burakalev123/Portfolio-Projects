DS_Selection_Canvas.setVisible(false);
Table.openSelectModelDialog();
Application.showBusyIndicator(Utils.getText("LoadingModel"));
Title = Utils.getText("GenericAnalysis");
Utils.onInit();
Application.hideBusyIndicator();