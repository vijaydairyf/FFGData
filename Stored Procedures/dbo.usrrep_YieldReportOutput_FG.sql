SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <12/07/2017>
-- Description:	<Standard Yeild Report>
-- =============================================
--exec [usrrep_YieldReportOutput_FG]  '03/14/2019', '03/14/2019', '151515101012', '0', '99999999'
CREATE PROCEDURE [dbo].[usrrep_YieldReportOutput_FG]

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
from [FG_innova].[dbo].Proc_Lots
Inner JOIN [dbo].[Split](@_Lots, ',') As S on proc_lots.code collate database_default = S.Item

BEGIN

Create Table tbl2 (code nvarchar(20), [name] nvarchar(100), [site] nvarchar(10), PackNumber nvarchar(20), [Weight] decimal(18,3), QTY int,
					PIECES int, name2 nvarchar(100), Orderby nvarchar(10), ValuePerKg decimal(18,3), description3 nvarchar(100), RMTT nvarchar(5), fabcode3 nvarchar(20))
/* Output Yield report 8 */
Declare @frozenwgt decimal (18,3)
Declare @redmeat decimal (18,3)
	
INSERT INTO  tbl2
Select	pm.code, pm.[name],pp.[site], pp.number as PackNumber,
CAST(pp.[weight] AS Decimal(18,3)) AS [Weight],
COUNT(pm.code) AS QTY,
 pp.pieces AS PIECES, pm2.[name] as name2, pm2.extcode AS Orderby, pm.[value] as ValuePerKg, pru.description3, pm2.dimension3, pm.fabcode3

	
from [FG_innova].[dbo].proc_packs AS PP
LEFT JOIN [FG_innova].[dbo].proc_prunits AS pru with (nolock) on pru.prunit = pp.inventory
LEFT JOIN [FG_innova].[dbo].proc_lots AS pl with (nolock) on pl.lot = pp.lot
LEFT JOIN [FG_innova].[dbo].proc_materials AS pm with (nolock) on pm.material = pp.material
LEFT JOIN [FG_innova].[dbo].proc_materialtypes AS pm2 with (nolock) on pm2.materialtype = pm.materialtype
left join [FG_innova].[dbo].proc_pos as pos with (nolock) on pos.po = PP.po
INNER JOIN [dbo].[Split](@_Lots, ',') As S on pl.code collate database_default = S.Item
left join [FG_innova].[dbo].[proc_rmareas] as rma with (nolock) on rma.rmarea = PP.rmarea -- added by kh 16/11/18 for Into BH stamp

where	(CAST(pp.prday AS DATE) BETWEEN @BeginDate and @EndDate) --OR (CAST(pp.[invtime] AS date) BETWEEN @BeginDate and @EndDate AND pru.description3 = 'NegativeYield'))
		AND (pp.porder IS NOT NULL OR pos.[name] = 'Into B/H Yield' or rma.[name] = 'Into B/H Yield') --1 = Standard packing
		AND ISNULL(pru.description3,0) <> 'NSNY'
		AND pp.rtype = '1'
		AND pl.dimension1 = '1'
		AND isnull(PP.Batch,0) between @FromBatch and @ToBatch  
		

group by pm.code, pm.[name], pp.[site],pm2.[name], pru.description3,CAST(pp.[invtime] AS DATE), pm2.extcode, pm.[value], PP.[weight], PP.pieces,pru.description3,pp.number, pm2.dimension3, pm.fabcode3

INSERT INTO  tbl2
Select	pm.code, pm.[name],pp.[site], pp.number as PackNumber,
CASE WHEN (pru.description3 = 'NegativeYield' AND CAST(pp.[invtime] AS DATE) BETWEEN @BeginDate and @EndDate ) 
	THEN  (0 - CAST(pp.[weight] AS Decimal(18,3))  )else  CAST(pp.[weight] AS Decimal(18,3)) end  AS [Weight],
CASE WHEN (pru.description3 = 'NegativeYield' AND CAST(pp.[invtime] AS DATE) BETWEEN @BeginDate and @EndDate) 
	THEN (0 - COUNT(pm.code)) else  COUNT(pm.code) end  AS QTY,
 pp.pieces AS PIECES, pm2.[name] as name2, pm2.extcode AS Orderby, pm.[value] as ValuePerKg, pru.description3,
 pm2.dimension3,
  pm.fabcode3

	
