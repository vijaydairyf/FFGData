SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin>
-- Create date: <07/08/17>
-- Description:	<Checks group pack table for packs in QC Hold inventory and Returns>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Group_QCHolds_Reworked_Packs]

--exec [dbo].[SP_Group_QCHolds_Reworked_Packs]
	
AS

	
	
    select pk.stocksite as [Site], pk.ProductCode, pk.productdescription, COUNT(pk.ProductCode) AS QTY, ROUND(SUM(pk.Weight),2) as [Weight], pk.inventoryname, 
	pk.KillDate as [Kill Date], pk.DNOB as DNOB, pk.ProductionDate as [Production Day], pk.UseByDate as [Use By Date], pk.InventoryTime

from [dbo].[tblPack] AS pk (nolock)

where	(pk.inventoryname ='QC HOLD') OR
		(pk.inventorycategory LIKE '%Return%') 
		

group by pk.stocksite, pk.ProductCode,pk.productdescription, pk.inventoryname,pk.KillDate, pk.DNOB , pk.ProductionDate , pk.UseByDate, pk.InventoryTime


order by [Site] desc


GO
