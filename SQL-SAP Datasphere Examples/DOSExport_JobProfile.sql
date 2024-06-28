SELECT
    DISTINCT JOBCODE."externalCode" AS "ID",
    JOBCODE."name_defaultValue" AS "Name"
FROM
    "DOE_I_FOJOBCODE" AS JOBCODE
WHERE
    JOBCODE."startDate" <= TO_DATE(NOW())
    AND JOBCODE."endDate" >= TO_DATE(NOW())
    AND JOBCODE."status" = 'A'
GROUP BY
    JOBCODE."externalCode",
    JOBCODE."name_defaultValue"