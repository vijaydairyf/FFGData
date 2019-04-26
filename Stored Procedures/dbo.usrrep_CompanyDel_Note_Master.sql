SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--exec [dbo].[usrrep_CompanyDel_Note_Master] 'FC','5126','301597'
CREATE PROCEDURE [dbo].[usrrep_CompanyDel_Note_Master]
			@DispatchSite nvarchar(3),
			@Customer nvarchar(10),
			@Order nvarchar(15)

AS
BEGIN
	
	Declare @note table(
	Quantity int,
	[Weight] decimal(18,2),
	OrderNo nvarchar(25),
	Pallet nvarchar(30),
	ProductCode nvarchar(30),
	Product nvarchar(250),
	CompanyCode nvarchar(30),
	Company nvarchar(30),
	SlaughteredIn nvarchar(20),
	BonedIn nvarchar(20),
	PackDate nvarchar(20),
	UseBy nvarchar(20),
	KillDate nvarchar(20),
	DispatchTime nvarchar(20),
	PONum nvarchar(30),
	Pieces int NULL
	)

	if @DispatchSite = 'FC'
	begin
	insert into @note
	exec [usrrep_CompanyDel_Note_FC] @Customer,@Order
	select * from @note
	end 
	
	if @DispatchSite = 'FO'
	begin
	insert into @note
	exec [usrrep_CompanyDel_Note_FO] @Customer,@Order
	select * from @note
	end 
	
	if @DispatchSite = 'FH'
	begin
	insert into @note
	exec [usrrep_CompanyDel_Note_FH] @Customer,@Order
	select * from @note
	end 

	if @DispatchSite = 'FD'
	begin
	insert into @note
	exec [usrrep_CompanyDel_Note_FD] @Customer,@Order
	select * from @note
	end 
	
	if @DispatchSite = 'FG'
	begin
	insert into @note
	exec [usrrep_CompanyDel_Note_FG] @Customer,@Order
	select * from @note
	end 
		


	--	if @DispatchSite = 'FC'
	--begin
	--insert into @note
	--exec [FM_Innova].[dbo].[usrrep_CompanyDel_Note] @Customer,@Order
	--select * from @note
	--end 
	
	--if @DispatchSite = 'FO'
	--begin
	--insert into @note
	--exec [FO_Innova].[dbo].[usrrep_CompanyDel_Note] @Customer,@Order
	--select * from @note
	--end 
	
	--if @DispatchSite = 'FH'
	--begin
	--insert into @note
	--exec [FH_Innova].[dbo].[usrrep_CompanyDel_Note] @Customer,@Order
	--select * from @note
	--end 

	--if @DispatchSite = 'FD'
	--begin
	--insert into @note
	--exec [FD_Innova].[dbo].[usrrep_CompanyDel_Note] @Customer,@Order
	--select * from @note
	--end 
	
	--if @DispatchSite = 'FG'
	--begin
	--insert into @note
	--exec [FG_Innova].[dbo].[usrrep_CompanyDel_Note] @Customer,@Order
	--select * from @note
	--end 
	


END
GO
