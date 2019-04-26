SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- exec [dbo].[usr_Stock_Snapshot_KH]
-- select * from [Stock_SnapShot]
-- truncate table [dbo].[Stock_SnapShot]
CREATE procedure [dbo].[usr_Stock_Snapshot_KH]
as

insert into [FFGData].[dbo].[Stock_SnapShot]

select	Distinct
		
		convert(nvarchar(12),getdate(),102) as SnapShotDate, 
		'FC' as [site],
		pp.id as Packid,
		pr.[name] as Inventory,
		pp.sscc as SSCC,
		pp.weight as Nominal,
		pp.pallet as PalletId,
		pr2.[name] as DestinationInventory

--from
--		[FM_Innova].[dbo].proc_packs pk (nolock)
--		left join [FM_Innova].[dbo].proc_collections as pc with (nolock) on pc.id = pk.pallet
--		left join [FM_Innova].[dbo].proc_prunits as pr with (nolock) on pr.prunit = pc.inventory

		from [FM_Innova].[dbo].proc_packs as pp (nolock)
		left join [FM_Innova].[dbo].proc_collections as pc with (nolock) on pc.id = pp.pallet
		left join [FM_Innova].[dbo].proc_prunits as pr with (nolock) on pr.prunit = pc.inventory
		left join [FM_Innova].[dbo].proc_materials as pm with (nolock) on pm.material = pc.material
		left join [FM_Innova].[dbo].proc_matxacts as pmx with (nolock) on pmx.pack = pp.id
		left join [FM_Innova].[dbo].proc_xactpaths as xp with (nolock) on xp.xactpath = pmx.xactpath
		left join [FM_Innova].[dbo].proc_prunits as pr2 with (nolock) on pr2.prunit = xp.dstprunit
		
where	
		pr.prunit IN('106','110') 
		and pp.rtype <> 4

--insert into [dbo].[Stock_SnapShot]

--select	Distinct
		
--		convert(nvarchar(12),getdate(),102) as SnapShotDate, 
--		'FC' as [site],
--		pp.id as Packid,
--		pr.[name] as Inventory,
--		pp.sscc as SSCC,
--		pp.weight as Nominal,
--		pp.pallet as PalletId,
--		pr2.[name] as DestinationInventory
	
--	from [FH_Innova].[dbo].proc_packs as pp (nolock)
--		left join [FH_Innova].[dbo].proc_collections as pc with (nolock) on pc.id = pp.pallet
--		left join [FH_Innova].[dbo].proc_prunits as pr with (nolock) on pr.prunit = pc.inventory
--		left join [FH_Innova].[dbo].proc_materials as pm with (nolock) on pm.material = pc.material
--		left join [FH_Innova].[dbo].proc_matxacts as pmx with (nolock) on pmx.pack = pp.id
--		left join [FH_Innova].[dbo].proc_xactpaths as xp with (nolock) on xp.xactpath = pmx.xactpath
--		left join [FH_Innova].[dbo].proc_prunits as pr2 with (nolock) on pr2.prunit = xp.dstprunit
--where	
--		pr.prunit IN('49','47') 
--		and pp.rtype <> 4
GO
