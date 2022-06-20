USE [SBP]
GO
    /****** Object:  View [dbo].[vwSAC_StagingV2]    Script Date: 20/06/2022 10:43:55 ******/
SET
    ANSI_NULLS ON
GO
SET
    QUOTED_IDENTIFIER ON
GO
    ALTER VIEW [dbo].[vwSAC_StagingV2] AS
    /* SBP Field Projects Actuals */
SELECT
    [Version],
    [Audit_ID],
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
    [CS_Code] as 'CSProduct',
    [SystemLine]
FROM
    [SBP].[dbo].[vwSAC_Staging]
WHERE
    [Value] IS NOT NULL
    AND [Period] < convert(nvarchar(4), year(getdate())) + '.' + convert(nvarchar(2), format(month(getdate()), '00'))
    AND [Audit_ID] = 'LOAD_FIELDPROJ'
UNION
ALL
/* SBP Financials Planned */
SELECT
    [Version],
    [Audit_ID],
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
    [CS_Code] as 'CSProduct',
    [SystemLine]
FROM
    [SBP].[dbo].[vwSAC_Staging]
WHERE
    [Value] IS NOT NULL
    AND [Period] >= convert(nvarchar(4), year(getdate())) + '.' + convert(nvarchar(2), format(month(getdate()), '00'))
UNION
ALL
/* SBP FTE's Planned */
SELECT
    [Version],
    [Audit_ID],
    [CustomerShipTo],
    [DocItemNumber],
    [ForecastID],
    [Material_CS],
    [MachineSubType],
    [Equipment],
    [ProfitCenter],
    [CompCode],
    'SP_LMP_FTE' as 'Account',
    [Period],
    [DateFrom],
    [DateTo],
    [FTE] as 'Value',
    [CS_Code] as 'CSProduct',
    [SystemLine]
FROM
    [SBP].[dbo].[vwSAC_Staging]
WHERE
    [FTE] IS NOT NULL
    AND [Period] >= convert(nvarchar(4), year(getdate())) + '.' + convert(nvarchar(2), format(month(getdate()), '00'))
UNION
ALL
/* SBP LHP Hours Planned*/
SELECT
    [Version],
    [Audit_ID],
    [CustomerShipTo],
    [DocItemNumber],
    [ForecastID],
    [Material_CS],
    [MachineSubType],
    [Equipment],
    [ProfitCenter],
    [CompCode],
    'SP_LHP_HRS' as 'Account',
    [Period],
    [DateFrom],
    [DateTo],
    [LHPHours] as 'Value',
    [CS_Code] as 'CSProduct',
    [SystemLine]
FROM
    [SBP].[dbo].[vwSAC_Staging]
WHERE
    [LHPHours] IS NOT NULL
    AND [Period] >= convert(nvarchar(4), year(getdate())) + '.' + convert(nvarchar(2), format(month(getdate()), '00'))
GO