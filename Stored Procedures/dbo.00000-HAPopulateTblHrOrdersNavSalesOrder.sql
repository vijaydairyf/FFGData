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

--exec [00000-HAPopulateTblHrOrdersNavSalesOrder] '127807','1','FD'

CREATE PROCEDURE [dbo].[00000-HAPopulateTblHrOrdersNavSalesOrder]

@OrderNo NVarChar(Max), 
@SubOrderNo NVarChar(Max), 
@FFGSite NVarChar(Max)

AS

Declare @Switch Int
Set @Switch=0 --Set to 0 if using live, 1 if using test...

If @Switch=0 
	Begin
		Update o
		Set o.NavSalesOrder = 
			(Select Top 1 h.[No_] From [ffgsql01].[FFG-Production].dbo.[FFG LIVE$Sales Header] h
			Where h.[Location Code] = @FFGSite 
			And h.[Sell-to Customer No_]='4057'
			And h.[External Document No_]=@OrderNo
			And h.SubOrder In (@SubOrderNo)
			And h.[Ship-to Code]   COLLATE DATABASE_DEFAULT  = Cast(o.HRBoxNo As NVarChar(50))
			And Cast (h.[Goods] AS NVarChar(50)) COLLATE DATABASE_DEFAULT  = Cast(o.InventoryName AS NVarChar(50)))
		From tblHROrders o
		Where o.OrderNo=@OrderNo And Right(o.OrderSubNo,1) = @SubOrderNo
		And SSite=@FFGSite
	End

If @Switch=1 
	Begin
		Update o
		Set o.NavSalesOrder = 
			(Select Top 1 h.[No_] From [ffgsqltest].[PHASE2].dbo.[Phase2$Sales Header] h
			Where h.[Location Code] = @FFGSite 
			And h.[Sell-to Customer No_]='4057'
			And h.[External Document No_]=@OrderNo
			And h.SubOrder=@SubOrderNo
			And h.[Ship-to Code]   COLLATE DATABASE_DEFAULT  = Cast(o.HRBoxNo As NVarChar(50))
			And Cast (h.[Goods] AS NVarChar(50)) COLLATE DATABASE_DEFAULT  = Cast(o.InventoryName AS NVarChar(50)))
		From tblHROrders o
		Where o.OrderNo=@OrderNo And Right(o.OrderSubNo,1)=@SubOrderNo And SSite=@FFGSite
	End
GO
