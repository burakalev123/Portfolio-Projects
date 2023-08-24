SELECT DISTINCT
t_emp."employmentType",
	t_emp."name_EmploymentType"
FROM "EXP_HR_PCP_MD_EMPLOYEE" AS t_emp
	LEFT JOIN "DOE_DIM_COMP_CODE" AS t_entity ON t_emp."Legal_Entity" = t_entity."COMP_CODE"
WHERE t_entity."/BIC/DSDREGION" = 'TIP'
