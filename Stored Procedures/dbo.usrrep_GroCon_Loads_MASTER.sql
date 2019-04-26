SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [dbo].[usrrep_GroCon_Loads_MASTER] 'FMM','Wednesday'
CREATE PROCEDURE [dbo].[usrrep_GroCon_Loads_MASTER]
	-- Add the parameters for the stored procedure here
	 @Site nvarchar(3),
	 @Load nvarchar(15)
AS
BEGIN

declare @intra table (Qty int, code nvarchar(12), productdesc nvarchar(250), wgt decimal(18,2), codeExists int, NoOfPallets int)

if @site = 'FG'
begin 
insert into @intra
exec  FG_Innova.[dbo].[usrrep_GroCon_Loads] @Load
Select * from @intra
end

if @site = 'FMM'
begin 
insert into @intra
exec  FMM_Innova.[dbo].[usrrep_GroCon_Loads] @Load
Select * from @intra
end



END
GO
