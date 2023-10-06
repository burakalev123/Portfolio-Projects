Changes
=
(
SELECT
	"code",
	"effectiveStartDate",
	"vacant",
	LAG("vacant") OVER (PARTITION BY "code" ORDER BY "effectiveStartDate") AS "previous_to_be_hired"
FROM
	"DOE_I_POSITION"
);

FirstStartDateForTrue =
( SELECT
	"code",
	"effectiveStartDate",
	"vacant",
	CASE
    WHEN "vacant" = 'true' AND ("previous_to_be_hired" IS NULL OR "previous_to_be_hired" = 'false') THEN "effectiveStartDate"
    ELSE NULL
  END AS "FirstStartDateForTrue"
FROM
	:Changes);

RETURN
SELECT
	t1."code",
	t1."effectiveStartDate",
	t2."FirstStartDateForTrue"
FROM "DOE_I_POSITION" as t1
	LEFT JOIN :FirstStartDateForTrue  as t2 on t1."code" = t2."code"
		AND t1."effectiveStartDate" >= t2."FirstStartDateForTrue"
    ;
    
    