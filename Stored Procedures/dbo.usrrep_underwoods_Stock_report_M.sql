SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--[dbo].[usrrep_underwoods_Stock_report_M] 'Stamped','FG'
CREATE PROCEDURE [dbo].[usrrep_underwoods_Stock_report_M]
	-- Add the parameters for the stored procedure here
	@Status nvarchar(25)
	,@Site nvarchar(3)
AS
BEGIN


Declare @stock table(
[Status] nvarchar(20),
Wgt decimal(18,2),
Qty int, 
PalletNo nvarchar(10),
Product nvarchar(200),
ProductCode nvarchar(12),
OrgSite nvarchar(25),
CurrentSite nvarchar(25),
Val decimal(18,2),
StoredIn nvarchar(250)
)

insert into @stock
exec FD_Innova.[dbo].[usrrep_underwoods_stock_rpt] 
insert into @stock
exec FM_Innova.[dbo].[usrrep_underwoods_stock_rpt] 
insert into @stock
exec FO_Innova.[dbo].[usrrep_underwoods_stock_rpt] 
insert into @stock
exec FH_innova.[dbo].[usrrep_underwoods_stock_rpt] 
insert into @stock
exec FG_Innova.[dbo].[usrrep_underwoods_stock_rpt] 


Select * from @stock where [Status] = @Status and CurrentSite = @Site
ORDER BY currentsite 



END
GO
