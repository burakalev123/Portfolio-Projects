SELECT
    [Version],
    [Audit_ID] = CASE
        WHEN [typeofsales] IN ('FSN','FSL','FSE') THEN 'LOAD_INSTALL_FS' ELSE Audit_ID 
    END,
    [TypeofSales],
    [CustomerShipTo],
    [DocItemNumber],
    [ForecastID],
    [Material_CS],
    [MachineSubType],
    [Equipment],
    [ProfitCenter],
    [CompCode],
    [Account],
    [Period],
    [DateFrom],
    [DateTo],
    [Value],
    [CS_Code],
    [SystemLine],
    [FTE],
    [LHPHours]
FROM
    [SBP].[dbo].[tblStaging_Rows]
WHERE
    (
        Version = (
            SELECT
                Version
            FROM
                [SBP].[dbo].[tblStaging_Rows] AS tblStaging_Rows_2
            WHERE
                (
                    ID = (
                        SELECT
                            MAX(ID) AS Expr1
                        FROM
                            [SBP].[dbo].[tblStaging_Rows] AS tblStaging_Rows_1
                    )
                )
        )
    )
    AND [Value] IS NOT NULL
    AND [Period] >= convert(nvarchar(4), year(getdate())) + '.' + convert(nvarchar(2), format(month(getdate()), '00'))
ORDER BY
    [ForecastID]