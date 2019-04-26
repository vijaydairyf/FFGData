SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe Maguire>
-- Create date: <Create Date,,06/09/2017>
-- Description:	<Description,,master RTS NAV Exceptions>
-- =============================================

--This works


--exec [usrep_RTS_Ex_MASTER] 
CREATE PROCEDURE [dbo].[usrep_RTS_Ex_MASTER]

--@Site as nvarchar(3)	
AS


--Create Table 
DECLARE @RTS_Table table (
		OrderNO nvarchar(20),
		OrderSite nvarchar(25)

)
		-- Foyle Omagh
	BEGIN
						--IF @Site = 'FO'
	BEGIN 
		INSERT INTO		@RTS_Table
		EXEC			[FO_Innova].[dbo].[usrep_Ready_To_Ship_Ex]	
		
	END 
		-- Foyle Donegal
						--IF @Site = 'FD'
	BEGIN
		INSERT INTO		@RTS_Table
		EXEC			[FD_Innova].[dbo].[usrep_Ready_To_Ship_Ex]	
	

	END
		-- Foyle Campsie
						--IF @Site = 'FC'
	BEGIN
		INSERT INTO		@RTS_Table
		EXEC			[FM_Innova].[dbo].[usrep_Ready_To_Ship_Ex]	
	
	END
		-- Foyle Gloucester
						--IF @Site = 'FG'
	BEGIN
		INSERT INTO		@RTS_Table
		EXEC			[FG_innova].[dbo].[usrep_Ready_To_Ship_Ex]		
	
	END
		-- Foyle 
						--IF @Site = 'FH'
	BEGIN
		INSERT INTO		@RTS_Table
		EXEC			[FH_innova].[dbo].[usrep_Ready_To_Ship_Ex]	
			
	END
		-- Foyle Ingredients
						--IF @Site = 'FI'
	BEGIN
		INSERT INTO		@RTS_Table
		EXEC			[FI_Innova].[dbo].[usrep_Ready_To_Ship_Ex]	
		
	END
		-- Foyle Melton
						--IF @Site = 'FMM'
	BEGIN
		INSERT INTO		@RTS_Table
		EXEC			[FMM_innova].[dbo].[usrep_Ready_To_Ship_Ex]	
			
	END

	Select * from @RTS_Table

END
GO
