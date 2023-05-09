SELECT DISTINCT
    t1."User_ID",
    t2."COMP_CODE" as Comp_Code,
    t2."COUNTRY" as Country,
    t2."/BIC/DSDAREA" as Area,
    t2."/BIC/DSDREGION" as Region
FROM "DOE_AUTH_SAC" AS t1
    LEFT JOIN "DOE_DIM_COMP_CODE" AS t2
    ON (t1."Company_Code" = t2."COMP_CODE"
        OR t1."Company_Code" = '*')
        AND t2."COMP_CODE" IS NOT NULL
ORDER BY t1."User_ID",
        t2."COMP_CODE"