SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec usr_dw_Select_RealTimeStockWithXact
CREATE PROCEDURE  [dbo].[usr_dw_Select_RealTimeStockWithXact_FD]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select 
	id,4 as site,sscc,pp.batch,

	-- DBogues 2016-12-12 : TT Fix  but turning off
	-- casT(L.code as bigint) as lot,

	
	isnull(Case When pp.site = '1' then cast((select [code] from [FD_Innova].dbo.proc_lots where proc_lots.lot = pp.lot)as bigint)
		
			 When pp.site = '2' then cast((select FMPL.code  collate SQL_Latin1_General_CP1_CI_AS  from
									[FFGSQL03].[FM_INNOVA].dbo.[proc_packs] FMPK (nolock) 
									left join [FFGSQL03].[FM_INNOVA].dbo.[vw_LotswithNoXML] FMPL (nolock) on FMPL.LOT = CAST(FMPK.lot as nvarchar(30)) collate SQL_Latin1_General_CP1_CI_AS
									 where  FMPK.site = 1 and FMPK.number = pp.number) as bigint)
			 When pp.site = '3' then cast((select FFGPL.code  collate SQL_Latin1_General_CP1_CI_AS  from
									[FFGSQL03].[FO_INNOVA].dbo.[proc_packs] FFGPK (nolock) 
									left join [FFGSQL03].[FO_INNOVA].dbo.[vw_LotswithNoXML] FFGPL (nolock) on FFGPL.LOT = CAST(FFGPK.lot as nvarchar(30)) collate SQL_Latin1_General_CP1_CI_AS
									 where  FFGPK.site = 1 and FFGPK.number = pp.number) as bigint)
			When pp.site = '4' then cast((select HPL.code  collate SQL_Latin1_General_CP1_CI_AS from 
									[FFGSQL03].[FH_INNOVA].dbo.[proc_packs] HPK (nolock) 
									inner join [FFGSQL03].[FH_INNOVA].dbo.[vw_LotswithNoXML] HPL (nolock)on  HPL.LOT = CAST(HPK.lot as nvarchar(30)) collate SQL_Latin1_General_CP1_CI_AS
									where  HPK.site = 1 and HPK.number = pp.number)as bigint)	
			
			
			When pp.site = '5' then cast((select MMPL.code  collate SQL_Latin1_General_CP1_CI_AS from 
									[FFGSQL03].[FMM_INNOVA].dbo.[proc_packs] MMPK (nolock) 
									inner join [FFGSQL03].[FMM_INNOVA].dbo.[vw_LotswithNoXML] MMPL (nolock) on MMPL.LOT = CAST(MMPK.lot  as nvarchar(30)) collate SQL_Latin1_General_CP1_CI_AS
									where  MMPK.site = 1 and MMPK.number = pp.number) as bigint)	
			
			

			When pp.site = '6' then cast((select FGPL.code  collate SQL_Latin1_General_CP1_CI_AS from 
									[FFGSQL03].[FG_INNOVA].dbo.[proc_packs] FGPK (nolock) 
									inner join [FFGSQL03].[FG_INNOVA].dbo.[vw_LotswithNoXML] FGPL (nolock)  on FGPL.LOT = CAST(FGPK.lot as nvarchar(30)) collate SQL_Latin1_General_CP1_CI_AS
									where  FGPK.site = 1 and FGPK.number = pp.number)as bigint) 												
									else null
									end,0) As Lot,	
	
										
isnull(pp.Device,0) as Device,pp.prday,pp.expire1,pp.expire2,pp.expire3,inventory,invLocation,pallet,
(select code from [FD_Innova].dbo.vw_matswithNoXML where material = pp.Material) as ProductCode,Packaging,weight,pp.gross,tare,pieces,regtime, site as OrgSite,
INV.description2, pp.rtype, pp.invtime		
,PP.productnum	-- added by KH 28/02/18
,PP.fixedcode -- added by kh 17/01/18
				
from [FD_Innova].dbo.proc_packs PP (nolock)
inner join [FD_Innova].dbo.vw_proc_prunitsWithNoXML INV (nolock) on PP.inventory = INV.prunit
inner join [FD_Innova].dbo.vw_matswithNoXML mat (nolock) on PP.material = mat.material
left join [FD_Innova].dbo.base_devices bd (nolock) on  bd.device= isnull(pp.device,6) 

left join [FFGSQL03].[FD_INNOVA].[dbo].[vw_LotswithNoXML] AS L With (nolock) on PP.lot = L.lot

where LEN(mat.code) = 9 and (isnull(bd.description3,'') <> 'INTERNAL')
and pp.xacttime < CURRENT_TIMESTAMP and pp.xacttime 
	
	> 
	DateADD(mi, -60, Current_TimeStamp)
	--DateADD(wk, -1, GetDate())



END
GO
