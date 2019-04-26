SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,joe	>
-- Create date: <Create Date,,>
-- Description:	<Description,,Danish crown wanted a specific del note. Can add more customers if needs be>
-- =============================================
--exec [dbo].[usrrep_CompanyDel_Note] '4057','300851'
Create PROCEDURE [dbo].[usrrep_CompanyDel_Note_FH]
			@Customer nvarchar(250),
			@Order nvarchar(15)
			
		
				

AS
BEGIN
Declare @PONum nvarchar(25)

Set @PONum = ((Select [External Document No_] from  FFGSQL01.[FFG-Production].[dbo].[FFG LIVE$Sales Header] where substring([No_],6,12) = @Order
union
Select [External Document No_] from  FFGSQL01.[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] where substring([Order No_],6,12) = @Order))
--select @PONum

Select			count(pp.id) as Quantity, cast(sum(pp.nominal)as decimal(18,2))as [Weight],po.[name] as OrderNO,pc.number as Pallet, pm.[code] as ProductCode, pm.[name] as Product,b.code ,b.[name],
				
				left(l.[name],2) as SLin, substring(l.name,3,4) as BonedIn,

				format(pp.prday,'dd/MM/yy') as PackDate,format(pp.expire1,'dd/MM/yy') as UseBy,format(pp.expire2,'dd/MM/yy')as KillDate,format(po.dispatchtime,'dd/MM/yy') as Dispatchtime, @PONum as PONum,
				sum(pp.pieces)as Pieces

From [FH_Innova].[dbo].proc_packs pp (nolock)
inner join [FH_Innova].[dbo].proc_materials pm with(nolock) on pp.material = pm.material 
left join [FH_Innova].[dbo].proc_collections pc with(nolock) on pp.pallet = pc.id
inner join [FH_Innova].[dbo].proc_lots l on pp.lot = l.lot
inner join [FH_Innova].[dbo].proc_orders po with(nolock) on pp.[order] = po.[order]
inner join [FH_Innova].[dbo].base_companies b with(nolock) on b.company = po.customer
where po.shname = @Order and b.code = @Customer 
 group by po.[name], pc.number, pm.code,pm.[name],b.code,b.[name],pp.prday,pp.expire2,pp.expire1,po.dispatchtime,l.name
 order by pc.number,pp.prday,pp.expire1,pp.expire2 desc



END
GO
