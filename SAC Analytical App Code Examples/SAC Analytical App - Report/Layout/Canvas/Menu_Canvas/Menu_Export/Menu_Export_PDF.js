Utils_Menu.close();
if (Switch_FullTable.isOn()) {
    ExportToPDF.setReportIncluded(true);
} else {
    ExportToPDF.setReportIncluded(false);
}
ExportToPDF.exportView();
Application.showMessage(ApplicationMessageType.Success, Utils.getText("PDFStarted"));