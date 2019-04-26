SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[0-HAShowOrderLinesEdited]

@OrderNo NVarChar(Max),
@SubOrderNo NVarChar(Max)

AS 

SELECT  NavSalesOrder, SSite, SiteName, ProductCode, ProductDescription, 
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
SiteName As 'Stk Location', 
Cast(Sum(Qty) As Decimal(18,0)) Qty, Cast(Sum(Wgt) As Decimal(18,1)) Wgt
FROM            tblHROrders
WHERE        (OrderNo = @OrderNo) And Right(OrderSubNo,1)=@SubOrderNo AND SSite <> 'FGL'
Group By NavSalesOrder, SSite, SiteName,  InventoryName,  HRBoxNo, ProductCode, ProductDescription
Order by NavSalesOrder, HRBoxNo, InventoryName, ProductCode
GO
