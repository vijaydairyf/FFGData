SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--exec [dbo].[0103_Insert_FoyleI_Labour_Detail] 'FI Order Line 1','Mickey Taggart','9','0815','2019-03-14 11:18:23.080'
--exec [dbo].[0103_Insert_FoyleI_Labour_Detail] 'FI Order Line 1','NULL',NULL,'NULL','2019-03-14 11:18:23.080'

CREATE PROCEDURE [dbo].[0103_Insert_FoyleI_Labour_Detail]
	-- Add the parameters for the stored procedure here
		@ProductionLine NVARCHAR(40),
		@Supervisor NVARCHAR(100),
		@Operators INT,
		@StartTimeHr NVARCHAR(5),
		@StartTimeMin NVARCHAR(5),
		@EndTimeHr NVARCHAR(5),
		@EndTimeMin NVARCHAR(5)
		
AS
BEGIN

		DECLARE @PrDate DATE = CAST(GETDATE() AS DATE)
		--SELECT @PrDate

		UPDATE i
		SET i.Supervisor = @Supervisor,
			i.Operators = @Operators,
			i.StartTimeHr = @StartTimeHr,
			i.[StartTimeMin] = @StartTimeMin,
		    i.[EndTimeHr] = @EndTimeHr,
			i.[EndTimeMin] = @EndTimeMin
			--i.TotalWgt = @Weight

		FROM dbo.tbl_FoyleIngredients_Labour i
		WHERE i.ProductionDate = @PrDate AND i.ProductionLine = @ProductionLine --AND i.TotalWgt = 0




END
GO
