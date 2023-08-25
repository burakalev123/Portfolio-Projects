SELECT
    DISTINCT t1."Mapping_New_Job_Profile_SAC" AS ID,
    RTRIM(SUBSTR_BEFORE(t1."T_001_JOBPROFILE", '('), ' ') || ' - ' || RTRIM(SUBSTR_BEFORE(t1."T_001_LEADATTR2", '('), ' ') AS description,
    t1."T_001_JOBPROFILE" AS Job_Profile,
    t1."T_001_LEADATTR2" AS Leading_Attribute,
    CONCAT(
        CASE
            WHEN LENGTH(t2."externalName") > 0 THEN CONCAT(
                t2."externalName",
                CASE
                    WHEN LENGTH(t2."cust_subFamily") > 0 THEN ' '
                    ELSE ''
                END
            )
            ELSE ''
        END,
        CASE
            WHEN LENGTH(t2."cust_subFamily") > 0 THEN CONCAT(CONCAT('(', t2."cust_subFamily"), ')')
            ELSE ''
        END
    ) AS Job_Sub_Family,
    t1."T_001_JOBFAMILY" AS Job_Family,
    SUBSTR_AFTER(
        SUBSTR_BEFORE(RIGHT(t1."T_001_JOBPROFILE", 10), ')'),
        '('
    ) AS Job_Profile_ID,
    SUBSTR_AFTER(
        SUBSTR_BEFORE(RIGHT(t1."T_001_LEADATTR2", 10), ')'),
        '('
    ) AS Leading_Attribute_ID,
    t2."cust_subFamily",
    t2."externalName"
FROM
    "EXP_HR_PCP_MD_POSITION" AS t1
    LEFT JOIN "2VR_POSM_JOB_PROFILE_SQ" AS t2 ON SUBSTR_AFTER(
        SUBSTR_BEFORE(RIGHT(t1."T_001_JOBPROFILE", 10), ')'),
        '('
    ) = t2."externalCode"