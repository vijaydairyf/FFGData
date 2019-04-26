SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetNavQty]
(
		@OrderNo NVarChar(25),
		@ProductCode NVarChar(25),
		@SiteID NVarChar(25)
)
RETURNS varchar(max)
AS
BEGIN
    declare @output varchar(max)

	Declare @a Table
	(OrderNo NVarChar(50), ProductCode NVarChar(50))

	Declare @h Table
	(ffgso NVarChar(50), SiteID NVarChar(50), OrderNo NVarChar(50))
	
	Insert Into @a
	Select a.OrderNo, a.ProductCode
	From [ffgbi-serv].[ffg_dw].dbo.HR_Order_Allocation a
	Where a.OrderNo=@OrderNo
	Group By a.OrderNo, a.ProductCode

	Insert Into @h
	select * From [FFGData].[dbo].[GetFFGSO](@OrderNo) 

	select @output=Sum(L.[Ordered Qty_]) 
	From @h As H
	Left Join [ffgsql01].[FFG-PRODUCTION].dbo.[FFG LIVE$Sales Line] As L On H.ffgso collate database_default = L.[Document No_]
	Left Join @a a On h.OrderNo=a.OrderNo And L.[No_] collate database_default = a.ProductCode
	Where Len(L.[No_])=9 And L.[No_]=@ProductCode And SiteID=@SiteID

    return @output
END
GO
