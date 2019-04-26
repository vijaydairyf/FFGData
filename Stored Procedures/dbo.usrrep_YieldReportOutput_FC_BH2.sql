SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <12/07/2017>
-- Description:	<Standard Yeild Report>
-- =============================================
--exec [usrrep_YieldReportOutput_FC_BH2] '12/03/2018','12/03/2018','131611101011,131311101111,1313111010111,111111101011,111111101012,111111101022,121211181111,121211181135,131111101012,131111111012,141111101012',0,99999
CREATE PROCEDURE [dbo].[usrrep_YieldReportOutput_FC_BH2]

--Input Variables
@BeginDate datetime,
@EndDate datetime,
@_Lots nvarchar(max),
@FromBatch int,
@ToBatch int
--

AS 
-- spliting the lots out from string 
Declare @LotNames nvarchar(max)
select @LotNames = COALESCE(@LotNames + ' || ', '') + CAST(Name AS VARCHAR)
from [FM_Innova].[dbo].Proc_Lots
Inner JOIN [dbo].[Split](@_Lots, ',') As S on proc_lots.code collate database_default = S.Item

BEGIN

Create Table tbl4 (code nvarchar(20), [name] nvarchar(100), [site] nvarchar(10), PackNumber nvarchar(20), [Weight] decimal(18,3), QTY int,
					PIECES int, name2 nvarchar(100), Orderby nvarchar(10), ValuePerKg decimal(18,3), description3 nvarchar(100), RMTT nvarchar(5), fabcode3 nvarchar(20))
/* Output Yield report 8 */
Declare @frozenwgt decimal (18,3)
Declare @redmeat decimal (18,3)
	
INSERT INTO  tbl4
Select	pm.code, pm.[name],pp.[site], pp.number as PackNumber,
CAST(pp.[weight] AS Decimal(18,3)) AS [Weight],
COUNT(pm.code) AS QTY,
 pp.pieces AS PIECES, pm2.[name] as name2, pm2.extcode AS Orderby, pm.[value] as ValuePerKg, pru.description3, pm2.dimension3, pm.fabcode3

	
from [FM_Innova].[dbo].proc_packs AS PP
LEFT JOIN [FM_Innova].[dbo].proc_prunits AS pru with (nolock) on pru.prunit = pp.inventory
LEFT JOIN [FM_Innova].[dbo].proc_lots AS pl with (nolock) on pl.lot = pp.lot
LEFT JOIN [FM_Innova].[dbo].proc_materials AS pm with (nolock) on pm.material = pp.material
LEFT JOIN [FM_Innova].[dbo].proc_materialtypes AS pm2 with (nolock) on pm2.materialtype = pm.materialtype
left join [FM_Innova].[dbo].proc_pos as pos with (nolock) on pos.po = PP.po
left join [FM_Innova].[dbo].[proc_rmareas] as rma with (nolock) on rma.rmarea = PP.rmarea -- added by kh 16/11/18 for Into BH stamp
INNER JOIN [dbo].[Split](@_Lots, ',') As S on pl.code collate database_default = S.Item

where	(CAST(pp.prday AS DATE) BETWEEN @BeginDate and @EndDate) --OR (CAST(pp.[invtime] AS date) BETWEEN @BeginDate and @EndDate AND pru.description3 = 'NegativeYield'))
		AND (pos.[name] = 'Into B/H Yield 2' or rma.[name] = 'Into B/H Yield 2')
		AND ISNULL(pru.description3,0) <> 'NSNY'
		AND pp.rtype = '1'
		AND pl.dimension1 = '1'
		AND isnull(PP.Batch,0) between @FromBatch and @ToBatch  
		
		

group by pm.code, pm.[name], pp.[site],pm2.[name], pru.description3,CAST(pp.[invtime] AS DATE), pm2.extcode, pm.[value], PP.[weight], PP.pieces,pru.description3,pp.number, pm2.dimension3, pm.fabcode3

INSERT INTO  tbl4
Select	pm.code, pm.[name],pp.[site], pp.number as PackNumber,
CASE WHEN (pru.description3 = 'NegativeYield' AND CAST(pp.[invtime] AS DATE) BETWEEN @BeginDate and @EndDate ) 
	THEN  (0 - CAST(pp.[weight] AS Decimal(18,3))  )else  CAST(pp.[weight] AS Decimal(10,2)) end  AS [Weight],
CASE WHEN (pru.description3 = 'NegativeYield' AND CAST(pp.[invtime] AS DATE) BETWEEN @BeginDate and @EndDate) 
	THEN (0 - COUNT(pm.code)) else  COUNT(pm.code) end  AS QTY,
 pp.pieces AS PIECES, pm2.[name] as name2, pm2.extcode AS Orderby, pm.[value] as ValuePerKg, pru.description3,
 pm2.dimension3,
  pm.fabcode3

	
