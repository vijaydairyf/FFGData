SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,Joe Maguire>
-- Create date: <Create Date,,23/10/2018>
-- Description:	<Description,,TMS batch overview master sp that calls sps at each site to gather info for report>
-- =============================================

--exec [dbo].[usrrep_TMS_Batch_Overview_Master] '2019-01-30','2019-01-30','FD'

CREATE PROCEDURE [dbo].[usrrep_TMS_Batch_Overview_Master]
@from date,
@to date,
@site varchar(3)
AS
BEGIN

DECLARE @T TABLE (
[SiteIden] varchar(25),
ActivityName nvarchar(250),
ProductPct decimal(10,2),
maxProductPct decimal(10,2),
targetproductPct decimal(10,2),
ActualCL decimal(10,2),
number nvarchar(50),
material int,
[weight] decimal(10,2),
pieces int,
prday date,
matcode nvarchar(150),
matname nvarchar(250),
mattype nvarchar(150),
prunit int
)


If @site = 'FO'
BEGIN
insert into @T
SELECT
'FO' as SiteIden,
prog.[name] as ActivityName,
--avg 
cast(bat.[cl]as decimal(18,2)) as productpct ,
--max
cast(bat.[cl]as decimal(18,2)) as maxproductpct ,
bat.[targetcl] as targetproductpct ,
bat.cl as ActualCL,
pac.number,
pac.[material] as material ,
cast(pac.[weight] as decimal(18,2)) as [weight] ,
pac.[pieces] as [pieces] ,
cast(pac.prday as date) as prday,
mat.[code] as matcode ,
mat.[name] as matname ,
[type].[name] as mattype,
pru.prunit as prunit


FROM  [FO_Innova].[dbo].[grd_batchlog] bat 
LEFT OUTER JOIN [FO_Innova].[dbo].[proc_packs] pac ON pac.[id] = bat.[packid] 
LEFT OUTER JOIN [FO_Innova].[dbo].[proc_materials] mat ON mat.[material] = pac.[material] 
LEFT OUTER JOIN [FO_Innova].[dbo].[proc_materialtypes] [type] ON [type].materialtype = mat.materialtype 
LEFT OUTER JOIN [FO_Innova]. [dbo].[proc_prperiods] prp ON prp.prperiod = pac.[sprperiod] 
LEFT OUTER JOIN [FO_Innova].[dbo].[grd_programs] prog ON prog.program = prp.activity 
LEFT OUTER JOIN [FO_Innova].[dbo].[proc_prunits] pru ON pru.prunit = prp.prunit 
LEFT OUTER JOIN [FO_Innova].[dbo].[proc_lots] lot ON lot.lot = pru.lot 

--tms grader
WHERE (1=1)  AND prp.prunit IN (122) AND 
			cast(prp.prday as date) between @from and @to

			order by matcode

Select * from @T
END


IF @site = 'FC'
BEGIN
insert into @T
SELECT
'FC'as SiteIden,
prog.[name] as ActivityName,
--avg 
cast(bat.[cl]as decimal(18,2)) as productpct ,
--max
cast(bat.[cl]as decimal(18,2)) as maxproductpct ,
bat.[targetcl] as targetproductpct ,
bat.cl as ActualCL,
pac.number,
pac.[material] as material ,
cast(pac.[weight] as decimal(18,2)) as [weight] ,
pac.[pieces] as [pieces] ,
cast(pac.prday as date) as prday,
mat.[code] as matcode ,
mat.[name] as matname ,
[type].[name] as mattype,
pru.prunit as prunit 


FROM  [FM_Innova].[dbo].[grd_batchlog] bat 
LEFT OUTER JOIN [FM_Innova].[dbo].[proc_packs] pac ON pac.[id] = bat.[packid] 
LEFT OUTER JOIN [FM_Innova].[dbo].[proc_materials] mat ON mat.[material] = pac.[material] 
LEFT OUTER JOIN [FM_Innova].[dbo].[proc_materialtypes] [type] ON [type].materialtype = mat.materialtype 
LEFT OUTER JOIN [FM_Innova].[dbo].[proc_prperiods] prp ON prp.prperiod = pac.[sprperiod] 
LEFT OUTER JOIN [FM_Innova].[dbo].[grd_programs] prog ON prog.program = prp.activity 
LEFT OUTER JOIN [FM_Innova].[dbo].[proc_prunits] pru ON pru.prunit = prp.prunit 
LEFT OUTER JOIN [FM_Innova].[dbo].[proc_lots] lot ON lot.lot = pru.lot 

