//===========================================================
// function ToggleMeasures() : void
//===========================================================

var i =0;
var keysMeasures = chbFTEMeasures.getSelectedKeys();
var ds = tblFTE.getDataSource();

//console.log(ds.getMeasures());
console.log(ds.getDimensionFilters(Alias.MeasureDimension));

var Measures = ArrayUtils.create(Type.string);

	//Add Selected Measures
	for (i =0;i<keysMeasures.length;i++){
		Measures.push(keysMeasures[i]);
	}

var MyMeasures = cast(Type.MultipleFilterValue,{values:Measures,exclude:false});
ds.setDimensionFilter(Alias.MeasureDimension,MyMeasures);

//console.log(ds.getMeasures());
console.log(ds.getDimensionFilters(Alias.MeasureDimension));

ThisApp.SetTabsRefreshPaused(tsContent.getSelectedKey());