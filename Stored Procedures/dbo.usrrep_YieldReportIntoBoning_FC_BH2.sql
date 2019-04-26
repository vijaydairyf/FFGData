SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <11/07/2017>
-- Description:	<Standard Yeild Report>
-- =============================================
--exec [usrrep_YieldReportIntoBoning] '07/07/2017','07/07/2017','131313101012,131313111012,131313111310,131313121010,131313121310',0,99999
CREATE PROCEDURE [dbo].[usrrep_YieldReportIntoBoning_FC_BH2]

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


BEGIN
/* into boning for yeild */

Declare @FQ decimal(18,2)
Declare @HQ decimal(18,2)

Select @FQ = CAST(SUM(pmx.[weight]) as decimal(10,2))
from	[FM_Innova].[dbo].proc_matxacts AS pmx
		LEFT Join [FM_Innova].[dbo].proc_materials AS pm with (nolock) on pm.material = pmx.material
		LEFT Join [FM_Innova].[dbo].proc_xactpaths AS xp with (nolock) on xp.xactpath = pmx.xactpath
		LEFT JOin [FM_Innova].[dbo].proc_lots AS pl with (nolock) on pl.lot = pmx.tolot
		Inner JOIN [dbo].[Split](@_Lots, ',') As S on pl.code collate DATABASE_DEFAULT = S.Item

where	CAST(pmx.prday AS DATE) BETWEEN @BeginDate AND @EndDate
		and pm.code IS NOT NULL 
		and xp.description1 = 'BoneIn' 
		AND pmx.rtype IN( '1' ,'9') -- 1 transfer - 9 reversed -- 9 added by kh 16/11/18
		and isnull(pmx.Batch,0) between @FromBatch and @ToBatch
		and pm.description2 = 'FQ'
		and (xp.xactpath in(3,700)) -- path for into boninghall 2 & 3


group by pm.description2

Select @HQ = CAST(SUM(pmx.[weight]) as decimal(10,2))
from	[FM_Innova].[dbo].proc_matxacts AS pmx
		LEFT Join [FM_Innova].[dbo].proc_materials AS pm with (nolock) on pm.material = pmx.material
		LEFT Join [FM_Innova].[dbo].proc_xactpaths AS xp with (nolock) on xp.xactpath = pmx.xactpath
		LEFT JOin [FM_Innova].[dbo].proc_lots AS pl with (nolock) on pl.lot = pmx.tolot
		Inner JOIN [dbo].[Split](@_Lots, ',') As S on pl.code collate DATABASE_DEFAULT = S.Item

where	CAST(pmx.prday AS DATE) BETWEEN @BeginDate AND @EndDate
		and pm.code IS NOT NULL 
		and xp.description1 = 'BoneIn' 
		AND pmx.rtype IN( '1' ,'9') -- 1 transfer - 9 reversed -- 9 added by kh 16/11/18
		and isnull(pmx.Batch,0) between @FromBatch and @ToBatch
		and pm.description2 = 'HQ'
		and (xp.xactpath in(3,700))-- path for into boninghall 2 & 3
group by pm.description2


Select @HQ as HQTotal, @FQ as FQTotal, pm.code AS [Into Boning Code], pm.description1 AS [Into Boning Description],pl.[name] as [Into Boning Name], Sum (pmx.nregs) AS [Into Boning QTY],
CAST(SUM(pmx.[weight]) as decimal(10,2)) AS [Into Boning WEIGHT],pl.code as [Into Boning Lots], pm.[value] as [ValuePerKg], (pm.[value] * SUM(pmx.[weight])) as [Value]
from	[FM_Innova].[dbo].proc_matxacts AS pmx
		LEFT Join [FM_Innova].[dbo].proc_materials AS pm with (nolock) on pm.material = pmx.material
		LEFT JOin [FM_Innova].[dbo].proc_lots AS pl with (nolock) on pl.lot = pmx.tolot
		LEFT Join [FM_Innova].[dbo].proc_xactpaths AS xp with (nolock) on xp.xactpath = pmx.xactpath
		LEFT JOIN 	[FM_Innova].[dbo].proc_items as it with (nolock) on it.id = pmx.item
		Inner JOIN [dbo].[Split](@_Lots, ',') As S on pl.code collate DATABASE_DEFAULT = S.Item

where	CAST(pmx.prday AS DATE) BETWEEN @BeginDate AND @EndDate
		and pm.code IS NOT NULL 
		and xp.description1 = 'BoneIn' 
		AND pmx.rtype IN( '1' ,'9') -- 1 transfer - 9 reversed -- 9 added by kh 16/11/18
		and isnull(pmx.Batch,0) between @FromBatch and @ToBatch
		and pm.code <> 999999
		and (xp.xactpath in(3,700))-- path for into boninghall 2 & 3

group by	pm.code, pm.description1, pl.[name], pmx.tolot, pl.code, pm.[value]
order by	pm.code, pl.code


END

GO
