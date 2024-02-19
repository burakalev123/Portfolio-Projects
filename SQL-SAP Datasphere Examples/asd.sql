namespace "doehler"."dd"."hr";

@Schema: 'HR_ACQ' @Catalog.tableType: #COLUMN
/ / DDL definitions: entity DSP_HR_EC_LT_CoreWorkforce { "date": LocalDate NOT NULL;

"position": String(128) NOT NULL;

"userid": String(100) NOT NULL;

"employee": String(5000);

"job_function": String(128);

"cust_jobFamily": String(128);

"cust_jobSubFamily": String(128);

"job_profile": String(128);

"lead_attr": String(128);

"comp_code": String(128);

"co_area": String(128);

"costcenter": String(128);

"in_budget": String(128);

"seasonal_worker": String(128);

"temp_position": String(5);

"department": String(128);

"destination": String(128);

"corp_view_bydestination": String(128);

"loa_emp_pos": String(3);

"temp_employee": String(3);

"part_time_emp": String(10);

"staffed": String(3);

"hired": String(3);

"in_hiring": String(3);

"buildup_ytd": String(3);

"terminationDate": LocalDate;

"fte": Double;

};