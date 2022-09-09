Application.showBusyIndicator("Company Code has been selected");

dd_costcenter.removeAllItems();
dd_costcenter.addItem("all", "All");

var selected_compcode = dd_compcode.getSelectedKey();

Application.showBusyIndicator("Retrieving Cost Centers for " + selected_compcode);
dCostcenter = PLAN_MODEL.getMembers("COSTCENTER", { limit: 1000 });

for (var i = 0; i < dCostcenter.length; i++) {

    if (dCostcenter[i].properties.COMP_CODE === selected_compcode) {

        dd_costcenter.addItem(dCostcenter[i].id, dCostcenter[i].id + " " + "(" + dCostcenter[i].description + ")");
    }
}
dd_costcenter.setSelectedKey("all");
//Hide Indicator
Application.hideBusyIndicator();