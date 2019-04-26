SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usrrep_BoningHall_LastRecord]

AS
BEGIN

Declare @start date
Declare @end date

Set @start = GETDATE()
set @end = GETDATE()

Select top 1  'Foyle Omagh' as [Site],p.number ,p.regtime--,o.name
into #tmpfo
from FO_Innova.dbo.proc_packs p
--inner join proc_orders o on p.porder = o.[order]
where p.porder is not null and cast(p.regtime as date) between @start and @end
order by regtime desc

Select top 1  'Foyle Campsie' as [Site],p.number ,p.regtime--,o.name
into #tmpfc
from FM_Innova.dbo.proc_packs p
--inner join proc_orders o on p.porder = o.[order]
where p.porder is not null and cast(p.regtime as date) between @start and @end
order by regtime desc

Select top 1  'Foyle Donegal' as [Site],p.number ,p.regtime--,o.name
into #tmpfd
from FD_Innova.dbo.proc_packs p
--inner join proc_orders o on p.porder = o.[order]
where p.porder is not null and cast(p.regtime as date) between @start and @end
order by regtime desc

Select top 1  'Foyle Gloucester' as [Site],p.number ,p.regtime--,o.name
into #tmpfg
from FG_Innova.dbo.proc_packs p
--inner join proc_orders o on p.porder = o.[order]
where p.porder is not null and cast(p.regtime as date) between @start and @end
order by regtime desc

Select top 1  'Foyle Hilton' as [Site],p.number ,p.regtime--,o.name
into #tmpfh
from FH_Innova.dbo.proc_packs p
--inner join proc_orders o on p.porder = o.[order]
where p.porder is not null and cast(p.regtime as date) between @start and @end
order by regtime desc


select * from #tmpfc
union
Select * from #tmpfo
union 
select * from #tmpfd
union 
select * from #tmpfg
union 
Select * from #tmpfh


drop table #tmpfc,#tmpfd,#tmpfg,#tmpfo,#tmpfh





END
GO
