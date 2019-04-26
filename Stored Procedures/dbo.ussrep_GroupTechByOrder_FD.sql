SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <26/07/17>
-- Description:	<GroupTechnicalReportByOrder>
-- =============================================
Create PROCEDURE [dbo].[ussrep_GroupTechByOrder_FD]
	-- Add the parameters for the stored procedure here
	@Order nvarchar(15)
AS
BEGIN

-- exec [dbo].[GroupTechByOrder] '236435'

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Select  pal.number as PalletNo,pm.code as Code ,pm.description1 as ProductName, pp.number as BoxNum, pp.expire2 as KillDate,pp.prday as PackDate, pp.expire1 as UseByDate, pp.expire3 as DNOBDate, pp.nominal as NetWeight, pc.[name] as BICountry, pc1.[name] as RICountry, bc.extcode as Slhouse,
			bc1.extcode as CutInHouse, pm.[value] as ValuePerKG, pl.[name] AS Lot, 
			case	when bc2.extcode = 'Ireland 292 EC' then '2'
					when bc2.extcode = 'United Kingdom 9042 EC' then '3'
					when bc2.extcode = 'United Kingdom 9025 EC' then '6'
					when bc2.extcode = 'United Kingdom 9016 EC' then '1'
					when bc2.extcode = 'United Kingdom 2172 EC' then '5'
					when bc2.extcode = 'United Kingdom 2077 EC' then '4'
					end as [Site],			
			  RIGHT(CAST(datepart(year, pp.expire2) * 1000 + datepart(dy, pp.expire2)as nvarchar),3) as Juliankill, 
			RIGHT(Cast(datepart(year, pp.prday) * 1000 + datepart(dy, pp.prday)as nvarchar(max)),3) as Julianpack, substring(cast(datepart(yy, pp.prday)as nvarchar),4,1) as YearofPack,
			Case	when pmt.description3 = '101 - PRIMAL' then 'A'
					when pmt.description3 = '102 - VL' then 'B'
					when pmt.description3 = '103 - OFFAL' then 'C'
					end as MaterialLetter, pp.extnum
	into #tmp
	from [FD_Innova].[dbo].proc_packs as pp
	left join [FD_Innova].[dbo].proc_materials as pm with (nolock) on pm.material = pp.material
	left join [FD_Innova].[dbo].proc_lots as pl with (nolock) on pl.lot = pp.lot
	left join [FD_Innova].[dbo].proc_countries as pc with (nolock) on pc.country = pl.brcountry
	left join [FD_Innova].[dbo].proc_countries as pc1 with (nolock) on pc1.country = pl.ricountry
	left join [FD_Innova].[dbo].base_companies as bc with (nolock) on bc.company = pl.slhouse
	left join [FD_Innova].[dbo].base_companies as bc1 with (nolock) on bc1.company = pl.customer
	left join [FD_Innova].[dbo].base_companies as bc2 with (nolock) on bc2.company = pl.processor
	left join [FD_Innova].[dbo].proc_materialtypes as pmt with (nolock) on pmt.materialtype = pm.materialtype
	left join [FD_Innova].[dbo].proc_orders as po with (nolock) on po.[order] = pp.[order]
	left join [FD_Innova].[dbo].proc_collections as pal with (nolock) on pal.pallet = pp.pallet

	where po.shname = @Order

	Select PalletNo,Code,ProductName,BoxNum, KillDate, PackDate, UseByDate, DNOBDate, NetWeight, BICountry, RICountry, Slhouse, CutInHouse, ValuePerKG, Lot,
	([Site] +''+ YearofPack+ '' + Juliankill+ '' + Julianpack + '' + MaterialLetter + '' + CAST(extnum AS nvarchar(2))) as BATCH
	from #tmp

	
END
GO