--tms grader
WHERE (1=1)  AND prp.prunit IN (155,156) AND 
			cast(prp.prday as date) between @from and @to

			order by matcode
		Select * from @T
END


IF @site = 'FG'
BEGIN
insert into @T
SELECT
'FG' as SiteIden,
prog.[name] as ActivityName,
--avg 
cast(bat.[cl]as decimal(18,2)) as productpct ,

--max
cast(bat.[cl]as decimal(18,2)) as maxproductpct ,
bat.[targetcl] as targetproductpct ,
bat.cl as ActualCL,
pac.number,
pac.[material] as material ,
cast(pac.[weight] as decimal(18,2)) as [weight] ,
pac.[pieces] as [pieces] ,
cast(pac.prday as date) as prday,
mat.[code] as matcode ,
mat.[name] as matname ,
[type].[name] as mattype,
pru.prunit as prunit



FROM  [FG_innova].[dbo].[grd_batchlog] bat 
LEFT OUTER JOIN [FG_innova].[dbo].[proc_packs] pac ON pac.[id] = bat.[packid] 
LEFT OUTER JOIN [FG_innova].[dbo].[proc_materials] mat ON mat.[material] = pac.[material] 
LEFT OUTER JOIN [FG_innova].[dbo].[proc_materialtypes] [type] ON [type].materialtype = mat.materialtype 
LEFT OUTER JOIN [FG_innova].[dbo].[proc_prperiods] prp ON prp.prperiod = pac.[sprperiod] 
LEFT OUTER JOIN [FG_innova].[dbo].[grd_programs] prog ON prog.program = prp.activity 
LEFT OUTER JOIN [FG_innova].[dbo].[proc_prunits] pru ON pru.prunit = prp.prunit 
LEFT OUTER JOIN [FG_innova].[dbo].[proc_lots] lot ON lot.lot = pru.lot 

--tms grader
WHERE (1=1)  AND prp.prunit IN (80) AND 
			cast(prp.prday as date) between @from and @to

			order by matcode


			select * from @T as T
			END

			IF @site = 'FD'
			BEGIN 
INSERT INTO @T
SELECT
'FD' as SiteIden,
[mat].[name] as ActivityName,
--avg 
cast(bat.[productpct] AS decimal(18,2)) as productpct ,
--max
cast(bat.maxproductpct AS decimal(18,2)) as maxproductpct ,
bat.targetproductpct as targetproductpct ,
pac.fat as ActualCL,
pac.number,
pac.[material] as material ,
cast(pac.[weight] as decimal(18,2)) as [weight] ,
pac.[pieces] as [pieces] ,
cast(pac.prday as date) as prday,
mat.[code] as matcode ,
mat.[name] as matname ,
Left(SubString(REPLACE(mat.[name],'80cl','85'), PatIndex('%[0-9.-]%', mat.[name]), 8000),
PatIndex('%[^0-9.-]%', SubString(mat.[name], PatIndex('%[0-9.-]%', mat.[name]), 8000) + 'X')-1) + ' VL' AS MatType,
pru.prunit as prunit

FROM			 [DMPSQL-01].[innova].[dbo].[tms_batchlog] bat 
LEFT OUTER JOIN  [DMPSQL-01].[innova].[dbo].[proc_packs] pac ON pac.[id] = bat.[pack] 
LEFT OUTER JOIN  [DMPSQL-01].[innova].[dbo].[VW_Products_NO_XML] mat ON mat.[material] = pac.[material] 
LEFT OUTER JOIN  [DMPSQL-01].[innova].[dbo].[proc_prperiods] prp ON prp.prperiod = pac.[sprperiod] 
LEFT OUTER JOIN  [DMPSQL-01].[innova].[dbo].[VW_Prunits_With_NoXML] pru ON pru.prunit = prp.prunit 
--tms grader
WHERE (1=1)  AND prp.prunit IN (1,2) AND cast(prp.prday as date) BETWEEN @from and @to
ORDER BY matcode
		SELECT * FROM @T		
			
			END
	



END
GO
