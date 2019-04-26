SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
 --exec [dbo].[usrrep_NAV_INNOVA_Compare_Master] 'FG', '2018-04-16','2018-04-16'
CREATE PROCEDURE [dbo].[usrrep_NAV_INNOVA_Compare_Master]
	@Site nvarchar(3),
	@FromDate date,
	@ToDate date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Compare TABLE (
	FullOrderNo nvarchar(15),
	InnovaOrderNo nvarchar(20),
	ProductCode nvarchar(20),
	ProductName nvarchar(250),
	InnovaQty Int,
	InnovaWgt real,
	InnovaVal real,
	MaterialType nvarchar(100),
	--BegTime datetime, 
	Customer nvarchar(250),
	NavOrderNo nvarchar(9),
	NavProd nvarchar(15),
	NavDesc nvarchar(250),
	OrderedQty int,
	NavWgt real,
	InfoSource nvarchar(150),
	Amount real,
	ProductGrp nvarchar(50),
	BillTo nvarchar(250)
	--SiteCode nvarchar(20)
	)
	
	IF @Site = 'FO'
	Begin
	Insert into @Compare
	EXEC [FFGSQL03].Innova.[dbo].[usrrep_NAV_INNOVA_Compare_Rpt] @FromDate, @ToDate
	Select * from @Compare
	End

	IF @Site = 'FI'
	Begin
	Insert into @Compare
	EXEC [FFGSQL03].FI_Innova.[dbo].[usrrep_NAV_INNOVA_Compare_Rpt] @FromDate, @ToDate
	Select * from @Compare
	End

	IF @Site = 'FG'
	Begin
	Insert into @Compare
	EXEC [FFGSQL03].[FG_Innova].[dbo].[usrrep_NAV_INNOVA_Compare_Rpt] @FromDate, @ToDate
	Select * from @Compare
	End



END
GO
