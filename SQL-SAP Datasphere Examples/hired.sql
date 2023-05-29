SELECT DISTINCT hiredTab."userId",
       hiredTab."firstWorkingDay",
       hiredTab."signDate",
       to_Date(hiredTab."signDate_eom") AS startDate,
       hiredTab."position",
       IFNULL(empTab."terminationDate", '99991231') AS terminationDate,
       DIM_MONTH."date"
FROM "DOE_C_EMPLOYMENT" AS empTab
INNER JOIN (
--      combine the dates
    SELECT startInfoTab."userId",
           startInfoTab."position",
           startInfoTab."firstWorkingDay",
           startInfoTab."firstWorkingDay_eom",
           signDateTab."signDate",
           signDateTab."signDate_eom"
    FROM (
--              combine staffed period with firstWorkingDay information
        SELECT anaTab."userId",
               anaTab."position",
               anaTab."firstMonth",
               anaTab."lastMonth",
               firstDayTab."firstWorkingDay",
               firstDayTab."firstWorkingDay_eom"
        FROM (
--                      select the period where a position is staffed
            SELECT "userId",
                   "position",
                   min("date") AS firstMonth,
                   max("date") AS lastMonth
            FROM "DOE_ANA_HR_EC_V2"
            GROUP BY "userId", "position"
        ) AS anaTab
        LEFT JOIN (
--                      select the date when the employee starts working
            SELECT "code",
                   "firstWorkingDay",
                   "firstWorkingDay_eom"
            FROM (
                SELECT "code",
                       "effectiveStartDate" AS firstWorkingDay,
                       LAST_DAY(to_date("effectiveStartDate")) AS firstWorkingDay_eom,
                       "vacant",
                       LAG("vacant") OVER (PARTITION BY "code" ORDER BY "effectiveStartDate") AS pre_vac
                FROM "DOE_I_POSITION"
            )
            WHERE "vacant" = 'false' AND "pre_vac" = 'true'
        ) AS firstDayTab ON anaTab."position" = firstDayTab."code"
        WHERE anaTab."position" IS NOT NULL
          AND anaTab."userId" IS NOT NULL
          AND anaTab."firstMonth" <= firstDayTab."firstWorkingDay_eom"
          AND anaTab."lastMonth" >= firstDayTab."firstWorkingDay_eom"
    ) AS startInfoTab
    LEFT JOIN (
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
                   LAG("userId") OVER (PARTITION BY "position" ORDER BY "createdOn") AS pre_user
            FROM "DOE_I_EMPJOB"
        )
        WHERE "userId" <> "pre_user" OR "eventReason" IN ('RETLEAVE', 'TRANLATL', 'PROPNP', 'PROPWP', 'REHREH', 'HIRNEW', 'JOBCHG')
    ) AS signDateTab ON signDateTab."userId" = startInfoTab."userId" AND signDateTab."position" = startInfoTab."position"
) AS hiredTab ON empTab."userId" = hiredTab."userId"
FULL JOIN "DOE_C_DIMENSION_MONTH" AS DIM_MONTH ON DIM_MONTH."date" <= empTab."startDate" OR DIM_MONTH."date" >= empTab."startDate"
WHERE DIM_MONTH."date" < IFNULL(empTab."terminationDate", '99991231')
  AND DIM_MONTH."date" >= hiredTab."signDate_eom"
  AND DIM_MONTH."date" < hiredTab."firstWorkingDay_eom";