from [FM_Innova].[dbo].proc_packs AS PP
LEFT JOIN [FM_Innova].[dbo].proc_prunits AS pru with (nolock) on pru.prunit = pp.inventory
LEFT JOIN [FM_Innova].[dbo].proc_lots AS pl with (nolock) on pl.lot = pp.lot
LEFT JOIN [FM_Innova].[dbo].proc_materials AS pm with (nolock) on pm.material = pp.material
LEFT JOIN [FM_Innova].[dbo].proc_materialtypes AS pm2 with (nolock) on pm2.materialtype = pm.materialtype
left join [FM_Innova].[dbo].proc_pos as pos with (nolock) on pos.po = PP.po
left join [FM_Innova].[dbo].[proc_rmareas] as rma with (nolock) on rma.rmarea = PP.rmarea -- added by kh 16/11/18 for Into BH stamp
INNER JOIN [dbo].[Split](@_Lots, ',') As S on pl.code collate database_default = S.Item

where	--(CAST(pp.prday AS DATE) BETWEEN @BeginDate and @EndDate 
		(CAST(pp.[invtime] AS date) BETWEEN @BeginDate and @EndDate AND pru.description3 = 'NegativeYield')
		AND (pp.porder IS NOT NULL OR isnull(pp.po,0) = 81190) --1 = Standard packing
		AND ISNULL(pru.description3,0) <> 'NSNY'
		AND pp.rtype = '1'
		AND pl.dimension1 = '1'
		AND isnull(PP.Batch,0) between @FromBatch and @ToBatch 
		AND (pos.[name] = 'Into B/H Yield 2' or rma.[name] = 'Into B/H Yield 2')

	group by pm.code, pm.[name], pp.[site],pm2.[name], pru.description3,CAST(pp.[invtime] AS DATE), pm2.extcode, pm.[value], PP.[weight], PP.pieces,pru.description3,pp.number , pm2.dimension3, pm.fabcode3

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Insert into tbl4
--Select	pm.code, pm.[name],it.[site], it.number as PackNumber,
--CAST(it.[weight] AS Decimal(10,2)) AS [Weight],
--COUNT(pm.code) AS QTY,
-- it.pieces AS PIECES, pm2.[name] as name2, pm2.extcode AS Orderby, pm.[value] as ValuePerKg, pru.description3, pm2.dimension3, pm.fabcode3

--from [FM_Innova].[dbo].proc_items as it (nolock)
--LEFT JOIN [FM_Innova].[dbo].proc_prunits AS pru with (nolock) on pru.prunit = it.inventory
--LEFT JOIN [FM_Innova].[dbo].proc_lots AS pl with (nolock) on pl.lot = it.lot
--LEFT JOIN [FM_Innova].[dbo].proc_materials AS pm with (nolock) on pm.material = it.material
--LEFT JOIN [FM_Innova].[dbo].proc_materialtypes AS pm2 with (nolock) on pm2.materialtype = pm.materialtype
----left join [FM_Innova].[dbo].proc_pos as pos with (nolock) on pos.po = it.po
----left join [FM_Innova].[dbo].[proc_rmareas] as rma with (nolock) on rma.rmarea = it.rmarea -- added by kh 16/11/18 for Into BH stamp
--INNER JOIN [dbo].[Split](@_Lots, ',') As S on pl.code collate database_default = S.Item

--WHERE  
--						(pm.code In('701410979','701410986','701410317','701410300','101410967','101411317'))
--						and (it.rtype != 4)  
--						AND (CONVERT(nvarchar(10), it.prday, 102) BETWEEN CONVERT(nvarchar(10), @BeginDate, 102) AND CONVERT(nvarchar(10), @EndDate,  102)) 
--						and isnull(it.Batch,0) between @FromBatch and @ToBatch 
--						--AND (pos.[name] = 'Into B/H Yield2' or rma.[name] = 'Into B/H Yield2')

--		group by pm.code, pm.[name], it.number, it.pieces, pm2.[name], pm2.extcode, pm.[value], pru.description3, pm2.dimension3, pm.fabcode3, it.[site], it.[weight]
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Select @redmeat  =	SUM(t.[Weight])
					from tbl4 as t
					where t.RMTT = 1

Select @frozenwgt = SUM(t.[Weight])
					from tbl4 as t
					where t.fabcode3 = 'FROZEN' 

select code AS [Output Yield Code], [name] as [Output Yield Name], [site] as [Output Yield Site], [Weight] AS [Output Yield Weight Total], [PackNumber],
[QTY]AS [Output Yield QTY Total],PIECES AS [Output Yield Pieces Total], name2 as [[Output Yield Type] , Orderby as [Output Yield Orderby], @frozenwgt as FznWgt, @redmeat as RMT, ValuePerKg
,([Weight])*ValuePerKg  as [Value], RMTT, fabcode3
from tbl4
order by Orderby asc




drop table tbl4	
END


GO
