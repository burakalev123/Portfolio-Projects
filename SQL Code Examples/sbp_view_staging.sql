USE [SBP]
GO

/****** Object:  View [dbo].[vwSAC_Staging]    Script Date: 20/06/2022 10:56:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwSAC_Staging]
AS

SELECT [Version]
,[Audit_ID] = 
CASE
    WHEN [typeofsales] IN ('FSN','FSL','FSE') THEN 'LOAD_INSTALL_FS' ELSE Audit_ID 
END
--,Audit_ID
,[CustomerShipTo]
,[DocItemNumber]
,[ForecastID]
,[Material_CS]
,[MachineSubType]
,[Equipment]
,[ProfitCenter]
,[CompCode]
,[Account]
,[Period]
,[DateFrom]
,[DateTo]
,[Value]
,[CS_Code]
,[SystemLine]
,[FTE]
,[LHPHours]
  FROM [SBP].[dbo].[tblStaging_Rows]
  WHERE (Version =
                 (SELECT Version
                    FROM [SBP].[dbo].[tblStaging_Rows] AS tblStaging_Rows_2
                    WHERE (ID =
                                (SELECT MAX(ID) AS Expr1
                                   FROM [SBP].[dbo].[tblStaging_Rows] AS tblStaging_Rows_1))))
GO