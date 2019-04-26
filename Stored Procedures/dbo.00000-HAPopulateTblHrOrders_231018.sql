SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--Truncate Table tblHrOrders

--exec [00000-HAPopulateTblHrOrders_231018] '131403','1','FH'

CREATE PROCEDURE [dbo].[00000-HAPopulateTblHrOrders_231018]

@OrderNo NVarChar(Max),  -- Have this passing through before going live.
@SubOrderNo NVarChar(Max), -- Have this passing through before going live.
@FFGSite NVarChar(Max)

AS

Declare @Switch Int
Set @Switch=0 --Set to 0 if using live, 1 if using test...

Declare @SiteID NVarChar(100)
Set @SiteID=(Case When @FFGSite='FC' Then '1' When @FFGSite='FO' Then '2' When @FFGSite='FH' Then '3' When @FFGSite='FD' Then '4' 
When @FFGSite='FGL' Then '5' When @FFGSite='FMM' Then '6' End)


SELECT 10000+i.RowNo As RowNo, a.OrderNo, a.SubOrderNo, a.ProductCode, 
Case When a.InProductionStock = '1' then 0 Else a.PalletNo End As PalletNo,
a.BoxNo,  
Case 
When e.[Location]='Sawyers Coldstore' Then 99  
When e.[Location]='Sawyers Intransit' Then 99
When e.[Location]='Annesborough Intransit' And e.FFGSite='FOCS' Then 99
When e.[Location]='Annesborough Coldstore' And e.FFGSite='FOCS' Then 99
When e.[Location]='Lurgan Sawyers' Then 98 
When e.[Location]='Annesborough Intransit' And e.FFGSite='FHCS' Then 98
When e.[Location]='Annesborough Coldstore' And e.FFGSite='FHCS' Then 98
Else a.SiteID End As SiteID,
--a.SiteID, 
'-------------------------' As 'SiteName', IsNull(a.PalletID,'0') As PalletID, IsNull(a.DNOB,a.OrderDate) As DNOB, IsNull(a.UseBy,a.OrderDate) As UseBy, 
IsNull(a.InProductionStock,0) As InProductionStock,  '1' As HRBoxNo, a.OrderDate, a.Modified, 
Case When i.VIP='1' Then 'True' Else 'False' End As VIP,
Cast(i.[Delivery_Date] As smalldatetime) As DeliveryDate, Cast(i.[Group_Order_No] As NVarChar(20)) +'-' + Cast(i.[Sub_Order_No] As NVarChar(20)) As OrderSubNo
Into #na
FROM [ffgbi-serv].[ffg_dw].dbo.HR_Order_Allocation a
Left Join [ffgbi-serv].[ffg_dw].dbo.HR_Order_Summary_Import i On a.OrderNo=i.[Group_Order_No] And a.SubOrderNo=i.[Sub_Order_No] And a.[HR_BoxNo]=i.[Box_No]
Left Join [HaEcs] e On a.BoxNo=e.SSCC
WHERE (a.OrderNo = @OrderNo) And a.SubOrderNo=@SubOrderNo 
And a.siteid=@SiteID 
Order By Cast(10000+i.RowNo As int)

Update n Set n.SiteName=Case When n.SiteID=1 Then 'Foyle Campsie'	When n.SiteID=2 Then 'Foyle Omagh'	When n.SiteID=3 Then 'Foyle Hilton'
When n.SiteID=4 Then 'Foyle Donegal'	When n.SiteID=5 Then 'Foyle Gloucester'	When n.SiteID=6 Then 'Foyle Melton Mowbray' 
When n.SiteID=99 Then 'FO External Cold Store' 
When n.SiteID=98 Then 'FH External Cold Store' 
Else 'FFG' End
From #na n



IF @SiteID='3' 
	BEGIN

		Select 'FH' As SSite,
		10000 As OrderRowNo,
		n.OrderNo, n.OrderSubNo, n.OrderDate, n.DeliveryDate, 1 As RowNo, --n.RowNo, 
		n.SiteName, 
		Case When pm.fabcode3='FRESH' Then '0' Else '1' End As InventoryName, 
		'' As InventoryLocation,
		n.ProductCode, IsNull(pm.description2,'In Production'), pl.code, pk.expire2, pk.prday, 
		pk.expire1, pk.expire3, Count(pm.Code) Qty, Cast(Sum(pk.[Weight]) As Decimal(18,2)) As Wgt, ''AS [number], n.VIP,
		0, 0, Count(pm.Code), Cast(Sum(pk.[Weight]) As Decimal(18,2)), 
		Case When pt.description3='102 - VL' Then '2' When pt.description3='103 - OFFAL' Then '2'  Else '1' End As HrBoxNo 
		From #na n
		LEFT Join 
								--[FH_Innova].dbo.proc_packs  pk (Nolock) On n.BoxNo  COLLATE DATABASE_DEFAULT  =pk.sscc
								 [cktsql01].[Innova].dbo.proc_packs  pk (Nolock) On n.BoxNo  COLLATE DATABASE_DEFAULT  =pk.sscc
		LEFT OUTER JOIN
								 [cktsql01].[Innova].dbo.proc_invlocations AS IL ON pk.invlocation = IL.id INNER JOIN
								 [cktsql01].[Innova].dbo.vw_matswithNoXML AS pm WITH (nolock) ON pm.material = pk.material INNER JOIN
								 [cktsql01].[Innova].dbo.vw_mattypesWithNoXML AS pt WITH (nolock) ON pm.materialtype = pt.materialtype LEFT OUTER JOIN
								 [cktsql01].[Innova].dbo.proc_collections AS pc WITH (nolock) ON pk.pallet = pc.id  INNER JOIN
								 [cktsql01].[Innova].dbo.vw_proc_prunitsWithNoXML AS pr WITH (nolock) ON pk.inventory = pr.prunit  INNER JOIN
								 [cktsql01].[Innova].dbo.vw_LotswithNoXML AS pl WITH (nolock) ON pk.lot = pl.lot

								 --[FH_Innova].dbo.proc_invlocations AS IL ON pk.invlocation = IL.id INNER JOIN
								 --[FH_Innova].dbo.proc_materials AS pm WITH (nolock) ON pm.material = pk.material INNER JOIN
								 --[FH_Innova].dbo.proc_materialtypes AS pt WITH (nolock) ON pm.materialtype = pt.materialtype LEFT OUTER JOIN
								 --[FH_Innova].dbo.proc_collections AS pc WITH (nolock) ON pk.pallet = pc.id  INNER JOIN
								 --[FH_Innova].dbo.proc_prunits AS pr WITH (nolock) ON pk.inventory = pr.prunit  INNER JOIN
								 --[FH_Innova].dbo.proc_lots AS pl WITH (nolock) ON pk.lot = pl.lot

		Group By n.OrderNo, n.OrderDate, n.OrderSubNo, n.DeliveryDate,-- n.RowNo, 
		n.SiteName, n.ProductCode, pt.description3,  pm.description2, pl.code, pk.expire2, pk.prday, 
		pk.expire1, pk.expire3,  n.VIP, pm.fabcode3
	END




Drop Table #na
GO
