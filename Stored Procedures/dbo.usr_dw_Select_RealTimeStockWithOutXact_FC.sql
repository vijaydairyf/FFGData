SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec [usr_dw_Select_RealTimeStockWithOutXact_FC]
CREATE PROCEDURE [dbo].[usr_dw_Select_RealTimeStockWithOutXact_FC]
AS
BEGIN

	

	select 
	pp.id,1 as site,pp.sscc,pp.batch,

	
	isnull(Case When pp.site = '1' then cast((select [code] from [FM_INNOVA].dbo.proc_lots where proc_lots.lot = pp.lot)as bigint)
		
			 When pp.site = '2' then cast((select FFGPL.code  collate SQL_Latin1_General_CP1_CI_AS  from
									[FO_INNOVA].dbo.[proc_packs] FFGPK (nolock) 
									left join [FO_INNOVA].dbo.[vw_LotswithNoXML] FFGPL (nolock) on FFGPL.LOT = CAST(FFGPK.lot as nvarchar(30))										collate SQL_Latin1_General_CP1_CI_AS
									 where  FFGPK.site = 1 and FFGPK.number = pp.number) as bigint)

			 When pp.site = '3' then Cast((select HPL.code  collate SQL_Latin1_General_CP1_CI_AS from 
									[FH_INNOVA].dbo.[proc_packs] HPK (nolock) 
									inner join [FH_INNOVA].dbo.[vw_LotswithNoXML] HPL (nolock)on  HPL.LOT = CAST(HPK.lot as nvarchar(30)) collate									SQL_Latin1_General_CP1_CI_AS
									where  HPK.site = 1 and HPK.number = pp.number) as bigint)

			When pp.site = '4' then cast((select DPL.code  collate SQL_Latin1_General_CP1_CI_AS from 
									[FD_INNOVA].dbo.[proc_packs] DPK (nolock)
									inner join [FD_INNOVA].dbo.[vw_LotswithNoXML] DPL (nolock)on  DPL.LOT = CAST(DPK.lot  as nvarchar(30)) collate									SQL_Latin1_General_CP1_CI_AS
									where  DPK.site = 1 and DPK.number = pp.number) as bigint)	

									
			When pp.site = '5' then cast((select MMPL.code  collate SQL_Latin1_General_CP1_CI_AS from 
									[FMM_INNOVA].dbo.[proc_packs] MMPK (nolock) 
									inner join [FMM_INNOVA].dbo.[vw_LotswithNoXML] MMPL (nolock) on MMPL.LOT = CAST(MMPK.lot  as nvarchar(30))										collate SQL_Latin1_General_CP1_CI_AS
									where  MMPK.site = 1 and MMPK.number = pp.number) as bigint)	
							

			When pp.site = '6' then cast((select FGPL.code  collate SQL_Latin1_General_CP1_CI_AS from 
									[FG_INNOVA].dbo.[proc_packs] FGPK (nolock) 
									inner join [FG_INNOVA].dbo.[vw_LotswithNoXML] FGPL (nolock)  on FGPL.LOT = CAST(FGPK.lot as nvarchar(30))										collate SQL_Latin1_General_CP1_CI_AS
									where  FGPK.site = 1 and FGPK.number = pp.number) as bigint)												
			else null
			end,0) As Lot,		
	

	isnull(pp.Device,0) as Device,
	pp.prday,
	pp.expire1,
	pp.expire2,
	pp.expire3,
	inventory,
	invLocation,
	pallet,
	(
		select code 
		from [FM_INNOVA].dbo.vw_matswithNoXML with (nolock) 
		where material = pp.Material
	) as ProductCode,
	Packaging,
	pp.weight,
	pp.gross,
	pp.tare,
	pp.pieces,
	pp.regtime,
	site as OrgSite,
	INV.description2,
	pp.rtype,
	pp.invtime
	,PP.productnum	-- added by KH 28/02/18
	,PP.fixedcode -- added by kh 17/01/18
							
from [FM_INNOVA].dbo.proc_packs PP (nolock)
	inner join 
		[FM_INNOVA].dbo.vw_PrUnitsWithNoXML INV (nolock) on PP.inventory = INV.prunit
	left join 
		[FM_INNOVA].dbo.vw_matswithNoXML mat (nolock) on PP.material = mat.material
	inner join 
		[FFGBI-SERV].FFG_DW.dbo.stock_packs SP (nolock) on sp.id = pp.id and sp.siteid = 1
	left join 
		[FM_INNOVA].dbo.base_devices bd (nolock) on  bd.device= isnull(pp.device,6) 
	left join 
		[FM_INNOVA].[dbo].[vw_LotswithNoXML] AS L With (nolock) on PP.lot = L.lot
where   LEN(mat.code) = 9 --and (isnull(bd.description3,'')<> 'INTERNAL')
 and Not pp.inventory Is Null
and (sp.id = pp.id and sp.siteid = 1) and (sp.Inventoryid <> pp.inventory or sp.InventoryLocationID <> pp.invLocation or sp.Palletid <> pp.Pallet or SP.deviceid <> pp.Device or pp.rtype <> sp.rtype or pp.[weight] <> sp.[weight])
END
GO
