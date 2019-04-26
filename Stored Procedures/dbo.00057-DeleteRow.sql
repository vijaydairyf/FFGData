SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,joe maguire>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [dbo].[00057-DeleteRow] 'FI Order Line 1','1'
CREATE PROCEDURE [dbo].[00057-DeleteRow]
	-- Add the parameters for the stored procedure here
		@production NVARCHAR(MAX),
		@Entryno INT
AS
BEGIN

DECLARE @Regtime DATETIME = (SELECT TOP 1 RegTime FROM dbo.tbl_FoyleIngredients_Diary WHERE ProductionLineID = 41 AND Active =1 ORDER BY RegTime DESC)

IF @Entryno = 1
BEGIN
    UPDATE dbo.tbl_FoyleIngredients_Diary
	SET Supervisor = NULL,Operators = 0, StartTimeHr = NULL,StartTimeMin = NULL, EndTimeHr = NULL, EndTimeMin = NULL,TotalWgt = 0.00,
		RegTime = @Regtime,Archived=0,Active=1
	WHERE CAST(ProductionDate AS DATE) = CAST(GETDATE()AS DATE)AND ProductionLine = @production AND EntryNo = 1
END
ELSE 

	DELETE FROM dbo.tbl_FoyleIngredients_Diary WHERE ProductionLine = @production AND EntryNo = @Entryno

END
GO
