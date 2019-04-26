SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [00000-HAPopulateHaPreImportHeaders] '127607','1','FD'

CREATE PROCEDURE [dbo].[00000-HAPopulateHaPreImportHeaders]

@OrderNo NVarChar(Max),  
@SubOrderNo NVarChar(Max),
@FFGSite NVarChar(Max)

AS 

Insert Into HaPreImportHeader

(OrderNo, SubOrderNo, SiteID, FFGSO,OrderStatus, LastDAT,Closed)

Select @OrderNo, @SubOrderNo, @FFGSite, o.NavSalesOrder, 'IDLE', GetDate(),0
From tblHROrders o
Left Join [dbo].[HaPreImportHeader] h On o.NavSalesOrder=h.FFGSO
Where o.OrderNo=@OrderNo And Right(o.[OrderSubNo],1)=@SubOrderNo And o.SSite=@FFGSite And o.NavSalesOrder Like 'FFGSO%' And ( h.FFGSO Is Null)
Group By o.NavSalesOrder
GO
