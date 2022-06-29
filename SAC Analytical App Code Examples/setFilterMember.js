//function setFilterMember(Dimension: string, Member: string, Charts: Chart[], Tables: Table[]) :void
var i = 0;

//==============================================================
// Apply Dimension member as filter to the Table Widgets
//==============================================================

var ds = ArrayUtils.create(Type.DataSource);

//loop through Charts
for (i = 0; i < Charts.length; i++) {
    if (i === 0) {
        ds[i] = Charts[i].getDataSource();
        ds[i].setDimensionFilter(Dimension, Member);
    } else {
        ds[i] = Charts[i].getDataSource();
        ds[i].copyDimensionFilterFrom(ds[0], Dimension);
    }
}

//loop through Tables
for (i = 0; i < Tables.length; i++) {
    if (i === 0) {
        ds[i] = Tables[i].getDataSource();
        ds[i].setDimensionFilter(Dimension, Member);
    } else {
        ds[i] = Tables[i].getDataSource();
        ds[i].copyDimensionFilterFrom(ds[0], Dimension);
    }
}