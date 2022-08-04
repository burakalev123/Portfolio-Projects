Utils_Menu.close();
//if (Switch_FullTable.isOn()) {
//	ExportToExcel.setReportIncluded(true);
//} else {
//	ExportToPDF.setReportIncluded(false);
//}
ExportToExcel.exportReport();
Application.showMessage(ApplicationMessageType.Success, Utils.getText("Excel export started"));