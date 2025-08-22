// Initialize selection and index

var sel_B2B = drp_newBusiness_B2B_L5.getSelectedKey();
console.log("Selected B2B Level: " + sel_B2B);

drp_newBusiness_DummyArticleList.removeAllItems();

if (sel_B2B === "#") {
    // No Action if no B2B Level is selected
    console.log("No B2B Level selected, skipping article list population.");
} else {

    // Show busy indicator while loading articles
    console.log("Loading articles for B2B Level: " + sel_B2B);
    Application.showBusyIndicator("Loading...");

    var foundArticles = false;

    // Filter and populate customer dropdown based on responsible
    for (var i = 0; i < gv_ArticleList.length; i++) {
        var B2B_L5 = gv_ArticleList[i].properties["B2B_L5"];

        if (B2B_L5 === sel_B2B) {
            var ArticletId = gv_ArticleList[i].id;
            var ArticleDesc = gv_ArticleList[i].description;
            drp_newBusiness_DummyArticleList.addItem(ArticletId, ArticletId + " - " + ArticleDesc);
            foundArticles = true;
        }
    }

    if (!foundArticles) {
        // Show message if no articles are available
        Application.showMessage(ApplicationMessageType.Info, "No articles available for the selected B2B Level.");
    } else {
        // Show success message if articles are populated
        Application.showMessage(ApplicationMessageType.Success, "Article list has been populated for the selected B2B Level.");
    }
    Application.hideBusyIndicator();
}
