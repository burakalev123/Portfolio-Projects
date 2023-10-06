SELECT 
    "code",
	"effectiveStartDate",
	"vacant",
	LAG("vacant") OVER (PARTITION BY "code" ORDER BY "effectiveStartDate") AS "tobehıred",
	TO_DATE(CASE WHEN ("vacant" = 'true' AND LAG("vacant") OVER (PARTITION BY "code" ORDER BY "effectiveStartDate") = 'false') 
	                OR ("vacant" = 'true' AND LAG("vacant") OVER (PARTITION BY "code" ORDER BY "effectiveStartDate") IS NULL) 
	                THEN "effectiveStartDate" 
	        END) AS date_tobehired
FROM "DOE_I_POSITION" 
WHERE "code" = '70034321'