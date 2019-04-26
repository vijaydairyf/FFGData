SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--EXEC [Group_order_returns_Master] 'FO','11/20/2017','11/27/2017'
CREATE PROCEDURE [dbo].[Group_order_returns_Master]
@Site nvarchar(4),
@StartDate datetime,
@EndDate datetime

AS
BEGIN
DECLARE @OrderReturns Table (
ReturnType nvarchar(80),
Product nvarchar(80),
[Name] nvarchar(100),
Qty int,
Wgt float, 
OrderNumber nvarchar(15),
Customer nvarchar(100),
Dispatched nvarchar(50), 
PO int,
FromOrderTime nvarchar(50),
Lot int,
productlot nvarchar(30)
)
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if @Site = 'FO'
	Begin 
	--insert into @OrderReturns 
	EXEC [OMASQL01].[Innova].[dbo].[usrrep_OrderReturns] @StartDate, @EndDate
	End

	if @Site = 'FD'
	Begin
	--	insert into @OrderReturns 
	EXEC [DONSQL01].[Innova].[dbo].[usrrep_OrderReturns] @StartDate, @EndDate
	End

	if @Site = 'FC'
	Begin
		--insert into @OrderReturns 
	EXEC [CAMSQL01].[Innova].[dbo].[usrrep_OrdersReturn] @StartDate, @EndDate
    End

	if @Site = 'FI'
	Begin
		--insert into @OrderReturns 
	EXEC [INGSQL01].[FI_Innova].[dbo].[usrrep_OrderReturns] @StartDate, @EndDate
	End

	if @Site = 'FH'
	Begin 
		--insert into @OrderReturns 
	EXEC [CKTSQL01].[Innova].[dbo].[usrrep_OrderReturns] @StartDate, @EndDate
	End

	if @Site = 'FMM'
	Begin 
		--insert into @OrderReturns 
	EXEC [MELSQL01].[Innova].[dbo].[usrrep_OrderReturns] @StartDate, @EndDate
	End
	
	if @Site = 'FG'
	Begin 
	--	insert into @OrderReturns 
	EXEC [GLOSQL01].[Innova].[dbo].[usrrep_OrderReturns] @StartDate, @EndDate
	End
END
GO
