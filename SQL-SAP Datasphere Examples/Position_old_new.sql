SELECT
    t1."position",
    t1."userId",
    t1."startDate",
    t2."endDate_Last",
    t1."pre_user",
    CASE
        WHEN t1."pre_user" IS NULL THEN 'New'
        ELSE 'Replacement'
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
                    "DOE_I_EMPJOB"
                WHERE
                    "emplStatus" = '209973'
                ORDER BY
                    "startDate" ASC
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
            "DOE_I_EMPJOB"
        WHERE
            "emplStatus" = '209973'
        GROUP BY
            "position",
            "userId"
    ) AS t2 ON t1."position" = t2."position"
    AND t1."userId" = t2."userId"