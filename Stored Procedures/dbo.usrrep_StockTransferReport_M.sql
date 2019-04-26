SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [dbo].[usrrep_StockTransferReport_M] 'FI','2018-04-10 00:00:00','2018-04-10 23:59:59','0','9999','109','114'
CREATE PROCEDURE [dbo].[usrrep_StockTransferReport_M]
	@Site nvarchar(3),
	@From datetime,
	@To datetime,
	@FromProduct nvarchar(30),
	@EndProduct nvarchar(30),
	@FromInventory int,
	@ToInventory int
AS
BEGIN
	SET NOCOUNT ON;
  Declare @StockTra table(
  BaseProd nvarchar(250), BaseDescr nvarchar(250), Code nvarchar(50), desc1 nvarchar(250), Wgt decimal(18,2), Regtime datetime, extcode nvarchar(150),OrderNo nvarchar(6), PackNo nvarchar(20),
  Pathway nvarchar(150), Pallet nvarchar(20))

  if @Site = 'FO'
  begin
  insert into @StockTra
  exec [FO_Innova].[dbo].[usrrep_PackTransfer_Report2] @From,@To,@FromProduct,@EndProduct, @FromInventory, @ToInventory
  select * from @StockTra
  end

  if @Site = 'FI'
  begin 
  insert into @StockTra
  exec [FI_Innova].[dbo].[usrrep_PackTransfer_Report2] @From,@To,@FromProduct,@EndProduct, @FromInventory, @ToInventory
  select * from @StockTra
  end







END
GO
