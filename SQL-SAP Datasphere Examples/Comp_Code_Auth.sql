SELECT DISTINCT t1."User_ID",
    t2."/BIC/DSDAREA" as Area,
    t2."/BIC/DSDREGION" as Region
FROM "DOE_AUTH_SAC" AS t1
    LEFT JOIN "DOE_DIM_COMP_CODE" AS t2 ON (
        t1."Area" = t2."/BIC/DSDAREA"
        OR t1."Area" = '*'
    )
    AND t2."/BIC/DSDAREA" IS NOT NULL
ORDER BY t1."User_ID",
    t2."/BIC/DSDAREA"