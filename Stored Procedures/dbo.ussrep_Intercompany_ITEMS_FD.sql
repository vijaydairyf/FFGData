SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [ussrep_Intercompany_ITEMS_FD]'2018-06-11','2018-06-13'
Create PROCEDURE [dbo].[ussrep_Intercompany_ITEMS_FD]
@StartDate datetime,
@EndDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

-- sending site
  SELECT DISTINCT				 a.[name] as [Order No],m.[code] as [Product Code],m.[name] as [Product],b.extcode,
								--count(b.extcode)as QTY,
								b.nominal as [WGT],b.[value] as [Value],
								 bc.[name] as [Rec Site], a.dispatchtime as [Dispatch Time], pr.[name] as [Inventory], case when a.orderstatus = 1 then 'Closed'
																							  when a.orderstatus = 2 then 'Cancelled'
																							  when a.orderstatus = 3 then 'On Hold'
																							  when a.orderstatus = 4 then 'Open'
																							  when a.orderstatus = 5 then 'Complete'
																							  when a.orderstatus = 6 then 'Complete and Closed'
																							  when a.orderstatus = 7 then 'Dispatched'
																							  else 'null' 
																							  end as [Order Status]
	into #tmp
  FROM							[FD_Innova].[dbo].proc_orders a

  left JOIN [FD_Innova].[dbo].proc_items b on a.[order] = b.[order]
  left JOIN [FD_Innova].[dbo].base_companies bc on a.customer = bc.company
  left JOIN [FD_Innova].[dbo].proc_materials m on b.material = m.material
  left join [FD_Innova].[dbo].proc_prunits pr with(nolock) on b.inventory = pr.prunit

  WHERE							m.dimension1 in('70','10') and m.dimension2 = '14' and
								bc.[name] IN ('Foyle Ingredients','Foyle Gloucester','Foyle Campsie','Foyle Hilton','Foyle Omagh','Foyle Melton Mowbray') and cast(a.begtime as date) between @StartDate and @EndDate

  GROUP BY						m.code,a.[name],m.[name],bc.[name], a.dispatchtime,b.nominal,b.[value], b.extcode,pr.[name], a.orderstatus


-- select * from #tmp
	--receiving site
	--Select * from #tmp where #tmp.extcode = '436180070000'

	select extcode into #grouptmp from FO_Innova.dbo.proc_items where prday between @StartDate -7 and @EndDate
insert into #grouptmp select extcode from FI_Innova.dbo.proc_items where prday between @StartDate -7 and @EndDate
insert into #grouptmp select extcode from FD_Innova.dbo.proc_items where prday between @StartDate -7 and @EndDate
insert into #grouptmp select extcode from FM_Innova.dbo.proc_items where prday between @StartDate -7 and @EndDate
insert into #grouptmp select extcode from FH_innova.dbo.proc_items where prday between @StartDate -7 and @EndDate
insert into #grouptmp select extcode from FG_innova.dbo.proc_items where prday between @StartDate -7 and @EndDate


SELECT #tmp.*, 
			case when exists(select #grouptmp.extcode from #grouptmp where #grouptmp.extcode = #tmp.extcode) and #tmp.[Order Status] = 'Dispatched'
			then 'YES' else 'NO' end as Complete

			into #tmp2
			from #tmp


			select * from #tmp2
			--select #grouptmp.extcode, #tmp.extcode from #grouptmp inner join #tmp on #grouptmp.extcode = #tmp.extcode where #tmp.extcode = '437385420000'

			--select * from #tmp2 where [Dispatch Time] between @StartDate and @EndDate order by [Dispatch Time]
drop table #tmp,#grouptmp,#tmp2


END
GO
