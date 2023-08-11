SELECT
    DISTINCT t1."User_ID",
    t2."Job_Family"
FROM
    "1TR_AUTH_FCT_BUD_VIEW" AS t1
    INNER JOIN "2VR_AUTH_FUNCTION_02" AS t2 ON (
        t1."Job_Family" = t2."Job_Family"
        OR t1."Job_Family" = '*'
    )
    AND t2."Job_Family" IS NOT NULL
    AND t1."Function" = t2."Function"
ORDER BY
    t1."User_ID",
    t2."Job_Family"