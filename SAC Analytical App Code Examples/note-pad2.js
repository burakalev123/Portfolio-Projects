switch (drp_valueType.getSelectedKey()) {
    case "10":
        ic_filterPanel_VType.getInputControlDataSource().setSelectedMembers("10");
        ic_filterPanel_Version.getInputControlDataSource().setSelectedMembers("public.Actual");
        ic_filterPanel_Scope.getInputControlDataSource().setSelectedMembers("DETAIL");
        break;
    case "20":
        ic_filterPanel_VType.getInputControlDataSource().setSelectedMembers("20");
        ic_filterPanel_Version.getInputControlDataSource().setSelectedMembers("public.Budget");
        ic_filterPanel_Scope.getInputControlDataSource().setSelectedMembers("DETAIL");
        break;
    case "31":
        ic_filterPanel_VType.getInputControlDataSource().setSelectedMembers("31");
        ic_filterPanel_Version.getInputControlDataSource().setSelectedMembers("public.Forecast");
        ic_filterPanel_Scope.getInputControlDataSource().setSelectedMembers("DETAIL");
        break;
    case "32":
        ic_filterPanel_VType.getInputControlDataSource().setSelectedMembers("32");
        ic_filterPanel_Version.getInputControlDataSource().setSelectedMembers("public.Forecast");
        ic_filterPanel_Scope.getInputControlDataSource().setSelectedMembers("DETAIL");
        break;
    case "demandFC":
        ic_filterPanel_VType.getInputControlDataSource().setSelectedMembers("#");
        ic_filterPanel_Version.getInputControlDataSource().setSelectedMembers("public.Demand_FC");
        ic_filterPanel_Scope.getInputControlDataSource().setSelectedMembers("DETAIL");
        break;
    case "dse":
        ic_filterPanel_VType.getInputControlDataSource().setSelectedMembers("#");
        ic_filterPanel_Version.getInputControlDataSource().setSelectedMembers("public.DSE");
        ic_filterPanel_Scope.getInputControlDataSource().setSelectedMembers("DETAIL");
        break;
}