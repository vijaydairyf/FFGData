SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--exec [dbo].[usrrep_CompanyDel_Note_Master_byPallet] 'FO','5126','297878'
CREATE PROCEDURE [dbo].[usrrep_CompanyDel_Note_Master_byPallet]
			@DispatchSite nvarchar(3),
			--@Customer nvarchar(10),
			--@Order nvarchar(15),
			@Pallet nvarchar(15)

AS
BEGIN
	
	Declare @note table(
	Quantity int,
	[Weight] decimal(18,2),
	Pallet nvarchar(30),
	ProductCode nvarchar(30),
	Product nvarchar(250),
	UseBy nvarchar(20),
	KillDate nvarchar(20)
	)

	if @DispatchSite = 'FC'
	begin
	insert into @note
	exec [usrrep_CompanyDel_Note_Pallet_FC] @Pallet--,@Customer,@Order,
	select * from @note
	end 
	
	if @DispatchSite = 'FO'
	begin
	insert into @note
	exec [usrrep_CompanyDel_Note_Pallet_FO] @Pallet--,@Customer,@Order,
	select * from @note
	end 
	
	if @DispatchSite = 'FH'
	begin
	insert into @note
	exec [usrrep_CompanyDel_Note_Pallet_FH] @Pallet--,@Customer,@Order,t
	select * from @note
	end 

	if @DispatchSite = 'FD'
	begin
	insert into @note
	exec [usrrep_CompanyDel_Note_Pallet_FD] @Pallet--,@Customer,@Order,
	select * from @note
	end 
	
	if @DispatchSite = 'FG'
	begin
	insert into @note
	exec [usrrep_CompanyDel_Note_Pallet_FG] @Pallet--,@Customer,@Order,
	select * from @note
	end 
		
	

	
	--if @DispatchSite = 'FC'
	--begin
	--insert into @note
	--exec [FM_Innova].[dbo].[usrrep_CompanyDel_Note_Pallet] @Pallet--,@Customer,@Order,
	--select * from @note
	--end 
	
	--if @DispatchSite = 'FO'
	--begin
	--insert into @note
	--exec [FO_Innova].[dbo].[usrrep_CompanyDel_Note_Pallet] @Pallet--,@Customer,@Order,
	--select * from @note
	--end 
	
	--if @DispatchSite = 'FH'
	--begin
	--insert into @note
	--exec [FH_Innova].[dbo].[usrrep_CompanyDel_Note_Pallet] @Pallet--,@Customer,@Order,t
	--select * from @note
	--end 

	--if @DispatchSite = 'FD'
	--begin
	--insert into @note
	--exec [FD_Innova].[dbo].[usrrep_CompanyDel_Note_Pallet] @Pallet--,@Customer,@Order,
	--select * from @note
	--end 
	
	--if @DispatchSite = 'FG'
	--begin
	--insert into @note
	--exec [FG_Innova].[dbo].[usrrep_CompanyDel_Note_Pallet] @Pallet--,@Customer,@Order,
	--select * from @note
	--end 


END
GO
