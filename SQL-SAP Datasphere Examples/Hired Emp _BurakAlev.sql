SELECT Employee."userId",
    Employee."startDate",
    Employee."endDate",
    Position."code",
    Position."effectiveStartDate",
    Position."effectiveEndDate",
    MonthTable."Last_Day"    AS Date
FROM (
SELECT Position_Tab."code",
        Position_Tab."effectiveStartDate",
        Position_Tab."effectiveEndDate"
    FROM "DOE_I_POSITION" AS Position_Tab
    WHERE "vacant" = true
) as Position
    LEFT JOIN (
			SELECT  "userId",
                    "position",
                    "startDate",
                    "endDate"
            FROM "DOE_I_EMPJOB" Employee_Tab
            WHERE "emplStatus" = 209973
) AS Employee
    ON Position."code" = Employee."position"
        INNER JOIN "DOE_C_DIMENSION_MONTH" AS MonthTable
            ON MonthTable."Last_Day" >= Position."effectiveStartDate"
                AND MonthTable."Last_Day" <= Position."effectiveEndDate"
WHERE Employee."startDate" >= Position."effectiveEndDate"

