SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin>
-- Create date: <16/06/2018>
-- Description:	<carcass stock>
-- =============================================
Create PROCEDURE [dbo].[usrrep_Carcass_Stock_Report_FD]

AS
BEGIN
Select 'FD' as [CurrentSite],bs.[name] as Originalsite,pit.extcode as ExtCode,pm.[name] as PRODUCT,pit.exday as KillDate, pit.nominal , pl.[name] as LOT, pit.rmarea,
		pr.[name] as Inventory,	MAX(pitx.regtime) as INVtime, DATEDIFF(DAY,MAX(pitx.regtime),GETDATE()) as [DaysInInv]

from [FD_Innova].[dbo].proc_items as pit
left join [FD_Innova].[dbo].proc_itemxacts as pitx with (nolock) on pitx.item = pit.id 
left join [FD_Innova].[dbo].proc_materials as pm with (nolock) on pm.material = pit.material
left join [FD_Innova].[dbo].proc_prunits as pr with (nolock) on pr.prunit = pit.inventory
left join [FD_Innova].[dbo].proc_lots as pl with (nolock) on pl.lot = pit.lot
left join [FD_Innova].[dbo].base_sites as bs with (nolock) on bs.[site] = pit.[site]
where pr.description3 = 'CARCASS'  and pit.rtype = '1' and pitx.xacttype = '1' -- rtype = 1 is item --xacttype is tranaction type 'To Inventory'

group by bs.[name], pm.[name], pit.exday, pit.nominal, pl.[name], pit.extcode,pr.[name], pit.rmarea

order by pm.[name], pit.exday
END
GO
