SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 19th May 2017
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [0000-PopulateTblHROrders] '119777','1'

CREATE PROCEDURE [dbo].[0000-PopulateTblHROrders]

@OrderNo NVarChar(Max),  -- Have this passing through before going live.
@SubOrderNo NVarChar(Max)  -- Have this passing through before going live.

AS

SELECT i.[Location Code] As [Site],  i.[Pallet No_] As Pallet, i.[Innova Inventory] As Inventory, i.[Innova Inventory Location] As [Location], i.[Lot No_] As [Lot]
Into #Lot
FROM [FFGSQLTEST].[PHASE2].dbo.[Phase2$Item Ledger Entry] i (nolock)
Left JOIN [FFGSQLTEST].[PHASE2].dbo.[Phase2$Reservation Entry] r (nolock) ON i.[Lot No_]=r.[Lot No_]
And (i.[Open] IN (1)) AND (i.Positive IN (1)) 
Where ((i.[Remaining Quantity]-IsNull(r.[Quantity],0)) > 0) 
Order by i.[Lot No_]

Truncate Table tblHrOrders

--Delete From tblHROrders Where OrderNo=@OrderNo and OrderSubNo=@SubOrderNo

SELECT 10000+i.RowNo As RowNo, a.OrderNo, a.SubOrderNo, a.ProductCode, a.PalletNo, a.BoxNo, a.SiteID, '-------------------------' As 'SiteName', a.PalletID, a.DNOB, a.UseBy, 
IsNull(a.InProductionStock,0) As InProductionStock, a.HR_BoxNo As HRBoxNo, a.OrderDate, a.Modified, Case When i.VIP='1' Then 'True' Else 'False' End As VIP,
Cast(i.[Delivery_Date] As smalldatetime) As DeliveryDate, Cast(i.[Group_Order_No] As NVarChar(20)) +'-' + Cast(i.[Sub_Order_No] As NVarChar(20)) As OrderSubNo
Into #na
FROM [ffgbi-serv].[ffg_dw].dbo.HR_Order_Allocation a
Left Join [ffgbi-serv].[ffg_dw].dbo.HR_Order_Summary_Import i On a.OrderNo=i.[Group_Order_No] And a.SubOrderNo=i.[Sub_Order_No] And a.[HR_BoxNo]=i.[Box_No]
WHERE (a.OrderNo = @OrderNo) And a.SubOrderNo=@SubOrderNo
Order By Cast(10000+i.RowNo As int)

Update n Set n.SiteName=Case When n.SiteID=1 Then 'Foyle Campsie'	When n.SiteID=2 Then 'Foyle Omagh'	When n.SiteID=3 Then 'Foyle Hilton'
When n.SiteID=4 Then 'Foyle Donegal'	When n.SiteID=5 Then 'Foyle Gloucester'	When n.SiteID=6 Then 'Foyle Melton Mowbray' Else 'FFG' End
From #na n

Insert Into tblHROrders
(SSite, OrderRowNo, OrderNo, OrderSubNo, OrderDate, DeliveryDate, RowNo, SiteName, InventoryName, InventoryLocation, HRBoxNo, ProductCode,
 ProductDescription, LotCode, KillDate, ProductionDate,	UseByDate, DNOB, Qty, Wgt, PalletNo, VIPOrder)

