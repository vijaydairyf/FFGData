SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 19th May 2017
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [0000-PopulateTblHROrdersFD] '119957','1'

CREATE PROCEDURE [dbo].[0000-PopulateTblHROrdersFH]

@OrderNo NVarChar(Max),  -- Have this passing through before going live.
@SubOrderNo NVarChar(Max),  -- Have this passing through before going live.
@SiteID NVarChar(Max)

AS

Truncate Table tblHrOrders

SELECT 10000+i.RowNo As RowNo, a.OrderNo, a.SubOrderNo, a.ProductCode, 
Case When a.InProductionStock = '1' then 0 Else a.PalletNo End As PalletNo,
a.BoxNo,  a.SiteID, '-------------------------' As 'SiteName', a.PalletID, a.DNOB, a.UseBy, 
IsNull(a.InProductionStock,0) As InProductionStock, 
'1' As HRBoxNo, --a.HR_BoxNo As HRBoxNo, 
a.OrderDate, a.Modified, Case When i.VIP='1' Then 'True' Else 'False' End As VIP,
Cast(i.[Delivery_Date] As smalldatetime) As DeliveryDate, Cast(i.[Group_Order_No] As NVarChar(20)) +'-' + Cast(i.[Sub_Order_No] As NVarChar(20)) As OrderSubNo
Into #na
FROM [ffgbi-serv].[ffg_dw].dbo.HR_Order_Allocation a
Left Join [ffgbi-serv].[ffg_dw].dbo.HR_Order_Summary_Import i On a.OrderNo=i.[Group_Order_No] And a.SubOrderNo=i.[Sub_Order_No] And a.[HR_BoxNo]=i.[Box_No]
WHERE (a.OrderNo = @OrderNo) And a.SubOrderNo=@SubOrderNo 
And a.siteid='3' --And  a.InProductionStock is null

--And Not a.ProductCode='902810374'

Order By Cast(10000+i.RowNo As int)

Update n Set n.SiteName=Case When n.SiteID=1 Then 'Foyle Campsie'	When n.SiteID=2 Then 'Foyle Omagh'	When n.SiteID=3 Then 'Foyle Hilton'
When n.SiteID=4 Then 'Foyle Donegal'	When n.SiteID=5 Then 'Foyle Gloucester'	When n.SiteID=6 Then 'Foyle Melton Mowbray' Else 'FFG' End
From #na n

Insert Into tblHROrders
(SSite, OrderRowNo, OrderNo, OrderSubNo, OrderDate, DeliveryDate, RowNo, SiteName, InventoryName, InventoryLocation, ProductCode,
 ProductDescription, LotCode, KillDate, ProductionDate,	UseByDate, DNOB, Qty, Wgt, PalletNo, VIPOrder,
 NavResQty,NavResWgt,QtyDiff,WgtDiff,HRBoxNo) --using HRBoxNo as Unit Location - not used and don't want to waste it.

Select 'FH' As SSite,
(10000*Cast(ROW_NUMBER() OVER(ORDER BY RowNo) As Int)) As OrderRowNo,
n.OrderNo, n.OrderSubNo, n.OrderDate, n.DeliveryDate, n.RowNo, n.SiteName, 
ISNULL(UPPER(pr.[name]),'') As InventoryName, ISNULL(UPPER(il.[code]),'') As InventoryLocation,
n.ProductCode, IsNull(pm.description2,'In Production'), pl.code, pk.expire2, pk.prday, 
pk.expire1, pk.expire3, Count(pm.Code) Qty, Cast(Sum(pk.[Weight]) As Decimal(18,2)) As Wgt, ISNULL(pc.number,'') AS [number], n.VIP,
0, 0, Count(pm.Code), Cast(Sum(pk.[Weight]) As Decimal(18,2)), 
Case When pt.description3='102 - VL' Then '2' When pt.description3='103 - OFFAL' Then '1'  Else '1' End As HrBoxNo 
From #na n
Left Join [FH_Innova].dbo.proc_packs (NoLock) pk On n.BoxNo  COLLATE DATABASE_DEFAULT  =pk.sscc
LEFT OUTER JOIN
                         [FH_Innova].dbo.proc_invlocations AS IL ON pk.invlocation = IL.id INNER JOIN
                         [FH_Innova].dbo.proc_materials AS pm WITH (nolock) ON pm.material = pk.material INNER JOIN
						 [FH_Innova].dbo.proc_materialtypes AS pt WITH (nolock) ON pm.materialtype = pt.materialtype LEFT OUTER JOIN
                         [FH_Innova].dbo.proc_collections AS pc WITH (nolock) ON pk.pallet = pc.id  INNER JOIN
                         [FH_Innova].dbo.proc_prunits AS pr WITH (nolock) ON pk.inventory = pr.prunit  INNER JOIN
                         [FH_Innova].dbo.proc_lots AS pl WITH (nolock) ON pk.lot = pl.lot
