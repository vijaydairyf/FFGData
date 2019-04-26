SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <24/07/2017>
-- Description:	<Group Picklist Report>
-- =============================================
Create PROCEDURE [dbo].[usrrep_GroupOrderPicklist_FH]

--exec [dbo].[usrrep_GroupOrderPicklist] '269167'

	-- Add the parameters for the stored procedure here
	@OrderNo nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

Declare @OrderNoParamTable Table ( OrderNoParaValues Nvarchar(max) )
DECLARE @SQL VARCHAR(MAX)
SELECT  @SQL = 'SELECT ''' + REPLACE  (@OrderNo,',',''' UNION SELECT ''') + ''''

 INSERT INTO @OrderNoParamTable																-----Breakdown of Order parameter
 (OrderNoParaValues)
 EXEC (@SQL)

--Select * from @OrderNoParamTable

IF OBJECT_ID('table5', 'U') IS NOT NULL 
	BEGIN
		DROP TABLE table5; 
	END

Create Table table5(  OrderNo nvarchar(max),ProductCode nvarchar(10), ProductDescription nvarchar(max), PackDate datetime, UseBy Datetime, DNOB Datetime, 
					KillDate datetime, Lot nvarchar(15), Inventory nvarchar(30), InvLocation nvarchar(30), Pallet nvarchar(10),
					QTY bigint)

While EXISTS ( Select 1 from @OrderNoParamTable)
Begin
		Select TOP 1 @OrderNo = OrderNoParaValues from @OrderNoParamTable
		
Declare @maxorderlines int, @orderline int

Select @maxorderlines  =  COUNT(pol.id)
					from [FH_innova].[dbo].proc_orderl pol
					left join [FH_innova].[dbo].proc_orders as po with (nolock) on po.[order] = pol.[order]
					where po.[name] = @OrderNo and pol.description4 <> '1'

Set @orderline = 0
--


Declare @Sequence bigint

Select TOP 1 @Sequence =  CAST(pl.description7 as int) from [FH_innova].[dbo].proc_orderl as pl 
						  left join [FH_innova].[dbo].proc_orders as po with (nolock) on po.[order] = pl.[order] 
						  where po.[name] = @OrderNo and pl.description4 <> '1'
						  order by CAST(pl.description7 as int) asc



while (@orderline<@maxorderlines)

BEGIN	

		
Declare @Order nvarchar(max),@ProductCode nvarchar (15), @ProductDescription nvarchar (max), @PrdayMax datetime, @PrdayMin datetime, @UsebyMax datetime, @UsebyMin datetime, @DNOBMax datetime, @DNOBMin datetime,
			@ValLots nvarchar (max), @KillDateMin datetime, @KillDateMax datetime, @constraint nvarchar(5)

	
	Select 	@Order = po.[name], @ProductCode = pm.code, @ProductDescription = pm.description1 , @PrdayMax = pol.prdaymax, @PrdayMin = pol.prdaymin, @UsebyMax =	pol.expire1max, @UsebyMin =	pol.expire1min,
			@DNOBMax = pol.expire3max, @DNOBMin = pol.expire3min, @ValLots = pol.ValidLots, @KillDateMin = pol.expire2min , @KillDateMax = pol.expire2max, @constraint = ISNULL(substring(pol.description6,1,1),0)
			
			from [FH_innova].[dbo].proc_orderl as pol (nolock)
			left join [FH_innova].[dbo].proc_orders as po with (nolock) on po.[order] = pol.[order]
			left join [FH_innova].[dbo].proc_materials as pm with (nolock) on pm.material = pol.material
			where po.[name] = @OrderNo and pol.description7 = @Sequence and pol.description4 <> '1'
			
			Print @constraint
			Print @vallots


		IF @constraint = '0' or @constraint = '3'  --NONE and ALL
--------------------------------------------------------------------------------------------------------------------------------------------------------
		Begin
		INSERT into table5
		
		
		   Select @order as [OrderNo], pm.code as ProductCode,pm.description1 as ProductDescription, pp.prday as PackDate, pp.expire1 as UseBy, 
			pp.expire3  as DNOB, pp.expire2 as KillDate,
			pl.code as Lot, pr.[name] as Inventory, 
			ISNULL(invl.code, '') as InvLocation, ISNULL(pc.number,'') as Pallet, COUNT(pp.number) as QTY
		
	from [FH_innova].[dbo].proc_packs as pp (nolock)
	left join [FH_innova].[dbo].proc_materials as pm with (nolock) on pp.material = pm.material
	left join [FH_innova].[dbo].proc_lots as pl with (nolock) on pl.lot = pp.lot
	left join [FH_innova].[dbo].proc_prunits as pr with (nolock) on pr.prunit = pp.inventory
	left join [FH_innova].[dbo].proc_invlocations as invl with (nolock) on invl.id = pp.invlocation
	left join [FH_innova].[dbo].proc_collections as pc with (nolock) on pc.id = pp.pallet


	where	pr.description2 = 'STOCK' and pr.[name] <> 'Ready to Ship'
			AND	pm.code = @ProductCode
			AND pm.description1 = @ProductDescription
			AND (pp.prday BETWEEN @PrdayMin and @PrdayMax)
			AND (pp.expire1 BETWEEN @UsebyMin and @UsebyMax)
			and (pp.expire2 BETWEEN @KillDateMin and @KillDateMax)
			AND (ISNULL(pp.expire3,'') BETWEEN ISNULL(@DNOBMin,'') and ISNULL(@DNOBMax,''))
			AND pl.code = @ValLots
			


			group by pm.code, pm.description1, pp.prday, pp.expire1, pp.expire3, pl.code, pr.[name], invl.code, pc.number, pp.expire2

			SET @Sequence = @Sequence + 1
			

			SET @orderline = @orderline + 1

	END
--------------------------------------------------------------------------------------------------------------------------------------------------------	

	IF @constraint = '1'  --DATES
----------------------------------------------------------------------------------------------------------------------------------------------------------
		Begin
		INSERT into table5
		
		
		   Select @order as [OrderNo], pm.code as ProductCode,pm.description1 as ProductDescription, pp.prday as PackDate, pp.expire1 as UseBy, 
			pp.expire3  as DNOB, pp.expire2 as KillDate,
			pl.code as Lot, pr.[name] as Inventory, 
			ISNULL(invl.code, '') as InvLocation, ISNULL(pc.number,'') as Pallet, COUNT(pp.number) as QTY
			
	
	from [FH_innova].[dbo].proc_packs as pp (nolock)
	left join [FH_innova].[dbo].proc_materials as pm with (nolock) on pp.material = pm.material
	left join [FH_innova].[dbo].proc_lots as pl with (nolock) on pl.lot = pp.lot
	left join [FH_innova].[dbo].proc_prunits as pr with (nolock) on pr.prunit = pp.inventory
	left join [FH_innova].[dbo].proc_invlocations as invl with (nolock) on invl.id = pp.invlocation
	left join [FH_innova].[dbo].proc_collections as pc with (nolock) on pc.id = pp.pallet


	where	pr.description2 = 'STOCK' and pr.[name] <> 'Ready to Ship'
			AND	pm.code = @ProductCode
			AND pm.description1 = @ProductDescription
			AND (pp.prday BETWEEN @PrdayMin and @PrdayMax)
			AND (pp.expire1 BETWEEN @UsebyMin and @UsebyMax)
			and (pp.expire2 BETWEEN @KillDateMin and @KillDateMax)
			AND (ISNULL(pp.expire3,'') BETWEEN ISNULL(@DNOBMin,'') and ISNULL(@DNOBMax,''))
			--AND pl.code = @ValLots -- REMOVED AS ONLY DATES REQUIRED
			


			group by pm.code, pm.description1, pp.prday, pp.expire1, pp.expire3, pp.expire2, pr.[name], invl.code, pc.number, pl.code

			SET @Sequence = @Sequence + 1
			

			SET @orderline = @orderline + 1

	END
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
		IF @constraint = '2'  --Lots
----------------------------------------------------------------------------------------------------------------------------------------------------------
		Begin
		INSERT into table5
		
		
		   Select @order as [OrderNo], pm.code as ProductCode,pm.description1 as ProductDescription, pp.prday as PackDate, pp.expire1 as UseBy, 
			pp.expire3  as DNOB, pp.expire2 as KillDate,
			pl.code as Lot, pr.[name] as Inventory, 
			ISNULL(invl.code, '') as InvLocation, ISNULL(pc.number,'') as Pallet, COUNT(pp.number) as QTY
			--,(select (pol.maxamount - pol.curamount) from proc_orderl pol left join proc_orders as po with (nolock) on po.[order] = pol.[order]
			--		where po.[shname] = @OrderNo and pol.description7 = @Sequence)
	
	from [FH_innova].[dbo].proc_packs as pp (nolock)
	left join [FH_innova].[dbo].proc_materials as pm with (nolock) on pp.material = pm.material
	left join [FH_innova].[dbo].proc_lots as pl with (nolock) on pl.lot = pp.lot
	left join [FH_innova].[dbo].proc_prunits as pr with (nolock) on pr.prunit = pp.inventory
	left join [FH_innova].[dbo].proc_invlocations as invl with (nolock) on invl.id = pp.invlocation
	left join [FH_innova].[dbo].proc_collections as pc with (nolock) on pc.id = pp.pallet


	where	pr.description2 = 'STOCK' and pr.[name] <> 'Ready to Ship'
			AND	pm.code = @ProductCode
			AND pm.description1 = @ProductDescription
			--AND (pp.prday BETWEEN @PrdayMin and @PrdayMax)
			--AND (pp.expire1 BETWEEN @UsebyMin and @UsebyMax)			-- Removed as Lot only required
			--and (pp.expire2 BETWEEN @KillDateMin and @KillDateMax)
			--AND (ISNULL(pp.expire3,'') BETWEEN ISNULL(@DNOBMin,'') and ISNULL(@DNOBMax,''))
			AND pl.code = @ValLots 
			


			group by pm.code, pm.description1, pp.prday, pp.expire1, pp.expire3, pl.code, pr.[name], invl.code, pc.number, pp.expire2

			SET @Sequence = @Sequence + 1
			

			SET @orderline = @orderline + 1

	END
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	END
			

			Delete TOP (1)
		from @OrderNoParamTable
END	

			Select OrderNo, ProductCode, ProductDescription, PackDate, UseBy, DNOB, KillDate, Lot, Inventory, InvLocation, Pallet, QTY 
			from table5
			group by OrderNo, ProductCode, ProductDescription, PackDate, UseBy, DNOB, KillDate, Lot, Inventory, InvLocation, Pallet, QTY 
			drop table table5
			
END
GO
