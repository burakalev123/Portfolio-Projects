SELECT
    DISTINCT "pos_list"."Position" as "ID",
    "pos_detail"."externalName_defaultValue" as "Description",
    --    "pos_list"."lastModifiedDate",
    --    "pos_list"."effectiveStartDate",
    --    "pos_list"."effectiveEndDate",
    (
        CASE
            WHEN "pos_detail"."cust_jobType" = 'yesNo_Yes' THEN 'Yes'
            WHEN "pos_detail"."cust_jobType" = 'yesNo_No' THEN 'No'
            ELSE ''
        END
    ) as T_001_SEASONAL,
    (
        CASE
            WHEN "pos_detail"."cust_tempPosition" = 'true' THEN 'Yes'
            WHEN "pos_detail"."cust_tempPosition" = 'false' THEN 'No'
            ELSE ''
        END
    ) as T_001_TEMPORARY,
    (
        CASE
            WHEN "pos_detail"."vacant" = 'true' THEN 'Yes'
            WHEN "pos_detail"."vacant" = 'false' THEN 'No'
            ELSE ''
        END
    ) as T_001_INHIRING,
    --    "pos_detail"."jobCode",
    --    "jobProfile"."name_defaultValue",
    CONCAT(
        CASE
            WHEN LENGTH("jobProfile"."name_defaultValue") > 0 THEN CONCAT(
                "jobProfile"."name_defaultValue",
                CASE
                    WHEN LENGTH("pos_detail"."jobCode") > 0 THEN ' '
                    ELSE ''
                END
            )
            ELSE ''
        END,
        CASE
            WHEN LENGTH("pos_detail"."jobCode") > 0 THEN CONCAT(CONCAT('(', "pos_detail"."jobCode"), ')')
            ELSE ''
        END
    ) as T_001_JOBPROFILE,
    CONCAT(
        case
            when LENGTH("genericProfile"."externalName") > 0 then CONCAT(
                "genericProfile"."externalName",
                case
                    when LENGTH("pos_detail"."cust_genericprofile") > 0 then ' '
                    else ''
                end
            )
            else ''
        end,
        case
            when LENGTH("pos_detail"."cust_genericprofile") > 0 then CONCAT(
                CONCAT('(', "pos_detail"."cust_genericprofile"),
                ')'
            )
            else ''
        end
    ) as T_001_GENERICPROFILE,
    CONCAT(
        CASE
            WHEN LENGTH("jobSubFamily"."externalName") > 0 THEN CONCAT(
                "jobSubFamily"."externalName",
                CASE
                    WHEN LENGTH("pos_detail"."cust_jobSubFamily") > 0 THEN ' '
                    ELSE ''
                END
            )
            ELSE ''
        END,
        CASE
            WHEN LENGTH("pos_detail"."cust_jobSubFamily") > 0 THEN CONCAT(
                CONCAT('(', "pos_detail"."cust_jobSubFamily"),
                ')'
            )
            ELSE ''
        END
    ) as T_JOBSUBFAMILY,
    CONCAT(
        CASE
            WHEN LENGTH("jobFamily"."description_defaultValue") > 0 THEN CONCAT(
                "jobFamily"."description_defaultValue",
                CASE
                    WHEN LENGTH("pos_detail"."cust_jobFamily") > 0 THEN ' '
                    ELSE ''
                END
            )
            ELSE ''
        END,
        CASE
            WHEN LENGTH("pos_detail"."cust_jobFamily") > 0 THEN CONCAT(CONCAT('(', "pos_detail"."cust_jobFamily"), ')')
            ELSE ''
        END
    ) as T_001_JOBFAMILY,
    CONCAT(
        CASE
            WHEN LENGTH("funct_txt"."func_label") > 0 THEN CONCAT(
                "funct_txt"."func_label",
                CASE
                    WHEN LENGTH("jobFamily"."jobFunctionType") > 0 THEN ' '
                    ELSE ''
                END
            )
            ELSE ''
        END,
        CASE
            WHEN LENGTH("jobFamily"."jobFunctionType") > 0 THEN CONCAT(CONCAT('(', "jobFamily"."jobFunctionType"), ')')
            ELSE ''
        END
    ) AS T_JOBFAMILYTYPE,
    "pos_detail"."company" AS T_001_LEGALENTITY,
    "pos_detail"."costCenter" AS T_COSTCENTER,
    --	"pos_detail"."department",
    --	"department_txt"."name_defaultValue",
    CONCAT(
        CASE
            WHEN LENGTH("department_txt"."name_defaultValue") > 0 THEN CONCAT(
                "department_txt"."name_defaultValue",
                CASE
                    WHEN LENGTH("department_txt"."name_defaultValue") > 0 THEN ' '
                    ELSE ''
                END
            )
            ELSE ''
        END,
        CASE
            WHEN LENGTH("pos_detail"."department") > 0 THEN CONCAT(CONCAT('(', "pos_detail"."department"), ')')
            ELSE ''
        END
    ) as T_001_Department,
    CONCAT(
        case
            when LENGTH("parentPositionCode"."externalName_defaultValue") > 0 then CONCAT(
                "parentPositionCode"."externalName_defaultValue",
                ' '
            )
            else ''
        end,
        CONCAT(
            CONCAT('(', "pos_detail"."cust_parentPositionCode"),
            ')'
        )
    ) as T_001_HIGHERLEVELPOSITION
