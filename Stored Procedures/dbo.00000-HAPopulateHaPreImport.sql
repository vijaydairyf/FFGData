SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--Select * From HaPreImport

--exec [00000-HAPopulateHaPreImport] 'FFGSO316341'

--1=Closed, 2=Cancelled, 3=OnHold, 4=Open, 5=Complete, 6=Complete&Closed, 7=Dispatched.

CREATE PROCEDURE [dbo].[00000-HAPopulateHaPreImport]

@FFGSO NVarChar(50)

AS 

--Check to see status of an order before proceeding with order lines. Martin McGinn 10/12/2018
Declare @orderStatus int

Exec @orderStatus = [00000-HACheckOrderStatusVer2] @FFGSO

If @orderStatus In(6,7)
	BEGIN
		RETURN
	END
--End. Martin McGinn 10/12/2018


Delete From HaPreImport Where [Order No_] = @FFGSO

Insert Into HaPreImport
([Primary Key], [Posting Date], [Transaction Type], [Order No_], [Location Code], [Customer No_], [Customer Name], [Item No_], 
 [Line No_], [Unit Of Measure Code], [Qty_ Ordered], 
 [Weight Qty_ Ordered], ProductDescription, [No_ Of Pallets], [Delivery Date], [Delivery Time], [No_ Of Times Already Exported], 
 [Shipment Mark], [Innova Lot No_], 
 [Lot No_], [Kill Date], [Pack Date], [Use By Date], 
 DNOB, Quantity, Weight, [Innova Inventory], [Innova Inventory Location], [Message Type], 
 [Pallet No_], RetryCount, UnitTypeXfer, [Constraint], [Max Weight], ShipTo, Storage, VIP, InnovaQty, QtyDiff)

Select '1' As [Primary Key],[Posting Date],'0' As [Transaction Type],[No_] As 'Order No_', [Location Code],[Sell-to Customer No_] As 'Customer No_', 
[Bill-to Name] As 'Customer Name', o.ProductCode As 'Item No_', 

--o.OrderRowNo As 'Line No_',
(10000*Cast(ROW_NUMBER() OVER(partition by h.[External Document No_] order by  o.ProductCode ) As Int)) As [Line No_], 

'CASE' As 'Unit Of Measure Code',o.Qty As 'Qty_ Ordered',
o.Wgt As 'Weight Qty_ Ordered',o.ProductDescription, 0, [Posting Date], '00:00:00' As 'Delivery Time', '1' As 'No_ Of Times Already Exported',
'' As 'Shipment Mark',o.LotCode As 'Innova Lot No_','' As 'Lot No_',o.KillDate As 'KillDate',o.ProductionDate As 'Pack Date',o.UseByDate As 'Use By Date',
o.DNOB As 'DNOB',o.Qty As 'Quantity',o.Wgt As 'Weight','' As 'Innova Inventory','' As 'Innova Inventory Location','' As 'Message Type','' As 'Pallet No_',0 as 'RetryCount', 
Case When Substring(o.ProductCode,1,4)='1014' Then '6' Else '1' End AS UnitTypeXfer, '0' As 'Constraint', o.Wgt As [Max Weight], h.[Ship-to Code], 
Case When h.[Goods] = 0 TheN 'FRESH' WHEN h.[Goods] = 1 TheN 'FROZEN' WHEN h.[Goods] = 4 TheN 'FROZEN' When h.[Goods] = 0 Then 'FRESH' ELSE 'FRESH' END AS Goods,
Case When o.VIPOrder='' Then 0 Else 1 End As VIP, 0, 0

--From [ffgsqltest].[PHASE2].dbo.[Phase2$Sales Header] h
From [ffgsql01].[FFG-Production].dbo.[FFG LIVE$Sales Header] h

Inner Join tblHROrders o On h.[External Document No_]  COLLATE DATABASE_DEFAULT  = o.OrderNo  And h.[suborder] = Right(o.OrderSubNo,1)
And h.[Ship-to Code] COLLATE DATABASE_DEFAULT  =o.HRBoxNo 
And Cast (h.[Goods] AS NVarChar(50)) COLLATE DATABASE_DEFAULT  = Cast(o.InventoryName AS NVarChar(50))
And [Location Code]  COLLATE DATABASE_DEFAULT   = o.SSite

Where [Sell-to Customer No_] In('4057','2640') And [No_]=@FFGSO

order by o.ProductCode

Update h
Set h.[Line No_]=(Select Top 1 Min(hh.[Line No_]) From HaPreImport hh Where hh.[Order No_] = @FFGSO and hh.[Item No_]=h.[Item No_])
From HaPreImport h Where h.[Order No_] = @FFGSO

Update h
Set h.[Constraint]='1'
From HaPreImport h Where h.[Order No_] = @FFGSO --And h.[Location Code]='FD'
GO
