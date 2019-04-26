SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <08/02/19>
-- Description:	<Report 08/02/19>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_Group_Fresh_Daily_Snapshot_Report]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


   SELECT	[date],
			DATENAME(dw,GETDATE()) AS [Today],
			DATENAME(dw,[Date]) AS [WeekDay],
			[Product Condition],
			SUM([Weight]) AS TotWeight,
			ISNULL(SUM([Value]),0) AS TotValue

         
   FROM [dbo].[Group_Fresh_Snapshot_Daily]

   WHERE [date] between DateAdd(DD,-7,GETDATE() ) and GETDATE() 
   

   GROUP BY  
   [Product Condition],
   DATENAME(dw,[Date]),
   [date]

   ORDER BY  [date] desc

END
GO
