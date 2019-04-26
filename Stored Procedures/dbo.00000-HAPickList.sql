SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [00000-HAPickList] '128743','1','FC'

--martin was here0111

CREATE PROCEDURE [dbo].[00000-HAPickList]

@OrderNo NVarChar(Max), 
@SubOrderNo NVarChar(Max), 
@FFGSite NVarChar(Max)

AS


SELECT      [Item No_] ProductCode, Sum([Remaining Case Qty_]) Qty,  [Location Code] SiteID, [Pallet No_] PalletNo, Min([Kill Date]) KillDate, Min([Pack Date]) PackDate, DNOB,  [Use by Date] UseBy, --[Innova Lot No_] LotNo,
                         [Innova Inventory] Inventory, [Innova Inventory Location] Locn, ' [ '+Right(' '+Cast(Cast(Sum([Remaining Case Qty_]) As Integer) As NVarChar(Max)),8)+' Cases @'+' '+
						 [Innova Inventory] +' '+[Innova Inventory Location] +' P/N: '+ [Pallet No_] +' ] ' AS ALT
INTO #t
FROM            [ffgsql01].[FFG-PRODUCTION].dbo.[FFG LIVE$Item Ledger Entry] --(NOLOCK)
WHERE        ([Remaining Case Qty_] > 0) And Substring([Item No_],1,2) In ('34','50','90') And [Open]=1 And Positive=1 And Not [Location Code]='FI'
AND NOT [Innova Inventory]='READY TO SHIP'
--AND [Item No_]='902810374' AND [Location Code]='FD' 

Group By [Item No_],[Location Code], [Pallet No_], DNOB, 
[Use by Date],[Innova Inventory], [Innova Inventory Location]

SELECT ProductCode, SiteID, KillDate, PackDate, DNOB, UseBy
Into #t2 From #t
Select ProductCode, SiteID, KillDate, PackDate, DNOB, UseBy,
ALT Into #t3 From #t


SELECT 
   SS.SiteID, SS.ProductCode,Min(SS.KillDate) KillDate, SS.DNOB, SS.UseBy,
	   STUFF((SELECT '/ ' + US.ALT
			  FROM #t3 US
			  WHERE US.ProductCode = SS.ProductCode
			  AND US.SiteID = SS.SiteID
			  AND US.DNOB = SS.DNOB
			  AND US.UseBy = SS.UseBy
			  FOR XML PATH('')), 1, 1, '') [AltLocn]
Into #t4
FROM #t2 SS
GROUP BY SS.ProductCode, SS.SiteID, SS.DNOB, SS.UseBy
ORDER BY 1

SELECT   o.SSite, o.OrderNo, o.OrderSubNo, o.ProductCode, o.ProductDescription, o.LotCode, o.KillDate, o.ProductionDate, 
                         o.UseByDate, o.DNOB, o.Qty, o.NavSalesOrder, o.SiteName, t.AltLocn
FROM            tblHROrders o
Left Join #t4 t On o.SSite collate database_default =t.SiteID And o.ProductCode collate database_default =t.ProductCode And o.KillDate=t.KillDate And o.DNOB=t.DNOB
WHERE        (o.SSite = @FFGSite) AND (o.OrderNo = @OrderNo) AND (RIGHT(o.OrderSubNo, 1) = @SubOrderNo)
ORDER BY o.NavSalesOrder

--Dropping tables used in the Alternative Locations Option		
		DROP TABLE #t, #t2, #t3, #t4
GO
