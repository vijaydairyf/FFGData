SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [00057-LineData] 36
CREATE PROCEDURE [dbo].[00057-LineData]
@plotID INT
AS
BEGIN

SELECT 
      d.ProductionLine
	, s.[Name] AS Supervisor
    , d.Operators
    , d.StartTimeHr + ' : ' + d.StartTimeMin AS StartTime
    , d.EndTimeHr + ' : ' + d.EndTimeMin AS EndTime
    , d.TotalWgt
    , d.RegTime
    , d.EntryNo
 

FROM [dbo].[tbl_FoyleIngredients_Diary]  d
LEFT JOIN dbo.[00057-Supervisors] s ON d.Supervisor = s.id
WHERE ProductionLineID =@plotID AND (CAST(d.RegTime AS DATE)= CAST(GETDATE()AS DATE))

END
GO
