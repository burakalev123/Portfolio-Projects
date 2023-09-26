SELECT
    DIM_MONTH."Last_Day" as "date",
    EmpPayCompRecurring."userId",
    EmpPayCompRecurring."payComponent",
    EmpPayCompRecurring."startDate",
    EmpPayCompRecurring."seqNumber",
    EmpPayCompRecurring."calculatedAmount",
    EmpPayCompRecurring."currencyCode",
    EmpPayCompRecurring."customString1",
    EmpPayCompRecurring."endDate",
    EmpPayCompRecurring."frequency",
    EmpPayCompRecurring."notes",
    EmpPayCompRecurring."paycompvalue",
    Frequency."annualizationFactor",
    PayComponent."basePayComponentGroup",
    PayComponent."canOverride",
    PayComponent."displayOnSelfService",
    PayComponent."frequencyCode",
    PayComponent."isEarning",
    PayComponent."isEndDatedPayment",
    PayComponent."maxFractionDigits",
    PayComponent."payComponentType",
    PayComponent."payComponentValue",
    PayComponent."recurring",
    PayComponent."selfServiceDescription",
    PayComponent."target",
    PayComponent."taxTreatment",
    PayComponent."usedForCompPlanning",
    (
        EmpPayCompRecurring."paycompvalue" * Frequency."annualizationFactor"
    ) AS "calculatedAnnualAmount",
    -- Start of Change
    -- Developer: Christian Frei
    -- Date: 30.09.2022
    -- Comment: Implementation of a work-around for categorization of Pay Components
    --          Categorization via the mapping-table, which is uploaded via an CSV file. (CSV_PayComponentsType)
    --
    -- Developer: Christian Frei
    -- Date: 02.11.2022
    -- Comment: Adjustment of the wage calcuation. In the case of the frequency 'HOURLY',
    --          the paycompvalue has to be multiplied by the Actual/ Contract Working Hours [customDouble1].
    --          Reason: In this case, the paycomp value (= Amount / Hour) must be extrapolated to a weekly value (= Amount / Week).
    --          This result will be multiplied by the annualizationFactor (= 52 weeks).
    ----------------------------------------------------------------------------------------------------------------------------------------
    (
        CASE
            WHEN CSV_PayComponentsType."payComponentType_CSV" = 'Base Salary' THEN CASE
                WHEN EmpPayCompRecurring."frequency" = 'M125'
                OR EmpPayCompRecurring."frequency" = 'M13'
                OR EmpPayCompRecurring."frequency" = 'M1333'
                OR EmpPayCompRecurring."frequency" = 'M14'
                OR EmpPayCompRecurring."frequency" = 'M1296'
                OR EmpPayCompRecurring."frequency" = 'M15' THEN EmpPayCompRecurring."paycompvalue" * 12
                WHEN EmpPayCompRecurring."frequency" = 'HOURLY' THEN EmpPayCompRecurring."paycompvalue" * EMPJOB."customDouble1" * Frequency."annualizationFactor"
                ELSE EmpPayCompRecurring."paycompvalue" * Frequency."annualizationFactor"
            END
            ELSE TO_DOUBLE(0.00)
        END
    ) AS "annualBaseSalary",
    ----------------------------------------------------------------------------------------------------------------------------------------
    (
        CASE
            WHEN CSV_PayComponentsType."payComponentType_CSV" = 'Base Salary' THEN CASE
                WHEN EmpPayCompRecurring."frequency" = 'M125'
                OR EmpPayCompRecurring."frequency" = 'M13'
                OR EmpPayCompRecurring."frequency" = 'M1333'
                OR EmpPayCompRecurring."frequency" = 'M14'
                OR EmpPayCompRecurring."frequency" = 'M1296'
                OR EmpPayCompRecurring."frequency" = 'M15' THEN EmpPayCompRecurring."paycompvalue" * (Frequency."annualizationFactor" - 12)
                ELSE TO_DOUBLE(0.00)
            END
            ELSE TO_DOUBLE(0.00)
        END
    ) AS "annual13salary",
    ----------------------------------------------------------------------------------------------------------------------------------------            
    (
        CASE
            WHEN CSV_PayComponentsType."payComponentType_CSV" = 'Allowance' THEN -- Temporary deactivated.
            -- Simon.Hertling@doehler.com, 12.10.2022
            -- Content: würdest Du bitte die Allowances deaktivieren im Data Transfer? Wir haben intern abgestimmt, dass wir die Allowances EC Daten dieses Jahr rein über den Config Screen adressieren.
            -- Original Code:
            -- EmpPayCompRecurring."paycompvalue" * Frequency."annualizationFactor"
            TO_DOUBLE(0.00)
            ELSE TO_DOUBLE(0.00)
        END
    ) AS "otherAllowance",
    ----------------------------------------------------------------------------------------------------------------------------------------        
    (
        CASE
            WHEN CSV_PayComponentsType."payComponentType_CSV" = 'Bonus' THEN CASE
                WHEN EmpPayCompRecurring."frequency" != 'HOURLY' THEN EmpPayCompRecurring."paycompvalue" * Frequency."annualizationFactor"
                ELSE EmpPayCompRecurring."paycompvalue" * EMPJOB."customDouble1" * Frequency."annualizationFactor"
            END
            ELSE TO_DOUBLE(0.00)
        END
    ) AS "targetBonusAmount",
    ----------------------------------------------------------------------------------------------------------------------------------------        
    -- End of Change
    1 AS "numOfPayCompRecurring",
    CSV_PayComponentsType."payComponentType_CSV"
FROM
    "DOE_I_EmpPayCompRecurring" AS EmpPayCompRecurring
    INNER JOIN "DOE_C_DIMENSION_MONTH" AS DIM_MONTH ON DIM_MONTH."Last_Day" >= EmpPayCompRecurring."startDate"
    and DIM_MONTH."Last_Day" <= LAST_DAY(EmpPayCompRecurring."endDate")
    LEFT JOIN "DOE_I_FOFrequency" AS Frequency ON EmpPayCompRecurring."frequency" = Frequency."externalCode"
    LEFT JOIN "DOE_C_FOPAYCOMPONENT" AS PayComponent ON PayComponent."date" = DIM_MONTH."Last_Day"
    AND EmpPayCompRecurring."payComponent" = PayComponent."externalCode"
    LEFT JOIN "DOE_C_CSV_Pay_Components_Type" AS CSV_PayComponentsType ON EmpPayCompRecurring."payComponent" = CSV_PayComponentsType."externalCode_CSV"
    LEFT JOIN "DOE_C_EMPJOB" AS EMPJOB ON EMPJOB.date = DIM_MONTH."Last_Day"
    AND EMPJOB.userId = EmpPayCompRecurring."userId"