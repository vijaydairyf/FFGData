SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <20/07/2017>
-- Description:	<Sales Order Detail>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_SalesOrderDetail_FMM]

--exec [dbo].[usrrep_SalesOrderDetail_FMM] 346362 , 'United Kingdom', '110323215'
	-- Add the parameters for the stored procedure here
	@OrderNo nvarchar(max),
	@BIC nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
------------------------------------------------------------------------------------------------
Declare @BICParamTable Table ( BICParaValues Nvarchar(max) )
DECLARE @SQL VARCHAR(3000)
SELECT  @SQL = 'SELECT ''' + REPLACE  (@BIC,',',''' UNION SELECT ''') + ''''

 INSERT INTO @BICParamTable																	-----Breakdown of Born In COuntry parameter
 (BICParaValues)
 EXEC (@SQL)

Select	distinct cast(pp.prday as date)  as prday
		into #tmp1
from	[FMM_innova].[dbo].proc_packs as pp
		left join [FMM_innova].[dbo].proc_materials as pm with (nolock) on pm.material = pp.material
		left join [FMM_innova].[dbo].proc_orders as po with (nolock) on po.[order] = pp.[order]
		left join [FMM_innova].[dbo].proc_lots as pl with (nolock) on pl.lot = pp.lot
		left join [FMM_innova].[dbo].base_companies as bc with (nolock) on bc.company = pl.slhouse
		left join [FMM_innova].[dbo].base_companies as bc2 with (nolock) on bc2.company = pl.customer
		left join [FMM_innova].[dbo].proc_countries as pcount with (nolock) on pcount.country = pl.brcountry
	
where	@OrderNo = po.[shname] and pcount.[name] IN ( Select BICParaValues from @BICParamTable) ;
		

DECLARE @ConCat         VARCHAR(MAX) = '';  
DECLARE @SampleTable    TABLE
    (
        Value   VARCHAR(MAX)
    )
;

-- Populate the sample table.
INSERT INTO @SampleTable (Value)
    
     Select prday from #tmp1

-- Concatenate the values into one string.
SELECT
    @ConCat = @ConCat + Value + ', '
FROM
    @SampleTable
;
------------------------------------------------------------------------------------------------------------------- Distinct PRdays on one line

Select	distinct pm.description1 as prday
		into #tmp2
from	[FMM_innova].[dbo].proc_packs as pp
		left join [FMM_innova].[dbo].proc_materials as pm with (nolock) on pm.material = pp.material
		left join [FMM_innova].[dbo].proc_orders as po with (nolock) on po.[order] = pp.[order]
		left join [FMM_innova].[dbo].proc_lots as pl with (nolock) on pl.lot = pp.lot
		left join [FMM_innova].[dbo].base_companies as bc with (nolock) on bc.company = pl.slhouse
		left join [FMM_innova].[dbo].base_companies as bc2 with (nolock) on bc2.company = pl.customer
		left join [FMM_innova].[dbo].proc_countries as pcount with (nolock) on pcount.country = pl.brcountry

where	@OrderNo = po.[shname] and pcount.[name] IN ( Select BICParaValues from @BICParamTable) ;
		

DECLARE @ConCat2         VARCHAR(MAX) = '';  
DECLARE @SampleTable2    TABLE
    (
        Value   VARCHAR(MAX)
    )
;

-- Populate the sample table.
INSERT INTO @SampleTable2 (Value)
    
     Select prday from #tmp2

-- Concatenate the values into one string.
SELECT
    @ConCat2 = @ConCat2 + Value + ', '
FROM
    @SampleTable2
;
------------------------------------------------------------------------------------------------------------------- Distinct Description on one line

Select	distinct cast (pp.expire2 as date) as killday
		into #tmp3
from	[FMM_innova].[dbo].proc_packs as pp
		left join [FMM_innova].[dbo].proc_materials as pm with (nolock) on pm.material = pp.material
		left join [FMM_innova].[dbo].proc_orders as po with (nolock) on po.[order] = pp.[order]
		left join [FMM_innova].[dbo].proc_lots as pl with (nolock) on pl.lot = pp.lot
		left join [FMM_innova].[dbo].base_companies as bc with (nolock) on bc.company = pl.slhouse
		left join [FMM_innova].[dbo].base_companies as bc2 with (nolock) on bc2.company = pl.customer
		left join [FMM_innova].[dbo].proc_countries as pcount with (nolock) on pcount.country = pl.brcountry

where	@OrderNo = po.[shname] and pcount.[name] IN ( Select BICParaValues from @BICParamTable) ;

DECLARE @ConCat3        VARCHAR(MAX) = '';  
DECLARE @SampleTable3    TABLE
    (
        Value   VARCHAR(MAX)
    )
;

-- Populate the sample table.
INSERT INTO @SampleTable3 (Value)
    
     Select killday from #tmp3

-- Concatenate the values into one string.
SELECT
    @ConCat3 = @ConCat3 + Value + ', '
FROM
    @SampleTable3
;
------------------------------------------------------------------------------------------------------------------- Distinct Kill Date on one line		
Select pm.code as [ProductCode], pm.description1 as [Description], pcount.[name] as Origin, bc.[name] as SLhouse, bc2.[name] as CutInHouse, Count(pm.code) as QTY, SUM(pp.nominal) as Wgt, 
case
when po.orderstatus = 1 then 'Closed'
when po.orderstatus = 2 then 'Cancelled'
when po.orderstatus = 3 then 'On Hold'
when po.orderstatus = 4 then 'Open'
when po.orderstatus = 5 then 'Complete'
when po.orderstatus = 6 then 'Complete&Closed'
when po.orderstatus = 7 then 'Dispatched'
else 'No Status'
END as orderstatus,
Substring(@ConCat,1,LEN(@Concat)-1) as PRdays, Substring(@ConCat2,1,LEN(@Concat2)-1) as Descriptions, Substring(@ConCat3,1,LEN(@ConCat3)-1) as KillDays
	from [FMM_innova].[dbo].proc_packs as pp
	left join [FMM_innova].[dbo].proc_materials as pm with (nolock) on pm.material = pp.material
	left join [FMM_innova].[dbo].proc_orders as po with (nolock) on po.[order] = pp.[order]
	left join [FMM_innova].[dbo].proc_lots as pl with (nolock) on pl.lot = pp.lot
	left join [FMM_innova].[dbo].base_companies as bc with (nolock) on bc.company = pl.slhouse
	left join [FMM_innova].[dbo].base_companies as bc2 with (nolock) on bc2.company = pl.customer
	left join [FMM_innova].[dbo].proc_countries as pcount with (nolock) on pcount.country = pl.brcountry

	where po.[shname] = @OrderNo   and  pcount.[name] IN ( Select BICParaValues from @BICParamTable)
	group by pm.code, pm.description1, pcount.[name], bc.[name], bc2.[name], po.orderstatus


	

END

GO
