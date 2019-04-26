SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe Maguire>
-- Create date: <Create Date,,07/12/17>
-- Description:	<Description,,Master sp to group delivery note summary reports for FH,FC,FD,FO,FI and FG>
-- =============================================

--exec[usrrep_DeliveryNoteSummary_MASTER]'fg','289223'
CREATE PROCEDURE [dbo].[usrrep_DeliveryNoteSummary_MASTER]
	-- Add the parameters for the stored procedure here
	@Site nvarchar(3),
	@OrderNo nvarchar(12)
AS
BEGIN
	DECLARE @DeliveryNoteSummary table(
	ShipmentId nvarchar(15),
	Shipment nvarchar(25),
	ShipDate nvarchar(25),
	fixedcode nvarchar(15),
	[Name] nvarchar(80),
	address1 nvarchar(80),
	address2 nvarchar(80),
	city nvarchar(50),
	postcode nvarchar(25),
	Pallet nvarchar(20),
	Base nvarchar(20),
	BaseName nvarchar(60),
	Product nvarchar(80),
	[Description] nvarchar(80),
	PalletType nvarchar(80),
	Boxno nvarchar(50),
	[weight] decimal(10,2),
	tare decimal(18,2),
	gross decimal(10,2),
	expire1 datetime,
	TrayType nvarchar(50),
	Chep int, 
	White int,
	Euro int,
	Plastic int,
	Rack int,
	[None] int,
	Asda int, 
	Linpac int,
	Green int, 
	Mustard int, 
	Cardboard int,
	ChepTray int, 
	[Not] int,
	PalletTare decimal(10,1),
	[Status] int
	)

    -- Insert statements for procedure here
	if @Site = 'FO'
		
		begin
		insert into @DeliveryNoteSummary
		EXEC FFGSQL03.[FO_Innova].[dbo].[usrrep_DeliveryNote_Summary_new] @OrderNo
		Select * from @DeliveryNoteSummary
		end

	if @Site = 'FD'
		
		begin
		insert into @DeliveryNoteSummary
		EXEC FFGSQL03.[FD_Innova].[dbo].[usrrep_DeliveryNote_Summary_NEW]  @OrderNo
		Select * from @DeliveryNoteSummary
		end

	if @Site = 'FG'
		
		begin 
		insert into @DeliveryNoteSummary
		EXEC FFGSQL03.[FG_innova].[dbo].[usrrep_DeliveryNote_Summary_NEW] @OrderNo
		Select * from @DeliveryNoteSummary
		end 

	if @Site = 'FC'
		
		begin 
		insert into @DeliveryNoteSummary
		EXEC FFGSQL03.[FM_Innova].[dbo].[usrrep_DeliveryNote_Summary_NEW]  @OrderNo
		select * from @DeliveryNoteSummary
		End

	if @Site = 'FH'

		begin
		insert into @DeliveryNoteSummary
		EXEC FFGSQL03.[FH_innova].[dbo].[usrrep_Delivery_Summary_NEW]  @OrderNo
		select * from @DeliveryNoteSummary
		end

	if @Site = 'FMM'

		begin
		insert into @DeliveryNoteSummary
		EXEC FFGSQL03.[FMM_innova].[dbo].[usrrep_DeliveryNote_Summary_2]  @OrderNo
		select * from @DeliveryNoteSummary
		end

	if @Site = 'FI'

		begin 
		insert into @DeliveryNoteSummary
		EXEC FFGSQL03.[FI_Innova].[dbo].[usrrep_DeliveryNote_Summary_new]  @OrderNo
		select * from @DeliveryNoteSummary
		end



END
GO
