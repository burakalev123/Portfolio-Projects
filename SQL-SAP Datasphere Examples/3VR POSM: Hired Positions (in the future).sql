
SELECT DISTINCT 
	DIM_MONTH."Last_Day" AS date,
    hiredTab."position",
    hiredTab."userId",
    to_Date(hiredTab."signDate") AS signDate,
	to_Date(hiredTab."signDate_eom") AS signDate_eom,
	hiredTab."firstWorkingDay",
	empTab."originalStartDate" AS originalStartDate,
	IFNULL(empTab."endDate", '99991231') AS terminationDate,
	(CASE WHEN empTab."originalStartDate" < hiredTab."firstWorkingDay" THEN 'Internal' ELSE 'External' END) AS int_ext
FROM "V_HR_IL_A_EmpEmployment" AS empTab
	INNER JOIN (
--      -------------------------------------------------------------------------------------------------------
--      combine the dates

		SELECT startInfoTab."userId",
			startInfoTab."position",
			startInfoTab."firstWorkingDay",
			startInfoTab."firstWorkingDay_eom",
			signDateTab."signDate",
			signDateTab."signDate_eom"
		FROM (
--              -------------------------------------------------------------------------------------------------------
--              combine staffed period with firstWorkingDay information

				SELECT anaTab."userId",
					anaTab."position",
					anaTab."firstMonth",
					anaTab."lastMonth",
					firstDayTab."firstWorkingDay",
					firstDayTab."firstWorkingDay_eom"
				FROM (
--                      -------------------------------------------------------------------------------------------------------
--                      select the period where a position is staffed

						SELECT "userId",
							"position",
							min("date") AS firstMonth,
							max("date") AS lastMonth
						FROM "V_HR_HL_EmpAttr"
						GROUP BY "userId",
							"position"
--                      -------------------------------------------------------------------------------------------------------

					) AS anaTab
					LEFT JOIN (
--                       -------------------------------------------------------------------------------------------------------
--                      select the date when the employee starts working

						SELECT "code",
							"firstWorkingDay",
							"firstWorkingDay_eom"
						FROM (
								SELECT "code",
									"effectiveStartDate" AS firstWorkingDay,
									LAST_DAY(to_date("effectiveStartDate")) AS firstWorkingDay_eom,
									"vacant",
									LAG("vacant") OVER (PARTITION BY "code" ORDER BY "effectiveStartDate") AS pre_vac -- returns the predecessor (row before)

								FROM "V_HR_IL_AT_Position"
							)
						WHERE "vacant" = 'false'
							AND "pre_vac" = 'true'
--                      -------------------------------------------------------------------------------------------------------

					) AS firstDayTab ON anaTab."position" = firstDayTab."code"
				WHERE anaTab."position" IS NOT NULL
					AND anaTab."userId" IS NOT NULL
					AND anaTab."firstMonth" <= firstDayTab."firstWorkingDay_eom"
					AND anaTab."lastMonth" >= firstDayTab."firstWorkingDay_eom"
--              -------------------------------------------------------------------------------------------------------

			) AS startInfoTab
			LEFT JOIN (
--              -------------------------------------------------------------------------------------------------------
--              select the date when a employee is assigned to a position

				SELECT "position",
					"userId",
					"signDate",
					"signDate_eom"
				FROM (
						SELECT "position",
							"startDate",
							"eventReason",
							to_date("createdOn") AS signDate,
							LAST_DAY(to_date("createdOn")) AS signDate_eom,
							"userId",
							LAG("userId") OVER (PARTITION BY "position" ORDER BY "createdOn") AS pre_user -- returns the predecessor (row before)

						FROM "V_HR_IL_A_EmpJob"
					)
				WHERE ("userId" <> "pre_user" OR "pre_user" IS NULL) AND "eventReason" in ('RETLEAVE', 'TRANLATL', 'PROPNP', 'PROPWP', 'REHREH', 'HIRNEW', 'JOBCHG')
--              -------------------------------------------------------------------------------------------------------

			) AS signDateTab ON signDateTab."userId" = startInfoTab."userId" AND signDateTab."position" = startInfoTab."position"
--      -------------------------------------------------------------------------------------------------------

	) AS hiredTab ON empTab."userId" = hiredTab."userId"
	FULL JOIN "V_SAP_IL_A_Calmonth" AS DIM_MONTH ON DIM_MONTH."Last_Day" <= empTab."startDate" OR DIM_MONTH."Last_Day" >= empTab."startDate"
WHERE DIM_MONTH."Last_Day" < IFNULL(empTab."endDate", '99991231')
	AND DIM_MONTH."Last_Day" >= hiredTab."signDate_eom"
	AND DIM_MONTH."Last_Day" < hiredTab."firstWorkingDay_eom"
ORDER BY signDate
-- -------------------------------------------------------------------------------------------------------
































