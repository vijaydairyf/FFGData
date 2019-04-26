SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe Maguire>
-- Create date: <Create Date,,12/09/17>
-- Description:	<Description,,Shows intercompany transfers from Foyle Campsie to Foyle omagh/ ingredients. A check is performed to see if it has been successfully received at omagh>
-- =============================================

-- EXEC [usrrep_Intercompany_]'2018-03-12','2018-03-12'
Create PROCEDURE [dbo].[usrrep_Intercompany_FO]

@StartDate date,
@EndDate date

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT 							pc.number as [Pallet No],pc.sscc as SSCC,PO.[name] as [Order No], BC.[name] AS [Customer],pm.[name] as [Product], Count(pp.sscc) as [Packs], 
										Sum(pp.nominal) as [Total Wgt],	pm.code as [Product Code],pr.[name] as [Inventory], CAST(po.dispatchtime as date) as [Dispatch Time],
										cast(SUM(pm.[value] * pp.nominal) as decimal(10,2)) as [Value],
										
										case when po.orderstatus = 1 then 'Closed'
                                    when po.orderstatus = 2 then 'Cancelled'
                                    when po.orderstatus = 3 then 'On Hold'
                                    when po.orderstatus = 4 then 'Open'
                                    when po.orderstatus = 5 then 'Complete'
                                    when po.orderstatus = 6 then 'Complete&Closed'
                                    when po.orderstatus = 7 then 'Dispatched' 
									else 'null' end as [Status]

INTO #tmp

FROM									[FO_Innova].[dbo].proc_collections pc

INNER JOIN [FO_Innova].[dbo].proc_packs pp with (nolock) on pc.id = pp.pallet
INNER JOIN [FO_Innova].[dbo].proc_materials pm with (nolock) on pp.material = pm.material
LEFT JOIN [FO_Innova].[dbo].proc_orders po with (nolock) on pc.[order] = po.[order]
LEFT JOIN [FO_Innova].[dbo].base_companies bc with(nolock) on po.customer = bc.company
LEFT JOIN [FO_Innova].[dbo].proc_prunits pr with(nolock) on pp.inventory = pr.prunit

WHERE				po.[name] like '%FFGSO%' and bc.[name]IN ('Foyle Ingredients','Foyle Gloucester','Foyle Campsie','Foyle Hilton','Foyle Donegal','Foyle Melton Mowbray','Donegal Meat Processors') 
GROUP BY			pc.number,pc.sscc,po.[name], BC.[name],pm.[name],pm.code,pr.[name],po.dispatchtime, po.orderstatus



select pc.sscc,pru.[name] into #grouptmp from FG_innova.dbo.proc_collections pc  left join FG_innova.dbo.proc_prunits pru on pc.inventory = pru.prunit 
insert into #grouptmp select pc.sscc,pru.[name]  from FI_Innova.dbo.proc_collections pc left join FI_innova.dbo.proc_prunits pru on pc.inventory = pru.prunit 
insert into #grouptmp select pc.sscc,pru.[name]  from FD_Innova.dbo.proc_collections pc left join FD_innova.dbo.proc_prunits pru on pc.inventory = pru.prunit 
insert into #grouptmp select pc.sscc,pru.[name]  from FM_Innova.dbo.proc_collections pc left join FM_innova.dbo.proc_prunits pru on pc.inventory = pru.prunit 
insert into #grouptmp select pc.sscc,pru.[name]  from FMM_innova.dbo.proc_collections pc left join FMM_innova.dbo.proc_prunits pru on pc.inventory = pru.prunit 
insert into #grouptmp select pc.sscc,pru.[name]  from FH_innova.dbo.proc_collections pc left join FH_innova.dbo.proc_prunits pru on pc.inventory = pru.prunit 



SELECT							[Pallet No],[SSCC],[Order No],[Customer],Product,[Product Code], Sum(Packs) As QtyPacks, Cast(SUM([Total Wgt]) AS decimal(10,2)) as TotWgt,
								[Dispatch Time] as [DispatchTime], [Inventory],[Status], [Value]
into				 #tmp2
FROM				 #tmp
WHERE							--[Dispatch Time] >= cast(getdate()-4 as date)

[Dispatch Time]between @StartDate and @EndDate and Customer IN ('Foyle Ingredients','Foyle Gloucester','Foyle Campsie','Foyle Hilton','Foyle Donegal','Foyle Melton	Mowbray','Donegal Meat Processors') 
GROUP BY							[Pallet No],SSCC,[Order No], [Customer],Product,[Product Code],[Dispatch Time],[Inventory],[Status],[Value]
order by Customer

select #tmp2.*,#grouptmp.[name] as CurInventory ,case when exists(Select #grouptmp.sscc from #grouptmp where #grouptmp.sscc = #tmp2.SSCC) and #tmp2.[Status] = 'Dispatched'
then 'YES' else 'NO' end as Complete from #tmp2
left join #grouptmp on #tmp2.sscc = #grouptmp.sscc


--Select #tmp2.*, case when b.number IS not null  then 'YES' else 'NO' end as TransferComplete 
--from #tmp2  left join (select distinct number from #grouptmp)b on #tmp2.[Pallet No] = b.number


DROP TABLE #tmp, #grouptmp,#tmp2
END
GO
