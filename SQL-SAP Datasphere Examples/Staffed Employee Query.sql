SELECT EmpJob."position" AS Position,
    Max(EmpJob."startDate") AS startDate,
    -------------------------------------------------
    MonthTable."Last_Day" AS Date,
    -------------------------------------------------
    'Yes' AS Staffed -------------------------------------------------
FROM "DOE_I_EMPJOB" AS EmpJob
    INNER JOIN "DOE_C_DIMENSION_MONTH" AS MonthTable ON MonthTable."Last_Day" >= EmpJob."startDate"
    AND MonthTable."Last_Day" <= EmpJob."endDate" -------------------------------------------------
WHERE (
        EmpJob."emplStatus" = 209973 -- Active
        OR EmpJob."emplStatus" = 209977 -- On Leave
    )
    AND EmpJob."userId" IS NOT NULL
    AND EmpJob."position" IS NOT NULL -------------------------------------------------
GROUP BY EmpJob."position",
    MonthTable."Last_Day"