Select 'FC' As SSite,
(10000*Cast(ROW_NUMBER() OVER(ORDER BY RowNo) As Int)) As OrderRowNo,
n.OrderNo, n.OrderSubNo, n.OrderDate, n.DeliveryDate, n.RowNo, n.SiteName, 
'' As InventoryName, '' As InventoryLocation,
n.HRBoxNo, n.ProductCode, p.ProductDescription, p.LotCode, p.KillDate, p.ProductionDate, 
p.UseByDate, p.DNOB, Count(n.ProductCode) Qty, Sum(p.[Weight]) As Wgt, n.PalletNo, n.VIP
From #na n
Left Join [FFGData].dbo.tblPack (NoLock) p On n.BoxNo=p.sscc And n.SiteName=p.StockSite
Where Not p.PalletNo Is Null and n.SiteName='Foyle Campsie'
Group By n.OrderNo, n.OrderDate, n.OrderSubNo, n.DeliveryDate, n.RowNo, n.SiteName, n.ProductCode, n.HRBoxNo, p.ProductDescription, 
p.LotCode, p.KillDate, p.ProductionDate, p.UseByDate, p.DNOB, n.PalletNo, n.VIP 
--
Union
--
Select 'FGL' As SSite,
(10000*Cast(ROW_NUMBER() OVER(ORDER BY RowNo) As Int)) As OrderRowNo,
n.OrderNo, n.OrderSubNo, n.OrderDate, n.DeliveryDate, n.RowNo, n.SiteName, 
'' As InventoryName, '' As InventoryLocation,
n.HRBoxNo, n.ProductCode, p.ProductDescription, p.LotCode, p.KillDate, p.ProductionDate, 
p.UseByDate, p.DNOB, Count(n.ProductCode) Qty, Sum(p.[Weight]) As Wgt, n.PalletNo, n.VIP
From #na n
Left Join [FFGData].dbo.tblPack (NoLock) p On n.BoxNo=p.sscc And n.SiteName=p.StockSite
Where Not p.PalletNo Is Null and n.SiteName='Foyle Gloucester'
Group By n.OrderNo, n.OrderDate, n.OrderSubNo, n.DeliveryDate, n.RowNo, n.SiteName, n.ProductCode, n.HRBoxNo, p.ProductDescription, 
p.LotCode, p.KillDate, p.ProductionDate, p.UseByDate, p.DNOB, n.PalletNo, n.VIP 
--
Union
--
Select  'FD' As SSite,
(10000*Cast(ROW_NUMBER() OVER(ORDER BY RowNo) As Int)) As OrderRowNo,
n.OrderNo, n.OrderSubNo, n.OrderDate, n.DeliveryDate, n.RowNo, n.SiteName, 
'' As InventoryName, '' As InventoryLocation,
n.HRBoxNo, n.ProductCode, p.ProductDescription, p.LotCode, p.KillDate, p.ProductionDate, 
p.UseByDate, p.DNOB, Count(n.ProductCode) Qty, Sum(p.[Weight]) As Wgt, n.PalletNo, n.VIP
From #na n
Left Join [FFGData].dbo.tblPack (NoLock) p On n.BoxNo=p.sscc And n.SiteName=p.StockSite
Where Not p.PalletNo Is Null and n.SiteName='Foyle Donegal'
Group By n.OrderNo, n.OrderDate, n.OrderSubNo, n.DeliveryDate, n.RowNo, n.SiteName, n.ProductCode, n.HRBoxNo, p.ProductDescription, 
p.LotCode, p.KillDate, p.ProductionDate, p.UseByDate, p.DNOB, n.PalletNo, n.VIP 
--
Union
--
Select  'FH' As SSite,
(10000*Cast(ROW_NUMBER() OVER(ORDER BY RowNo) As Int)) As OrderRowNo,
n.OrderNo, n.OrderSubNo, n.OrderDate, n.DeliveryDate, n.RowNo, n.SiteName, 
'' As InventoryName, '' As InventoryLocation,
n.HRBoxNo, n.ProductCode, p.ProductDescription, p.LotCode, p.KillDate, p.ProductionDate, 
p.UseByDate, p.DNOB, Count(n.ProductCode) Qty, Sum(p.[Weight]) As Wgt, n.PalletNo, n.VIP
From #na n
Left Join [FFGData].dbo.tblPack (NoLock) p On n.BoxNo=p.sscc And n.SiteName=p.StockSite
Where Not p.PalletNo Is Null and n.SiteName='Foyle Hilton'
Group By n.OrderNo, n.OrderDate, n.OrderSubNo, n.DeliveryDate, n.RowNo, n.SiteName, n.ProductCode, n.HRBoxNo, p.ProductDescription, 
p.LotCode, p.KillDate, p.ProductionDate, p.UseByDate, p.DNOB, n.PalletNo, n.VIP 
--
Union
--
Select  'FO' As SSite,
(10000*Cast(ROW_NUMBER() OVER(ORDER BY RowNo) As Int)) As OrderRowNo,
n.OrderNo, n.OrderSubNo, n.OrderDate, n.DeliveryDate, n.RowNo, n.SiteName, 
'' As InventoryName, '' As InventoryLocation,
n.HRBoxNo, n.ProductCode, p.ProductDescription, p.LotCode, p.KillDate, p.ProductionDate, 
p.UseByDate, p.DNOB, Count(n.ProductCode) Qty, Sum(p.[Weight]) As Wgt, n.PalletNo, n.VIP
From #na n
Left Join [FFGData].dbo.tblPack (NoLock) p On n.BoxNo=p.sscc And n.SiteName=p.StockSite
Where Not p.PalletNo Is Null and n.SiteName='Foyle Omagh'
Group By n.OrderNo, n.OrderDate, n.OrderSubNo, n.DeliveryDate, n.RowNo, n.SiteName, n.ProductCode, n.HRBoxNo, p.ProductDescription, 
p.LotCode, p.KillDate, p.ProductionDate, p.UseByDate, p.DNOB, n.PalletNo, n.VIP 
--
Union
--
Select  'FMM' As SSite,
(10000*Cast(ROW_NUMBER() OVER(ORDER BY RowNo) As Int)) As OrderRowNo,
n.OrderNo, n.OrderSubNo, n.OrderDate, n.DeliveryDate, n.RowNo, n.SiteName, 
'' As InventoryName, '' As InventoryLocation,
n.HRBoxNo, n.ProductCode, p.ProductDescription, p.LotCode, p.KillDate, p.ProductionDate, 
p.UseByDate, p.DNOB, Count(n.ProductCode) Qty, Sum(p.[Weight]) As Wgt, n.PalletNo, n.VIP
From #na n
Left Join [FFGData].dbo.tblPack (NoLock) p On n.BoxNo=p.sscc And n.SiteName=p.StockSite
Where Not p.PalletNo Is Null and n.SiteName='Foyle Melton Mowbray'
Group By n.OrderNo, n.OrderDate, n.OrderSubNo, n.DeliveryDate, n.RowNo, n.SiteName, n.ProductCode, n.HRBoxNo, p.ProductDescription, 
p.LotCode, p.KillDate, p.ProductionDate, p.UseByDate, p.DNOB, n.PalletNo, n.VIP 

