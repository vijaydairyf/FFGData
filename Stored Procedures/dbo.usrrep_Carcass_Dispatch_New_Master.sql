SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--[dbo].[usrrep_Carcass_Dispatch_New_Master] '2018-08-06','2018-08-07','FO'

CREATE PROCEDURE [dbo].[usrrep_Carcass_Dispatch_New_Master]
@from date,
	@to date,
	@site nvarchar(4)





			AS





			BEGIN

			DECLARE @CarcDisp TABLE (

			[Site] int,
			[ItemNo] nvarchar(15),
			[Production] date,
			[Weight] decimal(18,1),
			KillNo nvarchar(10),
			OrderNo Nvarchar(50),
			Inventory nvarchar(200),
			Product nvarchar(250),
			ProductCode nvarchar(50),
			QtrCount int 

			)


			if @site = 'FO'
			Begin 
			insert into @CarcDisp
			Exec [usrrep_Carcass_Dispatch_New_FO] @from,@to
			Select * from @CarcDisp
			End

			if @site = 'FC'
			Begin 
			insert into @CarcDisp
			Exec [usrrep_Carcass_Dispatch_New_FC] @from,@to
			select * from @CarcDisp
			End

			if @site = 'FG'
			Begin 
			insert into @CarcDisp
			Exec [usrrep_Carcass_Dispatch_New_FG] @from,@to
			select * from @CarcDisp
			End


			if @site = 'FD'
			Begin 
			insert into @CarcDisp
			Exec [usrrep_Carcass_Dispatch_New_FD] @from,@to
			select * from @CarcDisp
			End


			--if @site = 'FO'
			--Begin 
			--insert into @CarcDisp
			--Exec FO_Innova.dbo.usrrep_Carcass_Dispatch_New @from,@to
			--Select * from @CarcDisp
			--End

			--if @site = 'FC'
			--Begin 
			--insert into @CarcDisp
			--Exec FM_Innova.dbo.usrrep_Carcass_Dispatch_New @from,@to
			--select * from @CarcDisp
			--End

			--if @site = 'FG'
			--Begin 
			--insert into @CarcDisp
			--Exec FG_Innova.dbo.usrrep_Carcass_Dispatch_New @from,@to
			--select * from @CarcDisp
			--End


			--if @site = 'FD'
			--Begin 
			--insert into @CarcDisp
			--Exec FD_Innova.dbo.usrrep_Carcass_Dispatch_New @from,@to
			--select * from @CarcDisp
			--End



END
GO
