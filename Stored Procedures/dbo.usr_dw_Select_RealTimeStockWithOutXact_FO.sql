SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec [usr_dw_Select_RealTimeStockWithOutXact_FO]
CREATE PROCEDURE [dbo].[usr_dw_Select_RealTimeStockWithOutXact_FO]
AS
BEGIN
	select 
	pp.id,
	2 as site,
	pp.sscc,
	pp.batch,
	
	-- DBogues : 2016-12-12 : TT lot fix attempt
	-- casT(L.code as bigint) as lot,

	
	isnull(
		Case When pp.site = '1' then cast((select [code] from [FO_Innova].[dbo].proc_lots where proc_lots.lot = pp.lot)as bigint)
		
			 When pp.site = '2' then cast((select FMPL.code  collate SQL_Latin1_General_CP1_CI_AS  from
									--[CAMSQL01].[INNOVA].dbo.[proc_packs] FMPK (nolock) 
									[FFGSQL03].[FM_INNOVA].dbo.[proc_packs] FMPK (nolock) 
									
									left join 
									--[CAMSQL01].[INNOVA].dbo.[vw_LotswithNoXML] FMPL (nolock) 
									[FFGSQL03].[FM_INNOVA].dbo.[vw_LotswithNoXML] FMPL (nolock) 
									
									on FMPL.LOT = CAST(FMPK.lot as nvarchar(30)) collate SQL_Latin1_General_CP1_CI_AS
									 where  FMPK.site = 1 and FMPK.number = pp.number) as bigint)
			 When pp.site = '3' then cast((select HPL.code  collate SQL_Latin1_General_CP1_CI_AS from 
									
									--[CKTSQL01].[INNOVA].dbo.[proc_packs] HPK (nolock) 
									[FFGSQL03].[FH_INNOVA].dbo.[proc_packs] HPK (nolock) 
									inner join 
									--[CKTSQL01].[INNOVA].dbo.[vw_LotswithNoXML] HPL (nolock) 
									[FFGSQL03].[FH_INNOVA].dbo.[vw_LotswithNoXML] HPL (nolock)

									on  HPL.LOT = CAST(HPK.lot as nvarchar(30)) collate SQL_Latin1_General_CP1_CI_AS
									where  HPK.site = 1 and HPK.number = pp.number)  as bigint)
			When pp.site = '4' then cast((select DPL.code  collate SQL_Latin1_General_CP1_CI_AS from 
									
									--[DONSQL01].[INNOVA].dbo.[proc_packs] DPK (nolock)
									[FFGSQL03].[FD_INNOVA].dbo.[proc_packs] DPK (nolock)
									inner join 
									--[DONSQL01].[INNOVA].dbo.[vw_LotswithNoXML] DPL (nolock) on 
									[FFGSQL03].[FD_INNOVA].dbo.[vw_LotswithNoXML] DPL (nolock) on
									DPL.LOT = CAST(DPK.lot  as nvarchar(30)) collate SQL_Latin1_General_CP1_CI_AS
									where  DPK.site = 1 and DPK.number = pp.number)	as bigint)
			
			When pp.site = '8' then cast((select MMPL.code  collate SQL_Latin1_General_CP1_CI_AS from 
									
									--[MELSQL01].[INNOVA].dbo.[proc_packs] MMPK (nolock) 
									[FFGSQL03].[FMM_INNOVA].dbo.[proc_packs] MMPK (nolock) 
									
									inner join [FFGSQL03].[FMM_INNOVA].dbo.[vw_LotswithNoXML] MMPL (nolock) on MMPL.LOT = CAST(MMPK.lot  as nvarchar(30)) collate SQL_Latin1_General_CP1_CI_AS
									where  MMPK.site = 1 and MMPK.number = pp.number)as bigint) 	
			
			

			When pp.site = '10' then (select FGPL.code  collate SQL_Latin1_General_CP1_CI_AS from 
									--[GLOSQL01].[INNOVA].dbo.[proc_packs] FGPK (nolock) 
									[FFGSQL03].[FG_INNOVA].dbo.[proc_packs] FGPK (nolock) 
									inner join 
									--[GLOSQL01].[INNOVA].dbo.[vw_LotswithNoXML] FGPL (nolock) 
									[FFGSQL03].[FG_INNOVA].dbo.[vw_LotswithNoXML] FGPL (nolock) 
									 on FGPL.LOT = CAST(FGPK.lot as nvarchar(30)) collate SQL_Latin1_General_CP1_CI_AS
									where  FGPK.site = 1 and FGPK.number = pp.number) 												
									else 0
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
		select code from [FO_Innova].[dbo].vw_matswithNoXML with (nolock) 
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
						
from 
	[FO_Innova].[dbo].proc_packs PP (nolock)
	inner join [FO_Innova].[dbo].vw_proc_prunitsWithNoXML INV (nolock) on PP.inventory = INV.prunit
	left join [FO_Innova].[dbo].vw_matswithNoXML mat (nolock) on PP.material = mat.material
	inner join [FFGBI-SERV].FFG_DW.dbo.stock_packs SP (nolock) on sp.id = pp.id and sp.siteid = 2
	left join [FO_Innova].[dbo].base_devices bd (nolock) on  bd.device= isnull(pp.device,6)
	left join [FO_INNOVA].[dbo].[vw_LotswithNoXML] AS L With (nolock) on PP.lot = L.lot
where 
	LEN(mat.code) = 9 
	--and 
	--	(isnull(bd.description3,'') <>'Internal')
	 And Not pp.inventory is null
	and 
		(sp.id = pp.id and sp.siteid = 2) 
	and 
		(sp.Inventoryid <> pp.inventory 
		or sp.InventoryLocationID <> pp.invLocation 
		or sp.Palletid <> pp.Pallet 
		or SP.deviceid <> pp.Device 
		or pp.rtype <> sp.rtype 
		or pp.[weight] <> sp.[weight])
END
GO
