SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kelsey Brennan>
-- Create date: <24/05/2018>
-- Description:	<Master SP for Technical Sales Order detail report >
-- =============================================
CREATE PROCEDURE [dbo].[SP_Sales_Order_Detail_Master_BI]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



   Create table #SaleOrderDetails
([Site] nvarchar (4),
[Order No] nvarchar (20),
[Product No] nvarchar (20),
[Origin] nvarchar (20),
[Description] nvarchar (MAX) ,
[Slaughter House] nvarchar (30),
[Cut in House] nvarchar (30),
[Quantity] int ,
[Weight] Decimal (18,2) ,
[Order Status] nvarchar (20),
)


Insert into #SaleOrderDetails exec	[FFGSQL03].Fm_Innova.[dbo].[SP_Sales_Order_Detail_BI] 
Insert into #SaleOrderDetails exec	[FFGSQL03].Fd_Innova.[dbo].[SP_Sales_Order_Detail_BI] 
Insert into #SaleOrderDetails exec	[FFGSQL03].Fg_Innova.[dbo].[SP_Sales_Order_Detail_BI] 
Insert into #SaleOrderDetails exec	[FFGSQL03].Fh_Innova.[dbo].[SP_Sales_Order_Detail_BI] 
Insert into #SaleOrderDetails exec	[FFGSQL03].Fi_Innova.[dbo].[SP_Sales_Order_Detail_BI] 
Insert into #SaleOrderDetails exec	[FFGSQL03].Fmm_Innova.[dbo].[SP_Sales_Order_Detail_BI] 
Insert into #SaleOrderDetails exec	[FFGSQL03].Fo_Innova.[dbo].[SP_Sales_Order_Detail_BI]

select * from #SaleOrderDetails
drop table #SaleOrderDetails
END
GO
