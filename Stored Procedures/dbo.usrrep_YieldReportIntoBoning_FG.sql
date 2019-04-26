SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <11/07/2017>
-- Description:	<Standard Yeild Report>
-- =============================================
--exec [usrrep_YieldReportIntoBoning_FG] '03/14/2019','03/14/2019','151515101022',0,99999
CREATE PROCEDURE [dbo].[usrrep_YieldReportIntoBoning_FG]

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


BEGIN

DECLARE  @tbl1 table (HQTotal DECIMAL(18,2),FQTotal DECIMAL(18,2), [Into Boning Code] nvarchar(20), [Into Boning Description] nvarchar(100), [Into Boning Name] nvarchar(100), 
					[Into Boning QTY] int, [Into Boning WEIGHT] decimal(18,2), [Into Boning Lots] nvarchar(20), [ValuePerKg] DECIMAL(18,2), [Value] DECIMAL(18,2) )

/* into boning for yeild */

Declare @FQ decimal(18,2)
Declare @HQ decimal(18,2)
----------------------------------------------------------------------------------------------------------------------------------------------
Select @FQ = CAST(SUM(pmx.[weight]) as decimal(10,2))
from	[FG_innova].[dbo].proc_matxacts AS pmx
		LEFT Join [FG_innova].[dbo].proc_materials AS pm with (nolock) on pm.material = pmx.material
		LEFT Join [FG_innova].[dbo].proc_xactpaths AS xp with (nolock) on xp.xactpath = pmx.xactpath
		LEFT JOin [FG_innova].[dbo].proc_lots AS pl with (nolock) on pl.lot = pmx.tolot
		Inner JOIN [dbo].[Split](@_Lots, ',') As S on pl.code = S.Item

where	CAST(pmx.prday AS DATE) BETWEEN @BeginDate AND @EndDate
		and pm.code IS NOT NULL 
		and xp.description1 = 'BoneIn' 
		AND pmx.rtype IN( '1' ,'9') -- 1 transfer - 9 reversed -- 9 added by kh 16/11/18
		and isnull(pmx.Batch,0) between @FromBatch and @ToBatch
		and pm.description2 = 'FQ'

group by pm.description2
----------------------------------------------------------------------------------------------------------------------------------------------
Select @HQ = CAST(SUM(pmx.[weight]) as decimal(10,2))
from	[FG_innova].[dbo].proc_matxacts AS pmx
		LEFT Join [FG_innova].[dbo].proc_materials AS pm with (nolock) on pm.material = pmx.material
		LEFT Join [FG_innova].[dbo].proc_xactpaths AS xp with (nolock) on xp.xactpath = pmx.xactpath
		LEFT JOin [FG_innova].[dbo].proc_lots AS pl with (nolock) on pl.lot = pmx.tolot
		Inner JOIN [dbo].[Split](@_Lots, ',') As S on pl.code = S.Item

where	CAST(pmx.prday AS DATE) BETWEEN @BeginDate AND @EndDate
		and pm.code IS NOT NULL 
		and xp.description1 = 'BoneIn' 
		AND pmx.rtype IN( '1' ,'9') -- 1 transfer - 9 reversed -- 9 added by kh 16/11/18
		and isnull(pmx.Batch,0) between @FromBatch and @ToBatch
		and pm.description2 = 'HQ'
group by pm.description2


----------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO @tbl1
SELECT @HQ as HQTotal, @FQ as FQTotal, pm.code AS [Into Boning Code], pm.description1 AS [Into Boning Description],pl.[name] as [Into Boning Name], 
SUM (pmx.nregs)AS [Into Boning QTY2],
CAST(SUM(pmx.[weight]) as decimal(10,2)) AS [Into Boning WEIGHT],
pl.code as [Into Boning Lots], 
pm.[value] as [ValuePerKg]
,(pm.[value] * SUM(pmx.[weight])) as [Value]


from	[FG_innova].[dbo].proc_matxacts AS pmx
		LEFT Join [FG_innova].[dbo].proc_materials AS pm with (nolock) on pm.material = pmx.material
		LEFT JOin [FG_innova].[dbo].proc_lots AS pl with (nolock) on pl.lot = pmx.tolot
		LEFT Join [FG_innova].[dbo].proc_xactpaths AS xp with (nolock) on xp.xactpath = pmx.xactpath
		LEFT JOIN 	[FG_innova].[dbo].proc_items as it with (nolock) on it.id = pmx.item
		LEFT JOIN [FG_innova].[dbo].proc_prunits AS pr WITH (NOLOCK) ON pr.prunit = ISNULL(it.inventory,'0')
		Inner JOIN [dbo].[Split](@_Lots, ',') As S on pl.code = S.Item

