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

--exec [00000-HAShowOrderHeaders]  '127683', '1'
 
CREATE PROCEDURE [dbo].[00000-HAShowOrderHeaders]

@OrderNo NVarChar(Max),
@SubOrderNo NVarChar(Max)

AS 

SELECT  OrderNo, Right(OrderSubNo,1) As 'SubOrder', SSite As 'Site', NavSalesOrder, Min(ProductCode) As 'Starting Code', 
Sum(Qty) Qty,  

SiteName As 'Stk Location', 
Case 
When InventoryName = '0' Then 'Chilled'
When InventoryName = '1' Then 'Frozen'
When InventoryName = '2' Then 'Ambient'
When InventoryName = '3' Then 'VIP Chilled'
When InventoryName = '4' Then 'ViP Frozen'
When InventoryName = '5' Then 'Trailer Hire'
When InventoryName = '6' Then 'Chilled ECS'
When InventoryName = '7' Then 'Frozen ECS'
Else 'Unknown' End As Goods,
HRBoxNo As 'Ship-to Code',
Case When Sum(Qty)<45 Then 1 Else CEILING(Round(Sum(Qty)/45,1)) End As 'No. of Pallets',
IsNull(NavLocation,'IDLE') As 'OrderStatus'
FROM            tblHROrders
WHERE        ( OrderNo = @OrderNo ) And Right(OrderSubNo,1)=@SubOrderNo
Group By SSite, OrderNo, OrderSubNo, NavSalesOrder,  SiteName, InventoryName, HRBoxNo, NavLocation
ORDER BY NavSalesOrder
GO
