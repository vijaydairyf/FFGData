SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[0103_READ_TBL_FoyleIngredients_Labour] 

AS
BEGIN

SELECT RecordID
    , ProductionLine
    , ProductionLineID
    , Supervisor
    , Operators
	, [StartTimeHr]
    , [StartTimeMin]
	, [EndTimeHr]
	, [EndTimeMin]
    , TotalWgt
    , ProductionDate
    , LineType
FROM [dbo].[tbl_FoyleIngredients_Labour]
WHERE ProductionDate = CAST(GETDATE() AS DATE)
ORDER BY LineType, ProductionLine ASC



END
GO
