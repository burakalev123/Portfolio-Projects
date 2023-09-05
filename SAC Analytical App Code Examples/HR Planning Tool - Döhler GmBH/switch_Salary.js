/**
This function is called when the switch changes its state, i.e. either switched off or switched on.
If it is switched on, more columns are shown in the table. Which columns are shown was defined in mockup.
If it is switched off, those defined columns are hidden from the table.
Technically, such a column is a property of the Position-dimension. Thus, the requested extra columns will be refered to as "property" in the inline comments.

Developer: Lea Possberg (External, Infomotion)
Date: 17.08.2022
*/

Application.showBusyIndicator();

//currently active properties of the dimension POSITION
var active_props_POS = tbl_Existing_Positions.getActiveDimensionProperties("PD_001_POSITION");

//the properties of the dimension POSITION that will be active after using this switch
var new_active_props_POS = ArrayUtils.create(Type.string);

//properties that will be either aditinally displayed or removed when using by this switch
var switch_props_POS = [
	"PD_001_POSITION.T_001_BONUSGROUP",
	"PD_001_POSITION.D_001_YRBASESALARY",
	"PD_001_POSITION.D_001_YRTARGETBONUS",
	"PD_001_POSITION.D_001_YRTOTALTARGETCASH"
];


if (this.isOn()){ //switch has changed its state to now ON
	//add new properties to the currently active properties
	new_active_props_POS = active_props_POS.concat(switch_props_POS);
	
} else { //switch has changed its state to now OFF
	//remove new properties from the currently active properties
	new_active_props_POS = lists.removeFrom(switch_props_POS, active_props_POS);
}


//set the new active properties visible
tbl_Existing_Positions.setActiveDimensionProperties("PD_001_POSITION", new_active_props_POS);

Application.hideBusyIndicator();

