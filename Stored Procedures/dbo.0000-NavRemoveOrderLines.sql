SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 19th May 2017
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [0000-NavDetails]

CREATE PROCEDURE [dbo].[0000-NavRemoveOrderLines]

AS

Select 
r.[Pallet No_], r.[Source ID], Sum(r.[Case Qty_]) [Case Qty_], Sum(r.[Quantity]) [Quantity], r.[Innova Inventory],r.[Innova Inventory Location], r.[Lot No_], r.[Location Code], 
r.[Item No_], r.[DNOB], r.[Pack Date], r.[Kill Date], r.[Use By Date], r.[Innova Lot No_]
Into #ResEnt2
From [ffgsqltest].[PHASE2].dbo.[Phase2$Reservation Entry] r With (NOLOCK)
Group By r.[Pallet No_],r.[Source ID],r.[Innova Inventory],r.[Innova Inventory Location],r.[Lot No_],r.[Location Code],r.[Source ID],
r.[Item No_], r.[DNOB], r.[Pack Date], r.[Kill Date], r.[Use By Date], r.[Innova Lot No_]


Update o
Set o.NavLotNo=l.[Lot No_],
o.NavSalesOrder=IsNull(l.[Source ID],''),
o.NavPalletNo=IsNull(l.[Pallet No_],''),
o.LastNegILE=0,
o.NavResQty=IsNull(l.[Case Qty_],0), 
o.NavResWgt=CASE WHEN IsNull(l.[Quantity],0) < 0 THEN (IsNull(l.[Quantity],0)*-1) ELSE (IsNull(l.[Quantity],0)) END,
o.NavInventory=IsNull(l.[Innova Inventory],''), 
o.NavLocation=IsNull(l.[Innova Inventory Location],'')
FROM tblHROrders o
Left Join  #ResEnt2 l With (NoLock) On 
o.ProductCode COLLATE DATABASE_DEFAULT =l.[Item No_] 
And o.LotCode COLLATE DATABASE_DEFAULT =l.[Innova Lot No_]
And o.DNOB  =l.[DNOB]
And o.ProductionDate  =l.[Pack Date]
And o.KillDate  =l.[Kill Date] 
And o.UseByDate =l.[Use By Date]
And o.SSite COLLATE DATABASE_DEFAULT = l.[Location Code]
And o.Qty=l.[Case Qty_]
--And Round(o.NavDesWgt,2)*o.Qty Between (l.[Quantity]-0.99) And (l.[Quantity]+0.99)

Update o Set o.NavSalesOrder=r.[Source ID] FROM tblHROrders o With (NoLock)
Left Join [ffgsqltest].[PHASE2].dbo.[Phase2$Reservation Entry] r  With (NoLock) On o.NavLotNo COLLATE DATABASE_DEFAULT = r.[Lot No_]

Select 
r.[Pallet No_], r.[Source ID], Sum(r.[Case Qty_]) [Case Qty_], Sum(r.[Quantity]) [Quantity], r.[Innova Inventory],r.[Innova Inventory Location], r.[Lot No_], r.[Location Code], r.[Reserved Against ILE] 'ILE'
Into #ResEnt
From [ffgsqltest].[PHASE2].dbo.[Phase2$Reservation Entry] r With (NOLOCK)
Group By r.[Pallet No_],r.[Source ID],r.[Innova Inventory],r.[Innova Inventory Location],r.[Lot No_],r.[Location Code],r.[Source ID],r.[Reserved Against ILE]

Update o
Set 
QtyDiff=o.Qty-IsNull(r.[Case Qty_],0),
WgtDiff=(o.Qty*IsNull(NavDesWgt,(o.Wgt/o.Qty)))-CASE WHEN IsNull(r.[Quantity],0) < 0 THEN (IsNull(r.[Quantity],0)*-1) ELSE (IsNull(r.[Quantity],0)) END
FROM tblHROrders o With (NoLock)
Left Join #ResEnt r  With (NoLock) On 
o.NavLotNo COLLATE DATABASE_DEFAULT = r.[Lot No_] And
o.SSite COLLATE DATABASE_DEFAULT = r.[Location Code] And
o.NavSalesOrder COLLATE DATABASE_DEFAULT = r.[Source ID]
	

Update tblHROrders Set WgtDiff=QtyDiff*NavDesWgt
Update tblHROrders Set WgtDiff=Round(WgtDiff,3)+0.005 Where Right(Cast(Cast(FLOOR((Round(wgtdiff,3) - FLOOR(Round(wgtdiff,3))) * 1000) As Float) As NVarChar(25)),2) = '55'
Update tblHROrders Set WgtDiff=Round(WgtDiff,2)

Update tblHROrders Set Processed='True' Where (QtyDiff=0) --(QtyDiff=0 And WgtDiff=0) - had to remove this because of the average weight thing.  Can only use QtyDiff
OR (InventoryName Like 'DISPATCH%' OR InventoryName Like 'DESPATCH%')--Processed on NAV and Quantities are good.
OR (InventoryName Like 'READY%' OR InventoryName Like 'READY%')
OR (ProductDescription='In Production')

Update tblHROrders Set Processed='False' Where Processed Is Null
Update tblHROrders Set AddOn='False' Where AddOn Is Null
Update tblHROrders Set Processed='False' Where NOT (QtyDiff=0)
AND NOT (
(InventoryName Like 'DISPATCH%' OR InventoryName Like 'DESPATCH%')--Processed on NAV and Quantities are good.
OR (InventoryName Like 'READY%' OR InventoryName Like 'READY%')
OR (ProductDescription='In Production')
)

Drop Table #ResEnt
Drop Table #ResEnt2
GO
