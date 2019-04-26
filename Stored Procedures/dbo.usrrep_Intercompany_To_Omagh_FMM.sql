SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe Maguire>
-- Create date: <Create Date,,12/09/17>
-- Description:	<Description,,Shows intercompany transfers from Foyle Campsie to Foyle omagh/ ingredients. A check is performed to see if it has been successfully received at omagh>
-- =============================================

-- EXEC [usrrep_Intercompany_To_Omagh] '2017-11-01','2017-11-06'
Create PROCEDURE [dbo].[usrrep_Intercompany_To_Omagh_FMM]

@StartDate datetime,
@EndDate datetime

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- insert all interco orders 
SELECT DISTINCT					pc.number as [Pallet No], PO.[name] as [Order No], BC.[name] AS [Customer],pm.[name] as [Product], 
							    Count(pp.sscc) as [Packs], Sum(pp.nominal) as [Total Wgt],pm.code as [Product Code], pru.[name] as [Inventory], cast(po.dispatchtime as date) as [Dispatch Time], 
								cast(SUM(pm.[value] * pp.nominal) as decimal(10,2)) as [Value],
								case when po.orderstatus = 1 then 'Closed'
                                    when po.orderstatus = 2 then 'Cancelled'
                                    when po.orderstatus = 3 then 'On Hold'
                                    when po.orderstatus = 4 then 'Open'
                                    when po.orderstatus = 5 then 'Complete'
                                    when po.orderstatus = 6 then 'Complete&Closed'
                                    when po.orderstatus = 7 then 'Dispatched' 
									else '' end as [Status]

INTO #tmp

FROM									[FMM_innova].[dbo].proc_collections pc

INNER JOIN [FMM_innova].[dbo].proc_packs pp with (nolock) on pc.id = pp.pallet
INNER JOIN [FMM_innova].[dbo].proc_materials pm with (nolock) on pp.material = pm.material
LEFT JOIN [FMM_innova].[dbo].proc_orders po with (nolock) on pc.[order] = po.[order]
LEFT JOIN [FMM_innova].[dbo].base_companies bc with(nolock) on po.customer = bc.company
LEFT JOIN [FMM_innova].[dbo].proc_prunits pru with(nolock) on pc.inventory = pru.prunit

WHERE									po.[name] like '%FFGSO%' and bc.[name] IN ('Foyle Ingredients','Foyle Gloucester','Foyle Campsie','Foyle Hilton','Foyle Donegal','Foyle Omagh','Donegal Meat Processors') 
GROUP BY								pc.number,pru.[name],po.[name], BC.[name],pm.[name],pm.code,po.dispatchtime,po.orderstatus

--select * from #tmp
--order by 1 desc
select number into #grouptmp from FO_Innova.dbo.proc_collections
insert into #grouptmp select number from FI_Innova.dbo.proc_collections
insert into #grouptmp select number from FD_Innova.dbo.proc_collections
insert into #grouptmp select number from FM_Innova.dbo.proc_collections
insert into #grouptmp select number from FG_innova.dbo.proc_collections
insert into #grouptmp select number from FH_innova.dbo.proc_collections

SELECT							[Pallet No],[Order No],[Customer],Product,[Product Code], Sum(Packs) As QtyPacks, Cast(SUM([Total Wgt]) AS decimal(10,2)) as TotWgt,
								[Dispatch Time] as [Dispatch Time],[Inventory],[Status], [Value]
INTO #tmp2
FROM #tmp
WHERE							
									--[Transaction Time] >= cast(getdate()-4 as date) 
									[Dispatch Time] between @StartDate and @EndDate
								and Customer IN ('Foyle Ingredients','Foyle Omagh','Foyle Campsie','Foyle Hilton','Foyle Donegal','Foyle Gloucester') 
GROUP BY			[Pallet No],[Inventory],[Order No], [Customer],Product,[Product Code],[Dispatch Time],[Inventory],[Status], [Value]
order by Customer

select #tmp2.*, case when exists(Select #grouptmp.number from #grouptmp where #grouptmp.number = #tmp2.[Pallet No]) and #tmp2.[Status] = 'Dispatched'
then 'YES' else 'NO' end as Complete from #tmp2

--Select #tmp2.*, case when b.number IS not null  then 'YES' else 'NO' end as TransferComplete 
--from #tmp2  left join (select distinct number from #grouptmp)b on #tmp2.[Pallet No] = b.number


DROP TABLE #tmp,#grouptmp,#tmp2

END
GO