Group By n.OrderNo, n.OrderDate, n.OrderSubNo, n.DeliveryDate, n.RowNo, n.SiteName, n.ProductCode, pt.description3,  pm.description2, pl.code, pk.expire2, pk.prday, 
pk.expire1, pk.expire3, pc.number, n.VIP ,pr.[name],il.[code]

Drop Table #na

Update tblHROrders Set PalletNo='0' Where PalletNo IN('9999','7777')

Update o
Set o.NavLotNo=l.[Lot No_]
FROM tblHROrders o
Left Join  [ffgsql01].[FFG-PRODUCTION].dbo.[FFG LIVE$Lot No_ Information] l With (NoLock) On 
o.ProductCode COLLATE DATABASE_DEFAULT =l.[Item No_] 
And o.LotCode COLLATE DATABASE_DEFAULT =l.[Innova Lot No_]
And o.DNOB  =l.[DNOB]
And o.ProductionDate  =l.[Pack Date]
And o.KillDate  =l.[Kill Date] 
And o.UseByDate =l.[Use By Date]
And o.PalletNo COLLATE DATABASE_DEFAULT =l.[Pallet No_]
AND o.InventoryName COLLATE DATABASE_DEFAULT =l.[Innova Inventory]
And o.InventoryLocation COLLATE DATABASE_DEFAULT =l.[Innova Inventory Location]

SELECT i.[Lot No_] As [Lot], Sum(i.[Remaining Quantity]) / Sum(i.[Remaining Case Qty_]) As 'AvgWgt'
Into #avgwgt
FROM [ffgsql01].[FFG-PRODUCTION].dbo.[FFG LIVE$Item Ledger Entry] i (nolock)
Where (i.[Open] IN (1)) AND (i.Positive IN (1)) And i.[Location Code]='FH'
And i.[Lot No_] COLLATE DATABASE_DEFAULT  In(Select NavLotNo From tblHROrders Group By NavLotNo)
Group By i.[Lot No_]
Order by i.[Lot No_]

Update o
Set o.NavDesQty=o.Qty, o.NavDesWgt=IsNull(q.AvgWgt,o.Wgt/o.Qty), o.WgtDiff=(o.QtyDiff*IsNull(q.AvgWgt,o.Wgt/o.Qty))
FROM tblHROrders o
Left Join #avgwgt q On o.NavLotNo COLLATE DATABASE_DEFAULT =q.Lot
Where o.QtyDiff>=0

Update o
Set o.NavDesQty=o.Qty, o.NavDesWgt=IsNull((q.AvgWgt*-1),((o.Wgt/o.Qty)*-1)), o.WgtDiff=(o.QtyDiff*IsNull(q.AvgWgt,o.Wgt/o.Qty))*-1
FROM tblHROrders o
Left Join #avgwgt q On o.NavLotNo COLLATE DATABASE_DEFAULT =q.Lot
Where o.QtyDiff<0

Update tblHROrders Set WgtDiff=QtyDiff*NavDesWgt
Update tblHROrders Set WgtDiff=Round(WgtDiff,3)+0.005 Where Right(Cast(Cast(FLOOR((Round(wgtdiff,3) - FLOOR(Round(wgtdiff,3))) * 1000) As Float) As NVarChar(25)),2) = '55'
Update tblHROrders Set WgtDiff=Round(WgtDiff,2)

Update tblHROrders Set Processed='True' Where (QtyDiff=0) --(QtyDiff=0 And WgtDiff=0) - had to remove this because of the average weight thing.  Can only use QtyDiff
OR (InventoryName Like 'DISPATCH%' OR InventoryName Like 'DESPATCH%')--Processed on NAV and Quantities are good.
Update tblHROrders Set Processed='False' Where Processed Is Null
Update tblHROrders Set AddOn='False' Where AddOn Is Null
Update tblHROrders Set Processed='False' Where NOT (QtyDiff=0)

Update tblHROrders Set Processed='True' Where --(QtyDiff=0 And WgtDiff=0) - had to remove this because of the average weight thing.  Can only use QtyDiff
(InventoryName Like 'DISPATCH%' OR InventoryName Like 'DESPATCH%')--Processed on NAV and Quantities are good.

Select ProductCode, Sum(Qty) As Qty 
Into #tots
From tblHROrders
Group By ProductCode

Update o
Set o.LotQtyReq=t.Qty--, o.LotWgtReq=t.qty*o.NavDesWgt
From tblHROrders o
Inner Join #tots t On o.ProductCode=t.ProductCode

Drop Table #avgwgt
Drop Table #tots
GO
