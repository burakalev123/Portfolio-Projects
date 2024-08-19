last_date =
SELECT
    MAX("PickListV2_effectiveStartDate") AS "startDate",
    "optionId"
FROM
    "V_HR_HL_PickListValueV2"
GROUP BY
    "optionId";

RETURN
SELECT
    "Union"."optionId",
    "Union"."language" AS "language",
    "Union"."label" AS "label",
    "Union"."startDate"
FROM
    (
        SELECT
            "PickListTable_DE"."PickListV2_effectiveStartDate" AS "startDate",
            "PickListTable_DE"."label_de_DE" AS "label",
            "PickListTable_DE"."optionId",
            'D' AS "language"
        FROM
            "V_HR_HL_PickListValueV2" AS "PickListTable_DE"
        WHERE
            "PickListTable_DE"."PickListV2_id" = 'scm_actions'
            AND "PickListTable_DE"."status" = 'A'
        UNION
        ALL
        SELECT
            "PickListTable_EN"."PickListV2_effectiveStartDate" AS "startDate",
            "PickListTable_EN"."label_defaultValue" AS "label",
            "PickListTable_EN"."optionId",
            'E' AS "language"
        FROM
            "V_HR_HL_PickListValueV2" AS "PickListTable_EN"
        WHERE
            "PickListTable_EN"."PickListV2_id" = 'scm_actions'
            AND "PickListTable_EN"."status" = 'A'
    ) AS "Union"
    INNER JOIN :last_date AS "lastDateTable" ON "Union"."startDate" = "lastDateTable"."startDate"
    AND "Union"."optionId" = "lastDateTable"."optionId";