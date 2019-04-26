SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[00057-SSRS_Report]
	
AS
BEGIN
SELECT 
       d.ProductionLine
	, s.Name AS Supervisor
     , d.Operators
     , d.StartTimeHr + ' : ' + d.StartTimeMin AS StartTime
     , d.EndTimeHr + ' :  ' + d.EndTimeMin AS EndTime
     , d.TotalWgt
     , d.RegTime
     , d.LineType
     , d.EntryNo
FROM dbo.tbl_FoyleIngredients_Diary d
INNER JOIN dbo.[00057-Supervisors] s ON d.Supervisor = s.id
WHERE CAST(d.RegTime AS DATE) = CAST(GETDATE()AS DATE)
ORDER BY d.LineType,d.ProductionLine,d.EntryNo
END
GO
