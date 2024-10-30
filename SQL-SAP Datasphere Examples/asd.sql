SELECT DISTINCT
    TO_DATE(PLV."PickListV2_effectiveStartDate") AS "PickListV2_effectiveStartDate",
    TO_DATE(CAL_END_DATE."PickListV2_effectiveEndDate") AS "PickListV2_effectiveEndDate",
    PLV."PickListV2_id",
    PLV."externalCode",
    PLV."externalStandardizedCode",
    PLV."lValue",
    PLV."label_ar_SA",
    PLV."label_da_DK",
    PLV."label_de_DE",
    PLV."label_defaultValue",
    PLV."label_en_US",
    PLV."label_localized",
    PLV."label_nl_NL",
    PLV."label_pl_PL",
    PLV."label_pt_BR",
    PLV."label_tr_TR",
    PLV."label_zh_CN",
    PLV."legacyStatus",
    PLV."maxVal",
    PLV."mdfSystemRecordStatus",
    PLV."minVal",
    PLV."nonUniqueExternalCode",
    PLV."optValue",
    PLV."optionId",
    PLV."parentPickListValue",
    PLV."rValue",
    PLV."status"
FROM "T_HR_IL_PickListValueV2" AS PLV

    -- This join / nested SELECT statement calulates the missing end date.
    -- (SF does not provide an end date.)
    LEFT JOIN
    (
        (SELECT DISTINCT
        NESTED_PLV."PickListV2_effectiveStartDate" AS "PickListV2_effectiveStartDate",
        NESTED_PLV."PickListV2_id" AS "PickListV2_id",
        NESTED_PLV."externalCode" AS "externalCode",
        CASE WHEN TO_DATE(MIN(NESTED_PLV_TMP."PickListV2_effectiveStartDate")) IS NULL THEN
                TO_DATE('99991231', 'YYYYMMDD')
            ELSE
                TO_DATE(ADD_DAYS(MIN(NESTED_PLV_TMP."PickListV2_effectiveStartDate"), -1))
            END AS "PickListV2_effectiveEndDate"
    FROM "T_HR_IL_PickListValueV2" AS NESTED_PLV
        LEFT JOIN "T_HR_IL_PickListValueV2" AS NESTED_PLV_TMP ON
                    NESTED_PLV."PickListV2_id" = NESTED_PLV_TMP."PickListV2_id" AND
            NESTED_PLV."externalCode" = NESTED_PLV_TMP."externalCode" AND
            TO_DATE(NESTED_PLV."PickListV2_effectiveStartDate") < TO_DATE(NESTED_PLV_TMP."PickListV2_effectiveStartDate")
    GROUP BY
                    NESTED_PLV."PickListV2_id",
                    NESTED_PLV."PickListV2_effectiveStartDate",
                    NESTED_PLV."externalCode")
    ) AS CAL_END_DATE ON
    CAL_END_DATE."PickListV2_effectiveStartDate" = PLV."PickListV2_effectiveStartDate" AND
        CAL_END_DATE."PickListV2_id" = PLV."PickListV2_id" AND
        CAL_END_DATE."externalCode" = PLV."externalCode"
    
