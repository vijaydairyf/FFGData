SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe Maguire>
-- Create date: <Create Date,,20/02/18>
-- Description:	<Description,,group dispatch inv report for HM>
-- =============================================
-- exec [usrrep_Group_Dispatch_Report_MASTER]  'FO','2018-04-04','2018-04-04'
-- exec [usrrep_Group_Dispatch_Report_MASTER]  'Group','2018-03-28','2018-03-28'
CREATE PROCEDURE [dbo].[usrrep_Group_Dispatch_Report_MASTER] 
	-- Add the parameters for the stored procedure here
	@_Site nvarchar(10),
	@FromDate date,
	@ToDate date
AS
BEGIN
	
	Declare @data table (
	[Site] nvarchar(5),
	[Group] nvarchar(25),
	Quantity int,
	[Weight] decimal(18,2),
	Pathway nvarchar(250),
	[Day] nvarchar(50)
	--[DayNo] int

	)

	if @_Site = 'FO'

	begin 
	insert into @data
	exec [FO_Innova].[dbo].[usrrep_DispatchInventory_Rpt] @FromDate,@ToDate
	select * from @data
	--order by DayNo, [Group] asc
	end

	if @_Site = 'FC'
	begin
	insert into @data 
	exec [FM_Innova].[dbo].[usrrep_DispatchInventory_Rpt] @FromDate,@ToDate
	Select * from @data
	
	end

	if @_Site = 'FD'
	begin
	insert into @data 
	exec [FD_Innova].[dbo].[usrrep_DispatchInventory_Rpt] @FromDate,@ToDate
	Select * from @data
	end

	if @_Site = 'FG'
	begin
	insert into @data 
	exec [FG_Innova].[dbo].[usrrep_DispatchInventory_Rpt] @FromDate,@ToDate
	Select * from @data
	end

	
	if @_Site = 'FI'
	begin
	insert into @data 
	exec [FI_Innova].[dbo].[usrrep_DispatchInventory_Rpt] @FromDate,@ToDate
	Select * from @data
	end

	--if @_Site = 'Group'
	--begin 
	--insert into @data
	--exec [FD_Innova].[dbo].[usrrep_DispatchInventory_Rpt] @FromDate,@ToDate

	--insert into @data
	--exec [FM_Innova].[dbo].[usrrep_DispatchInventory_Rpt] @FromDate,@ToDate

	--insert into @data
 --   exec [FO_Innova].[dbo].[usrrep_DispatchInventory_Rpt] @FromDate,@ToDate

	--insert into @data 
	--exec [FG_Innova].[dbo].[usrrep_DispatchInventory_Rpt] @FromDate,@ToDate

	--insert into @data
	--exec [FI_Innova].[dbo].[usrrep_DispatchInventory_Rpt] @FromDate,@ToDate
	--select * from @data
	--end
		

END
GO
