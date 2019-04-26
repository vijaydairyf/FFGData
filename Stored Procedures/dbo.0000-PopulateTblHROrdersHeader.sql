SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 19th May 2017
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [0000-PopulateTblHROrdersHeader] '119673'
CREATE PROCEDURE [dbo].[0000-PopulateTblHROrdersHeader]

--@OrderNo NVarChar(Max)

AS

Truncate Table tblHROrdersHeader

Insert Into tblHROrdersHeader

(OrderDate,GroupOrderNo,DeliveryDate,SubOrder,VIP,SiteID,NavOrderNo)

Select Top 15 Min(Convert(VarChar(10),Cast(OrderDate As smalldatetime),120)) As OrderDate, Group_Order_No As 'GroupOrderNo', Delivery_Date As 'DeliveryDate', Sub_Order_No As 'SubOrder',  Max(VIP) As VIP , SiteID, ''
From [ffgbi-serv].[ffg_dw].dbo.HR_Order_Summary_Import With (NoLock)
Where Not Box_No Is Null --And Group_Order_No=@OrderNo
Group By Group_Order_No, Delivery_Date, Sub_Order_No,  SiteID 
Having Min(Convert(VarChar(10), Cast(OrderDate As smalldatetime),120)) > GetDate()-4
Order By Group_Order_No Desc, OrderDate Desc

--Select Top 15 Convert(VarChar(10),Cast(OrderDate As smalldatetime),120) As OrderDate, Group_Order_No As 'GroupOrderNo', Delivery_Date As 'DeliveryDate', Sub_Order_No As 'SubOrder',  VIP , SiteID, ''
--From [ffgbi-serv].[ffg_dw].dbo.HR_Order_Summary_Import With (NoLock)
--Where Not Box_No Is Null --And Group_Order_No=@OrderNo
--Group By OrderDate, Group_Order_No, Delivery_Date, Sub_Order_No, VIP, SiteID 
--Order By OrderDate Desc, Group_Order_No, Sub_Order_No
GO
