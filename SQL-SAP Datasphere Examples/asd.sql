SELECT
    IL_Calmonth."Last_Day" AS "date",
    t1."position",
    t1."userId",
    t1."startDate",
    t1."endDate",
    t2."endDate_Last" AS endDate_LastEmpJob,
    CASE
        WHEN t1."userId" = LEAD(t1."pre_user") OVER (
            ORDER BY
                t1."position",
                t1."startDate"
        ) THEN t1."endDate"
        ELSE t2."endDate_Last"
    END AS endDate_Last,
    t1."pre_user",
    LEAD(t1."pre_user") OVER (
        ORDER BY
            t1."position",
            t1."startDate"
    ) AS next_user,
    CASE
        WHEN t1."pre_user" IS NULL THEN 'New'
        ELSE 'Existing'
    END AS "status"
FROM
    (
        SELECT
            "position",
            "userId",
            "startDate",
            "endDate",
            "signDate",
            "signDate_eom",
            "pre_user"
        FROM
            (
                SELECT
                    "position",
                    "startDate",
                    "endDate",
                    "eventReason",
                    "createdOn" AS signDate,
                    LAST_DAY(to_date("createdOn")) AS signDate_eom,
                    "userId",
                    LAG("userId") OVER (
                        PARTITION BY "position"
                        ORDER BY
                            "startDate"
                    ) AS pre_user -- returns the predecessor (row before)
                FROM
                    "V_HR_IL_A_EmpJob"
                WHERE
                    "emplStatus" = '209973'
                    AND "startDate" != "endDate"
                ORDER BY
                    "startDate",
                    "endDate" ASC
            )
        WHERE
            "userId" <> "pre_user"
            OR "pre_user" IS NULL
        ORDER BY
            "startDate" ASC
    ) AS t1
    INNER JOIN (
        SELECT
            "position",
            "userId",
            MAX("endDate") AS "endDate_Last"
        FROM
            "V_HR_IL_A_EmpJob"
        WHERE
            "emplStatus" = '209973'
        GROUP BY
            "position",
            "userId"
    ) AS t2 ON t1."position" = t2."position"
    AND t1."userId" = t2."userId"
    INNER JOIN "V_SAP_IL_A_Calmonth" AS IL_Calmonth ON IL_Calmonth."Last_Day" >= t1."startDate"
    AND IL_Calmonth."Last_Day" <= LAST_DAY(t1."endDate")