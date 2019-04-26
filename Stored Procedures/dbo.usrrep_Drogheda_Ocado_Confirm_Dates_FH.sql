SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <08/06/18>
-- Description:	<Confirm Dates for Drogheda & Ocado>
-- =============================================
Create PROCEDURE [dbo].[usrrep_Drogheda_Ocado_Confirm_Dates_FH]


	-- exec [dbo].[usrrep_Drogheda_Ocado_Confirm_Dates] '145198'

@extnum nvarchar(20)


AS
BEGIN
	
select 'Use by' , sh.[External Document No_] as PO, pm.code, pm.[name], pol.amount, pol.expire1max as Useby,  pol.expire3max as DNOB
from [FH_innova].[dbo].proc_orders as po 
left join [FH_innova].[dbo].proc_orderl as pol with (nolock) on pol.[order] = po.[order]
left join [FH_innova].[dbo].proc_materials as pm with (nolock) on pm.material = pol.material
left join [ffgsql01].[FFG-Production].[dbo].[FFG LIVE$Sales Header] as sh with (nolock) on sh.No_ COLLATE DATABASE_DEFAULT =  po.[name]
where sh.[External Document No_] = @extnum
and pol.expire1max <= DateAdd(DD,7,sh.[Shipment Date] ) 

union

select 'DNOB', sh.[External Document No_] as PO, pm.code, pm.[name], pol.amount, pol.expire1max as Useby,  pol.expire3max as DNOB
from [FH_innova].[dbo].proc_orders as po 
left join[FH_innova].[dbo]. proc_orderl as pol with (nolock) on pol.[order] = po.[order]
left join [FH_innova].[dbo].proc_materials as pm with (nolock) on pm.material = pol.material
left join [ffgsql01].[FFG-Production].[dbo].[FFG LIVE$Sales Header] as sh with (nolock) on sh.No_ COLLATE DATABASE_DEFAULT =  po.[name]
where sh.[External Document No_] = @extnum
and pol.expire3max >= sh.[Shipment Date]
	
END
GO
