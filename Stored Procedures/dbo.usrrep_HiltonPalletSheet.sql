SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <26/09/18>
-- Description:	<Hilton retail pallet info>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_HiltonPalletSheet]
	
	-- exec [dbo].[usrrep_HiltonPalletSheet] 'FD','340907'
@Site nvarchar(10),
@POnumber nvarchar(100)

AS
BEGIN

IF @Site = 'FC'

BEGIN
Select sh.[Delivery Date], DATENAME(dw,sh.[Delivery Date]) as DOW ,sh.[External Document No_] as PO, 'Foyle Campsie UK 9016 EC' as Supplier 
from [ffgsql03].[FM_Innova].[dbo].[proc_orders] as po
left join [ffgsql02].[FFG-Production].[dbo].[FFG LIVE$Sales Header] sh with (nolock) on sh.No_ COLLATE DATABASE_DEFAULT =  po.[name]
where po.[name] = ('FFGSO' + @POnumber)
END

IF @Site = 'FD'
BEGIN
Select sh.[Delivery Date], DATENAME(dw,sh.[Delivery Date]) as DOW ,sh.[External Document No_] as PO, 'Foyle Donegal IE 292 EC' as Supplier 
from [ffgsql03].[FD_Innova].[dbo].[proc_orders] as po
left join [ffgsql02].[FFG-Production].[dbo].[FFG LIVE$Sales Header] sh with (nolock) on sh.No_ COLLATE DATABASE_DEFAULT =  po.[name]
where po.[name] = ('FFGSO' + @POnumber)
END

IF @Site = 'FH'
BEGIN
Select sh.[Delivery Date], DATENAME(dw,sh.[Delivery Date]) as DOW ,sh.[External Document No_] as PO, 'Foyle Hilton UK 9025 EC' as Supplier 
from [ffgsql03].[FH_Innova].[dbo].[proc_orders] as po
left join [ffgsql02].[FFG-Production].[dbo].[FFG LIVE$Sales Header] sh with (nolock) on sh.No_ COLLATE DATABASE_DEFAULT =  po.[name]
where po.[name] = ('FFGSO' + @POnumber)
END

IF @Site = 'FO'
BEGIN
Select sh.[Delivery Date], DATENAME(dw,sh.[Delivery Date]) as DOW ,sh.[External Document No_] as PO, 'Foyle Omagh UK 9042 EC' as Supplier 
from [ffgsql03].[FO_Innova].[dbo].[proc_orders] as po
left join [ffgsql02].[FFG-Production].[dbo].[FFG LIVE$Sales Header] sh with (nolock) on sh.No_ COLLATE DATABASE_DEFAULT =  po.[name]
where po.[name] = ('FFGSO' + @POnumber)
END

IF @Site = 'FG'
BEGIN
Select sh.[Delivery Date], DATENAME(dw,sh.[Delivery Date]) as DOW ,sh.[External Document No_] as PO, 'Foyle Gloucester UK 2172 EC' as Supplier 
from [ffgsql03].[FG_Innova].[dbo].[proc_orders] as po
left join [ffgsql02].[FFG-Production].[dbo].[FFG LIVE$Sales Header] sh with (nolock) on sh.No_ COLLATE DATABASE_DEFAULT =  po.[name]
where po.[name] = ('FFGSO' + @POnumber)
END

IF @Site = 'FMM'
BEGIN
Select sh.[Delivery Date], DATENAME(dw,sh.[Delivery Date]) as DOW ,sh.[External Document No_] as PO, 'Foyle Melton Mowbray UK 2077 EC' as Supplier 
from [ffgsql03].[FMM_Innova].[dbo].[proc_orders] as po
left join [ffgsql02].[FFG-Production].[dbo].[FFG LIVE$Sales Header] sh with (nolock) on sh.No_ COLLATE DATABASE_DEFAULT =  po.[name]
where po.[name] = ('FFGSO' + @POnumber)
END

END
GO