Drop Table #na

Update tblHROrders Set PalletNo='0' Where PalletNo IN('9999','7777')

Update o
Set o.NavLotNo=l.[Lot No_]
FROM tblHROrders o
Left Join  [ffgsqltest].[PHASE2].dbo.[Phase2$Lot No_ Information] l On 
o.ProductCode COLLATE DATABASE_DEFAULT =l.[Item No_] 
And o.LotCode COLLATE DATABASE_DEFAULT =l.[Innova Lot No_]
And o.DNOB  =l.[DNOB]
And o.ProductionDate  =l.[Pack Date]
And o.KillDate  =l.[Kill Date] 
And o.UseByDate =l.[Use By Date]
And o.PalletNo COLLATE DATABASE_DEFAULT =l.[Pallet No_]

SELECT   
 l.[Lot No_] As 'LotNo', Sum(o.Qty) As 'Qty', Sum(o.Wgt) As Wgt
Into #q
FROM tblHROrders o
Left Join  [ffgsqltest].[PHASE2].dbo.[Phase2$Lot No_ Information] l (nolock) On 
o.ProductCode COLLATE DATABASE_DEFAULT =l.[Item No_] 
And o.LotCode COLLATE DATABASE_DEFAULT =l.[Innova Lot No_]
And o.DNOB  =l.[DNOB]
And o.ProductionDate  =l.[Pack Date]
And o.KillDate  =l.[Kill Date] 
And o.UseByDate =l.[Use By Date]
And o.PalletNo COLLATE DATABASE_DEFAULT =l.[Pallet No_]
Group By  l.[Lot No_]

Update o
Set o.LotQtyReq=q.Qty, o.LotWgtReq=q.Wgt
FROM tblHROrders o
Left Join #q q On o.NavLotNo COLLATE DATABASE_DEFAULT =q.LotNo

Drop Table #q

SELECT   
o.id, Case When o.LotWgtReq <= Sum(e.[Remaining Quantity]) Then 1 Else 0 End As OkOnNav2
Into #z
FROM tblHROrders o
Left Join  [ffgsqltest].[PHASE2].dbo.[Phase2$Lot No_ Information] l (nolock) On 
o.ProductCode COLLATE DATABASE_DEFAULT =l.[Item No_] 
And o.LotCode COLLATE DATABASE_DEFAULT =l.[Innova Lot No_]
And o.DNOB  =l.[DNOB]
And o.ProductionDate  =l.[Pack Date]
And o.KillDate  =l.[Kill Date] 
And o.UseByDate =l.[Use By Date]
And o.PalletNo COLLATE DATABASE_DEFAULT =l.[Pallet No_]
Left Join  [ffgsqltest].[PHASE2].dbo.[Phase2$Item Ledger Entry] e (nolock) On
l.[Lot No_]=e.[Lot No_] And l.[Item No_] =e.[Item No_]  And e.[Remaining Quantity]>0
Group By o.id, o.LotWgtReq
Order By o.id

Update o
Set o.OkOnNav=z.OkOnNav2
FROM tblHROrders o
Inner Join #z z On o.id=z.id

Update o
Set o.NavInventory=l.Inventory , o.NavLocation=l.[Location]
FROM tblHROrders o
Left Join #Lot l On o.NavLotNo COLLATE DATABASE_DEFAULT =l.Lot And o.PalletNo COLLATE DATABASE_DEFAULT =l.Pallet


Drop Table #z
Drop Table #Lot
GO
