/* SBP Field Projects Actuals */
    SELECT [Version], CASE WHEN ISNULL([TypeofSales], '') IN ('FSN', 'FSL', 'FSE') THEN 'LOAD_INSTALL_FS' ELSE Audit_ID END AS [Audit_ID]/*,[Audit_ID]*/ , [CustomerShipTo], [DocItemNumber], [ForecastID],
        [Material_CS], [MachineSubType], [Equipment], [ProfitCenter], [CompCode], [Account], [Period], [DateFrom], [DateTo], [Value], [CS_Code] AS 'CSProduct', [SystemLine]
    FROM [SBP].[dbo].[vwSAC_Staging]
    WHERE        [Value] IS NOT NULL AND [Period] < CONVERT(nvarchar(4), year(getdate())) + '.' + CONVERT(nvarchar(2), format(month(getdate()), '00')) AND [Audit_ID] = 'LOAD_FIELDPROJ'
UNION ALL
    /* SBP Financials Planned */
    SELECT [Version], CASE WHEN ISNULL([TypeofSales], '') IN ('FSN', 'FSL', 'FSE') THEN 'LOAD_INSTALL_FS' ELSE Audit_ID END AS [Audit_ID]/*,[Audit_ID]*/ , [CustomerShipTo], [DocItemNumber], [ForecastID],
        [Material_CS], [MachineSubType], [Equipment], [ProfitCenter], [CompCode], [Account], [Period], [DateFrom], [DateTo], [Value], [CS_Code] AS 'CSProduct', [SystemLine]
    FROM [SBP].[dbo].[vwSAC_Staging]
    WHERE        [Value] IS NOT NULL AND [Period] >= CONVERT(nvarchar(4), year(getdate())) + '.' + CONVERT(nvarchar(2), format(month(getdate()), '00'))
UNION ALL
    /* SBP FTE's Planned */
    SELECT [Version], CASE WHEN ISNULL([TypeofSales], '') IN ('FSN', 'FSL', 'FSE') THEN 'LOAD_INSTALL_FS' ELSE Audit_ID END AS [Audit_ID]/*,[Audit_ID]*/ , [CustomerShipTo], [DocItemNumber], [ForecastID],
        [Material_CS], [MachineSubType], [Equipment], [ProfitCenter], [CompCode], 'SP_LMP_FTE' AS 'Account', [Period], [DateFrom], [DateTo], [FTE] AS 'Value', [CS_Code] AS 'CSProduct', [SystemLine]
    FROM [SBP].[dbo].[vwSAC_Staging]
    WHERE        [FTE] IS NOT NULL AND [Period] >= CONVERT(nvarchar(4), year(getdate())) + '.' + CONVERT(nvarchar(2), format(month(getdate()), '00'))
UNION ALL
    /* SBP LHP Hours Planned*/
    SELECT [Version], CASE WHEN ISNULL([TypeofSales], '') IN ('FSN', 'FSL', 'FSE') THEN 'LOAD_INSTALL_FS' ELSE Audit_ID END AS [Audit_ID]/*,[Audit_ID]*/ , [CustomerShipTo], [DocItemNumber], [ForecastID],
        [Material_CS], [MachineSubType], [Equipment], [ProfitCenter], [CompCode], 'SP_LHP_HRS' AS 'Account', [Period], [DateFrom], [DateTo], [LHPHours] AS 'Value', [CS_Code] AS 'CSProduct', [SystemLine]
    FROM [SBP].[dbo].[vwSAC_Staging]
    WHERE        [LHPHours] IS NOT NULL AND [Period] >= CONVERT(nvarchar(4), year(getdate())) + '.' + CONVERT(nvarchar(2), format(month(getdate()), '00'))
