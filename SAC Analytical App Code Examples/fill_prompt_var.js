Table_1.getDataSource().setRefreshPaused(true);
var variables = Table_1.getDataSource().getVariables();
var variablevalue = Table_1.getDataSource().getVariableValues("VAR_DATE");
console.log(variables);
console.log(variablevalue);

var currentdate = new Date(Date.now());
console.log(currentdate);
var date_format = currentdate.toJSON().slice(0, 10);
console.log(date_format);

var mm = date_format.slice(5, 7);
var yyyy = date_format.slice(0, 4);

var var_date = yyyy + mm;
console.log(var_date);

Table_1.getDataSource().setVariableValue("VAR_DATE", var_date);
Table_1.getDataSource().openPromptDialog();
Table_1.getDataSource().setRefreshPaused(false);