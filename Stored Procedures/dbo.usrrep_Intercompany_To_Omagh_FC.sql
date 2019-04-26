SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe Maguire>
-- Create date: <Create Date,,12/09/17>
-- Description:	<Description,,Shows intercompany transfers from Foyle Campsie to Foyle omagh/ ingredients. A check is performed to see if it has been successfully received at omagh>
-- =============================================

-- EXEC [usrrep_Intercompany_To_Omagh] '2018-03-12','2018-03-12'
Create PROCEDURE [dbo].[usrrep_Intercompany_To_Omagh_FC]
@StartDate date,
@EndDate date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   
-- Selecting PalNo, product, pallet qty, total weight that is associated with an order. Performed on each sites innova (as sending site) to customer (receiving site)

SELECT 							pc.number as [Pallet No],pc.sscc as [SSCC], PO.[name] as [Order No], BC.[name] AS [Customer],pm.[name] as [Product], Count(pp.sscc) as [Packs],
										 Sum(pp.nominal) as [Total Wgt],pm.code as [Product Code], cast(po.dispatchtime as date) as [Dispatch Time],
										 pr.[name] as [Inventory],
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

FROM									[FM_Innova].[dbo].proc_collections pc

INNER JOIN [FM_Innova].[dbo].proc_packs pp with (nolock) on  pc.id = pp.pallet
INNER JOIN [FM_Innova].[dbo].proc_materials pm with (nolock) on pp.material = pm.material
LEFT JOIN [FM_Innova].[dbo].proc_orders po with (nolock) on pc.[order] = po.[order]
LEFT JOIN [FM_Innova].[dbo].base_companies bc with(nolock) on po.customer = bc.company
left join [FM_Innova].[dbo].proc_prunits pr with(nolock) on pp.inventory = pr.prunit


-- sales order and customer is Foyle
WHERE									po.[name] like '%FFGSO%' and bc.[name] IN ('Foyle Ingredients','Foyle Gloucester','Foyle Omagh','Foyle Hilton','Foyle Donegal','Foyle Melton Mowbray','Donegal Meat Processors') 
GROUP BY								pc.number,pc.sscc,po.[name], BC.[name],pm.[name],pm.code,po.dispatchtime,pr.[name],po.orderstatus


--selecting all the distinct pallet numbers from each of the innovas to perform the comparison. 
select pc.sscc,pru.[name] into #grouptmp from FG_innova.dbo.proc_collections pc  left join FG_innova.dbo.proc_prunits pru on pc.inventory = pru.prunit 
insert into #grouptmp select pc.sscc,pru.[name]  from FI_Innova.dbo.proc_collections pc left join FI_innova.dbo.proc_prunits pru on pc.inventory = pru.prunit 
insert into #grouptmp select pc.sscc,pru.[name]  from FD_Innova.dbo.proc_collections pc left join FD_innova.dbo.proc_prunits pru on pc.inventory = pru.prunit 
insert into #grouptmp select pc.sscc,pru.[name]  from FO_Innova.dbo.proc_collections pc left join FO_Innova.dbo.proc_prunits pru on pc.inventory = pru.prunit 
insert into #grouptmp select pc.sscc,pru.[name]  from FMM_innova.dbo.proc_collections pc left join FMM_innova.dbo.proc_prunits pru on pc.inventory = pru.prunit 
insert into #grouptmp select pc.sscc,pru.[name]  from FH_innova.dbo.proc_collections pc left join FH_innova.dbo.proc_prunits pru on pc.inventory = pru.prunit 


SELECT							[Pallet No],sscc,[Order No],[Customer],Product,[Product Code], Sum(Packs) As QtyPacks, Cast(SUM([Total Wgt]) AS decimal(10,2)) as TotWgt,
								[Dispatch Time] as [Dispatch Time],Inventory,[Status],[Value]

								into #tmp2
FROM #tmp

--selecting all the transfers from the past 4 days and where the customer equals each of the sites excluding the sending site. 
WHERE				[Dispatch Time] between @StartDate and @EndDate and Customer IN ('Foyle Ingredients','Foyle Omagh','Foyle Gloucester','Foyle Hilton','Foyle Donegal','Foyle Melton Mowbray')
GROUP BY			[Pallet No],sscc,[Order No], [Customer],Product,[Product Code],[Dispatch Time],Inventory,[Status], [Value]
order by Customer


--select #tmp2.[Pallet No], #grouptmp.number from #tmp2 left join #grouptmp on #tmp2.[Pallet No] = #grouptmp.number


select #tmp2.*,#grouptmp.[name] as CurInventory, case when exists(Select #grouptmp.sscc from #grouptmp where #grouptmp.sscc collate database_default = #tmp2.[SSCC]) and #tmp2.[Status] = 'Dispatched'
then 'YES' else 'NO' end as Complete from #tmp2
left join #grouptmp on  #tmp2.sscc collate database_default =  #grouptmp.sscc
--Select #tmp2.*, case when b.number IS not null  then 'YES' else 'NO' end as TransferComplete 
--from #tmp2  left join (select distinct number from #grouptmp)b on #tmp2.[Pallet No] = b.number


DROP TABLE #tmp,#tmp2,#grouptmp

END
GO
