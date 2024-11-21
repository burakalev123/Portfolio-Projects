SELECT DISTINCT
    EmpJob_Months."calmonth",
	EmpJob_Months."date",
	EmpJob_Months."userId",
	EmpJob_Months."startDate" AS job_startDate, 
	
    //----- EmpJob Attributes -----//
	IL_EmpJob."endDate" AS job_endDate,
	IL_EmpJob."jobCode",
	IL_EmpJob."customString28",
	IL_EmpJob."customString9",
	IL_EmpJob."customString13",
	IL_EmpJob."customString29",
	IL_EmpJob."customString2",
	IL_EmpJob."customString3",
	IL_EmpJob."department",
	IL_EmpJob."coArea",
	IL_EmpJob."costCenter",
	IL_EmpJob."location",
	IL_EmpJob."company",
	IL_EmpJob."countryOfCompany",
	IL_EmpJob."customString15",
	IL_EmpJob."customString14",
	IL_EmpJob."timezone",
	IL_EmpJob."emplStatus",
	IL_EmpJob."employeeClass",
	IL_EmpJob."employmentType",
	IL_EmpJob."position",
	IL_EmpJob."customString10",
	IL_EmpJob."contractType",
	IL_EmpJob."contractEndDate",
	IL_EmpJob."temp_employee",
	IL_EmpJob."part_time_emp",
	IL_EmpJob."staffed",
	IL_EmpJob."customDouble1",
	IL_EmpJob."customDouble2",
	IL_EmpJob."customString4",
	IL_EmpJob."customString17",
	IL_EmpJob."managerId",
	IL_EmpJob."fte",
	IL_EmpJob."event",
	IL_EmpJob."eventReason",
	
	//----- EmpEmployment Attributes -----//
	IL_EmpEmployment."startDate" AS emp_startDate,
	IL_EmpEmployment."endDate" AS emp_endDate,
	
	//----- EmpEmploymentTermination Attributes -----//
	IL_EmpEmploymentTermination."endDate" AS termDate,
	(CASE WHEN LAST_DAY(IL_EmpEmploymentTermination."endDate") = EmpJob_Months."date" THEN 'Yes' ELSE 'No' END) AS terminated,
	
	//----- Potential Ratings -----//
	HL_Potential."label" AS label_PotRating,
	HL_Potential."rating" AS rating_Potential,
	
	//----- Potential Ratings -----//
	HL_Performance."label" AS label_PerfRating,
	HL_Performance."rating" AS rating_Performance
	
FROM "V_HR_AUX_EmpJob_byMonths" AS EmpJob_Months

    //----- EmpJob Attributes  -----//
    LEFT JOIN "V_HR_IL_A_EmpJob" AS IL_EmpJob ON 
        EmpJob_Months."startDate" = IL_EmpJob."startDate"
    AND EmpJob_Months."userId" = IL_EmpJob."userId"
    

    //----- for filtering already teminated employees. -----//
    INNER JOIN "V_HR_IL_A_EmpEmployment" AS IL_EmpEmployment ON
        EmpJob_Months."userId" = IL_EmpEmployment."userId"
    AND EmpJob_Months."startDate" >= IL_EmpEmployment."startDate"
    AND IL_EmpJob."endDate"<= IL_EmpEmployment."endDate"
    
    //----- Employment Termination -----//
    LEFT JOIN "V_HR_IL_A_EmpEmploymentTermination" AS IL_EmpEmploymentTermination ON
        EmpJob_Months."userId" = IL_EmpEmploymentTermination."userId"
        
    //----- Potential Ratings -----//
    LEFT JOIN "V_HR_HL_OverallPotential_byMonths" AS HL_Potential ON
        EmpJob_Months."userId" = HL_Potential."userId"
    AND EmpJob_Months."date" = HL_Potential."date"

    //----- Performance Ratings -----//
    LEFT JOIN "V_HR_HL_OverallPerformance_byMonths" AS HL_Performance ON
        EmpJob_Months."userId" = HL_Performance."userId"
    AND EmpJob_Months."date" = HL_Performance."date"
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    
    