from [FG_innova].[dbo].proc_packs AS PP
LEFT JOIN [FG_innova].[dbo].proc_prunits AS pru with (nolock) on pru.prunit = pp.inventory
LEFT JOIN [FG_innova].[dbo].proc_lots AS pl with (nolock) on pl.lot = pp.lot
LEFT JOIN [FG_innova].[dbo].proc_materials AS pm with (nolock) on pm.material = pp.material
LEFT JOIN [FG_innova].[dbo].proc_materialtypes AS pm2 with (nolock) on pm2.materialtype = pm.materialtype
INNER JOIN [dbo].[Split](@_Lots, ',') As S on pl.code collate database_default = S.Item

where	--(CAST(pp.prday AS DATE) BETWEEN @BeginDate and @EndDate 
		(CAST(pp.[invtime] AS date) BETWEEN @BeginDate and @EndDate AND pru.description3 = 'NegativeYield')
		AND (pp.porder IS NOT NULL OR isnull(pp.po,0) = 81190) --1 = Standard packing
		AND ISNULL(pru.description3,0) <> 'NSNY'
		AND pp.rtype = '1'
		AND pl.dimension1 = '1'
		AND isnull(PP.Batch,0) between @FromBatch and @ToBatch  

	group by pm.code, pm.[name], pp.[site],pm2.[name], pru.description3,CAST(pp.[invtime] AS DATE), pm2.extcode, pm.[value], PP.[weight], PP.pieces,pru.description3,pp.number , pm2.dimension3, pm.fabcode3

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Insert into tbl2
Select	pm.code, pm.[name],it.[site], it.number as PackNumber,
CAST(it.[weight] AS Decimal(18,3)) AS [Weight],
COUNT(pm.code) AS QTY,
 it.pieces AS PIECES, pm2.[name] as name2, pm2.extcode AS Orderby, pm.[value] as ValuePerKg, pru.description3, pm2.dimension3, pm.fabcode3

from [FG_Innova].[dbo].proc_items as it (nolock)
LEFT JOIN [FG_Innova].[dbo].proc_prunits AS pru with (nolock) on pru.prunit = it.inventory
LEFT JOIN [FG_Innova].[dbo].proc_lots AS pl with (nolock) on pl.lot = it.lot
LEFT JOIN [FG_Innova].[dbo].proc_materials AS pm with (nolock) on pm.material = it.material
LEFT JOIN [FG_Innova].[dbo].proc_materialtypes AS pm2 with (nolock) on pm2.materialtype = pm.materialtype
INNER JOIN [dbo].[Split](@_Lots, ',') As S on pl.code collate database_default = S.Item

WHERE  
						pm2.[name] = 'Roastings'
						and (it.rtype != 4)  
						AND (CONVERT(nvarchar(10), it.prday, 102) BETWEEN CONVERT(nvarchar(10), @BeginDate, 102) AND CONVERT(nvarchar(10), @EndDate,  102)) 
						and isnull(it.Batch,0) between @FromBatch and @ToBatch 

		group by pm.code, pm.[name], it.number, it.pieces, pm2.[name], pm2.extcode, pm.[value], pru.description3, pm2.dimension3, pm.fabcode3, it.[site], it.[weight]
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Select @redmeat  =	SUM(t.[Weight])
					from tbl2 as t
					where t.RMTT = 1

Select @frozenwgt = SUM(t.[Weight])
					from tbl2 as t
					where t.fabcode3 = 'FROZEN' 


select code AS [Output Yield Code], [name] as [Output Yield Name], [site] as [Output Yield Site], [Weight] AS [Output Yield Weight Total], [PackNumber],
[QTY]AS [Output Yield QTY Total],PIECES AS [Output Yield Pieces Total], name2 as [[Output Yield Type] , Orderby as [Output Yield Orderby], @frozenwgt as FznWgt, @redmeat as RMT, ValuePerKg
,([Weight])*ValuePerKg  as [Value], RMTT, fabcode3
from tbl2
order by Orderby asc




drop table tbl2
END


GO
