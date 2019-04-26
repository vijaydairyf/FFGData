SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe Maguire>
-- Create date: <Create Date,,080319>
-- Description:	<Description,,>
-- =============================================

--exec  [dbo].[0803_ItemRecon_Tbl_Maintenance]
CREATE PROCEDURE [dbo].[0803_ItemRecon_Tbl_Maintenance]
	
AS
BEGIN

DECLARE @SSDate DATETIME
SET @SSDate =  CAST(GETDATE()-13 AS DATE)
--SELECT @SSDate

SELECT * 
FROM dbo.tbl_Group_Item_Reconciliation_SS
--WHERE CAST(ProductionDay AS DATE) < @SSDate

--TRUNCATE TABLE dbo.tbl_Group_Item_Reconciliation_SS


END
GO