FROM
    "View_Position_test2" as "pos_list"
    LEFT JOIN "V_HR_HL_Position" as "pos_detail" on "pos_list"."Position" = "pos_detail"."code"
    AND "pos_list"."effectiveStartDate" = "pos_detail"."effectiveStartDate"
    AND "pos_list"."effectiveEndDate" = "pos_detail"."effectiveEndDate"
    AND "pos_list"."lastModifiedDate" = "pos_detail"."lastModifiedDate"
    LEFT JOIN "V_HR_HL_Department_SQ" AS "department_txt" on "pos_detail"."department" = "department_txt"."externalCode"
    LEFT JOIN "V_HR_HL_JobCode" AS "jobProfile" on "pos_detail"."jobCode" = "jobProfile"."externalCode"
    AND "jobProfile"."startDate" <= CURRENT_DATE
    AND "jobProfile"."endDate" > CURRENT_DATE
    LEFT JOIN "V_HR_HL_genericProfile" AS "genericProfile" on "pos_detail"."cust_genericprofile" = "genericProfile"."externalCode"
    AND "genericProfile"."effectiveStartDate" <= CURRENT_DATE
    AND "genericProfile"."mdfSystemEffectiveEndDate" > CURRENT_DATE
    LEFT JOIN "V_HR_HL_JobSubFamily" AS "jobSubFamily" on "pos_detail"."cust_jobSubFamily" = "jobSubFamily"."externalCode"
    AND "jobSubFamily"."effectiveStartDate" <= CURRENT_DATE
    AND "jobSubFamily"."mdfSystemEffectiveEndDate" > CURRENT_DATE
    LEFT JOIN "V_HR_HL_JobFunction" AS "jobFamily" on "pos_detail"."cust_jobFamily" = "jobFamily"."externalCode"
    AND "jobFamily"."startDate" <= CURRENT_DATE
    AND "jobFamily"."endDate" > CURRENT_DATE
    LEFT JOIN (
        SELECT
            DISTINCT "jobFamily"."externalCode" as "jobFamilyCode",
            "jobFamily"."startDate",
            "jobFamily"."endDate",
            "jobFamily"."status",
            "function"."label" as "func_label"
        FROM
            "V_HR_HL_JobFunction" AS "jobFamily"
            LEFT JOIN "DOE_TXT_PLV_DL_jobFamilyCluster" AS "function" on "jobFamily"."jobFunctionType" = "function"."externalCode"
            AND "function"."PickListV2_effectiveStartDate" <= CURRENT_DATE
            AND "function"."PickListV2_effectiveEndDate" > CURRENT_DATE
            AND "function"."lang" = 'en'
        WHERE
            "jobFamily"."startDate" <= CURRENT_DATE
            AND "jobFamily"."endDate" > CURRENT_DATE
    ) as "funct_txt" on "pos_detail"."cust_jobFamily" = "funct_txt"."jobFamilyCode"
    LEFT JOIN "V_HR_HL_Position" as "parentPositionCode" on "parentPositionCode"."code" = "pos_detail"."cust_parentPositionCode"
    AND "parentPositionCode"."effectiveStartDate" <= CURRENT_DATE
    AND "parentPositionCode"."effectiveEndDate" > CURRENT_DATE