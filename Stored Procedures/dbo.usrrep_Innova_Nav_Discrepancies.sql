SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_Innova_Nav_Discrepancies]
	-- Add the parameters for the stored procedure here
	--dates 



AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	--foyle campsie
			select  o.[name]as [OrderNo],'FC' as [Site], sum(cast(pp.nominal as decimal(10,2))) as [WGT]
			into #tmp
			from [FFGSQL03].[FM_Innova].[dbo].[Proc_packs] pp 
			inner join [FFGSQL03].[FM_Innova].[dbo].[proc_orders] o with(nolock) on pp.[order] = o.[order]
			--19 = dispatch
			where pp.inventory = 19 and  CAST(pp.invtime as date) between '2018-04-27' and '2018-04-27' and o.orderstatus = 7 
			Group by o.[name]
		

	--foyle melton
			insert into #tmp
			select o.[name]as [OrderNo],'FD' as [Site],sum(pp.nominal) as [WGT]
			from [FFGSQL03].[FMM_innova].[dbo].[Proc_packs] pp 
			inner join [FFGSQL03].[FMM_innova].[dbo].[proc_orders] o with(nolock) on pp.[order] = o.[order]
			--19 = dispatch
			where pp.inventory = 4 and  CAST(pp.invtime as date) between '2018-04-27' and '2018-04-27' and o.orderstatus = 7 
			Group by o.[name]

	--foyle donegal
			insert into #tmp
			select  o.[name]as [OrderNo],'FD' as [Site],sum(pp.nominal) as [WGT]
			from [FFGSQL03].[FD_Innova].[dbo].[proc_packs] pp 
			inner join [FFGSQL03].[FD_Innova].[dbo].[proc_orders] o with(nolock) on pp.[order] = o.[order]
			--19 = dispatch
			where pp.inventory = 30 and  CAST(pp.invtime as date) between '2018-04-27' and '2018-04-27' and o.orderstatus = 7 
			Group by o.[name]

	--foyle gloucester
			insert into #tmp
			select  o.[name]as [OrderNo],'FG' as [Site],sum(pp.nominal) as [WGT]
			from [FFGSQL03].[FG_Innova].[dbo].[proc_packs] pp 
			inner join [FFGSQL03].[FG_Innova].[dbo].[proc_orders] o with(nolock) on pp.[order] = o.[order]
			--19 = dispatch
			where pp.inventory = 3 and  CAST(pp.invtime as date) between '2018-04-27' and '2018-04-27' and o.orderstatus = 7 
			Group by o.[name]

	--foyle hilton
			insert into #tmp
			select  o.[name]as [OrderNo],'FH' as [Site],sum(pp.nominal) as [WGT]
			from [FFGSQL03].[FH_innova].[dbo].[proc_packs] pp 
			inner join [FFGSQL03].[FH_innova].[dbo].[proc_orders] o with(nolock) on pp.[order] = o.[order]
			--19 = dispatch
			where pp.inventory = 17 and  CAST(pp.invtime as date) between '2018-04-27' and '2018-04-27' and o.orderstatus = 7 
			Group by o.[name]

	--foyle omagh
			insert into #tmp
			select  o.[name]as [OrderNo],'FO' as [Site],sum(pp.nominal) as [WGT]
			from [FFGSQL03].[FO_Innova].[dbo].[proc_packs] pp 
			inner join [FFGSQL03].[FO_Innova].[dbo].[proc_orders] o with(nolock) on pp.[order] = o.[order]
			--19 = dispatch
			where pp.inventory in (3,4) and  CAST(pp.invtime as date) between '2018-04-27' and '2018-04-27' and o.orderstatus = 7 
			Group by o.[name]

	--foyle ingredients 
			insert into #tmp
			select  o.[name]as [OrderNo],'FI' as [Site],sum(pp.nominal) as [WGT]
			from [FFGSQL03].[FI_Innova].[dbo].[proc_packs] pp 
			inner join [FFGSQL03].[FI_Innova].[dbo].[proc_orders] o with(nolock) on pp.[order] = o.[order]
			--19 = dispatch
			where pp.inventory in (3,4) and  CAST(pp.invtime as date) between '2018-04-27' and '2018-04-27' and o.orderstatus = 7 
			Group by o.[name]


			--innova
			--select * from #tmp
			--group by OrderNo, [Site], [WGT]

			select distinct ss.[Order No_] as [OrderNo], ss.[Shortcut Dimension 1 Code] as [Site], cast(ss.[Quantity Invoiced] as decimal(10,2)) as WGT  into #tmp2 
			from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] ss
			where cast(ss.[Shipment Date] as date) between '2017-09-27' and '2017-10-23' and ss.[Shortcut Dimension 1 Code] in ('FO','FD','FGL','FMM','FI','FH','FC') and ss.[Posting Group] not in ('PACKAGING') and ss.[Correction] = 0
			

			--nav
			--select t.[OrderNo],t.[Site], SUM(cast(t.WGT as decimal(10,2))) as WGT from #tmp2 t 
			--group by t.[OrderNo], t.[Site]
			--order by t.[Site]

			--select A.* from #tmp a
			--where not exists (
			--select b.* from #tmp2 b where a.OrderNo COLLATE DATABASE_DEFAULT = b.OrderNo and a.[Site] = b.[Site] and a.WGT = b.WGT
			--)

			select OrderNo, [Site], SUM(WGT) as WGT into #tmpI from #tmp
			group by OrderNo,[Site]

			--select * from #tmpI

			select OrderNo,[Site],SUM(WGT) as WGT into #tmpN from #tmp2
			group by [OrderNo], [Site]

			--Select * from #tmpN

			select distinct t1.*, t2.* from #tmpI t1 
			left join #tmpN t2 
			on t1.OrderNo collate database_default= t2.OrderNo 
			--group by t1.OrderNo, t1.[Site],t1.WGT, t2.OrderNo,t2.[Site],t2.WGT
			where t1.WGT < t2.WGT
		

			

			drop table #tmp,#tmp2
END
GO
