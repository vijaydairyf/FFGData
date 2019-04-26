SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

-- EXEC [usrrep_Stock_Site_Dispatch_Master] 'FH','09/19/17','09/20/17'
CREATE PROCEDURE [dbo].[usrrep_Stock_Site_Dispatch_Master]
	-- Add the parameters for the stored procedure here
 @Site nvarchar(9),
 @BeginDate datetime, @EndDate datetime
 AS

 DECLARE @Pallets table(
 PalletNO nvarchar(12),
 OrderNO nvarchar(15),
 SendSite nvarchar(20),
 Customer nvarchar(40),
 ProductName  nvarchar(40),
 Packs int,
 TotalWGT decimal(10,2),
 ProductCode nvarchar(15),
 KillDate date,
 OrderStatus nvarchar(25)
 )

    -- Insert statements for procedure here
	if @Site = 'FO'
	Begin 
	INSERT into @Pallets
	EXEC [FO_Innova].[dbo].[usrrep_Stock_Site_Dispatch] @BeginDate,@EndDate
	Select * From @Pallets
	end 

	if @Site = 'FC'
	Begin
	INSERT into @Pallets
	EXEC [FM_Innova].[dbo].[usrrep_Stock_Site_Dispatch] @BeginDate,@EndDate
	Select * from @Pallets
	end

	if @Site = 'FD'
	Begin
	insert into @Pallets
	EXEC [FD_Innova].[dbo].[usrrep_Stock_Site_Dispatch] @BeginDate,@EndDate
	select * from @Pallets
	END 

	if @Site = 'FG'
	begin
	insert into @Pallets
	EXEC [FG_innova].[dbo].[usrrep_Stock_Site_Dispatch] @BeginDate,@EndDate
	select * from @Pallets
	END

	if @Site = 'FI'
	Begin 
	insert into @Pallets
	EXEC [FI_Innova].[dbo].[usrrep_Stock_Site_Dispatch] @BeginDate,@EndDate
	select * from @Pallets
	End

	if @Site = 'FH'
	Begin
	insert into @Pallets
	EXEC [FH_innova].[dbo].[usrrep_Stock_Site_Dispatch]@BeginDate,@EndDate
	select * from @Pallets
	END

	if @Site = 'FMM'
	Begin
	insert into @Pallets
	EXEC [FMM_innova].[dbo].[usrrep_Stock_Site_Dispatch]@BeginDate,@EndDate
	Select * from @Pallets
	End

	


		
GO