where	CAST(pmx.prday AS DATE) BETWEEN @BeginDate AND @EndDate
		and pm.code IS NOT NULL 
		and xp.description1 = 'BoneIn' 
		AND pmx.rtype IN( '1' ,'9') -- 1 transfer - 9 reversed -- 9 added by kh 16/11/18
		and isnull(pmx.Batch,0) between @FromBatch and @ToBatch
		and pm.code <> 999999
		AND ISNULL(pr.[name],'0') <> 'Yield Adjustment (-ve)'

group by	pm.code, pm.description1, pl.[name], pmx.tolot, pl.code, pm.[value], it.inventory, pmx.prday, pmx.[weight] , pmx.nregs
order by	pm.code, pl.code

----------------------------------------------------------------------------------------------------------------------------------------------
SELECT it.id ,@HQ as HQTotal, @FQ as FQTotal, pm.code AS [Into Boning Code], pm.description1 AS [Into Boning Description],pl.[name] as [Into Boning Name], 
  (0 - CAST(pmx.nregs AS int)  ) AS [Into Boning QTY],
  (0 - CAST(pmx.[weight] AS Decimal(10,2)))  AS [Into Boning WEIGHT],
pl.code as [Into Boning Lots], 
pm.[value] as [ValuePerKg]
,(pm.[value] * SUM(pmx.[weight])) as [Value]
INTO #tmp
from	[FG_innova].[dbo].proc_matxacts AS pmx
		LEFT Join [FG_innova].[dbo].proc_materials AS pm with (nolock) on pm.material = pmx.material
		LEFT JOin [FG_innova].[dbo].proc_lots AS pl with (nolock) on pl.lot = pmx.tolot
		LEFT Join [FG_innova].[dbo].proc_xactpaths AS xp with (nolock) on xp.xactpath = pmx.xactpath
		LEFT JOIN 	[FG_innova].[dbo].proc_items as it with (nolock) on it.id = pmx.item
		LEFT JOIN [FG_innova].[dbo].proc_prunits AS pr WITH (NOLOCK) ON pr.prunit = it.inventory
		Inner JOIN [dbo].[Split](@_Lots, ',') As S on pl.code = S.Item

where	CAST(pmx.prday AS DATE) BETWEEN @BeginDate AND @EndDate
		and pm.code IS NOT NULL 
		and xp.description1 = 'BoneIn' 
		AND pmx.rtype IN( '1' ,'9') -- 1 transfer - 9 reversed -- 9 added by kh 16/11/18
		and isnull(pmx.Batch,0) between @FromBatch and @ToBatch
		and pm.code <> 999999
		AND pr.[name] = 'Yield Adjustment (-ve)'

group by	pm.code, pm.description1, pl.[name], pmx.tolot, pl.code, pm.[value], it.inventory, pmx.prday, pmx.[weight] , pmx.nregs, it.id
order by	pm.code, pl.code

----------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO @tbl1
SELECT HQTotal,
       FQTotal,
       [Into Boning Code],
       [Into Boning Description],
       [Into Boning Name],
       [Into Boning QTY],
       [Into Boning WEIGHT],
       [Into Boning Lots],
       ValuePerKg,
       [Value] 
	   
	   FROM #tmp

----------------------------------------------------------------------------------------------------------------------------------------------


SELECT IsNull(HQTotal,0) As HQTotal,
       IsNull(FQTotal,0) As FQTotal,
       [Into Boning Code],
       [Into Boning Description],
       [Into Boning Name],
      SUM([Into Boning QTY]) AS [Into Boning QTY],
      SUM([Into Boning WEIGHT]) AS [Into Boning WEIGHT],
       [Into Boning Lots],
       ValuePerKg,
       SUM([Value]) AS [Value] 
	   FROM @tbl1
		GROUP BY [Into Boning Code], [Into Boning Description], [Into Boning Name],  [Into Boning Lots],  ValuePerKg, HQTotal,FQTotal
		ORDER by	[Into Boning Code], [Into Boning Lots]


END


GO
