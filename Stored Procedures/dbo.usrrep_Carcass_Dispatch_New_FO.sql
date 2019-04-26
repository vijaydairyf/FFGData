SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin>
-- Create date: <07/11/18>
-- Description:	<SSRS report Carcass Dispatch on new portal>
-- =============================================
-- [dbo].[usrrep_Carcass_Dispatch_New] '2018-08-06','2018-08-06'
Create PROCEDURE [dbo].[usrrep_Carcass_Dispatch_New_FO] 
	-- Add the parameters for the stored procedure here
	@From date,
	@to date
AS
BEGIN
--Declare @from date
--Declare @to date

--Set @from = '2018-08-06'
--Set @to = '2018-08-06'

Select 

i.[Site], i.number as ItemNo, cast(i.prday as date) as [Production], i.[weight] as [Weight], 
substring(i.extcode,5,4) as KillNo, o.[name] as OrderNo, r.[name] as Inventory,
m.[name] as Product, m.code as ProductCode,
substring(i.extcode,4,1) as qtr


--(Select count(number) from proc_items 
--Where inventory in (4) and cast(prday as date) between @from and @to group by substring(extcode,5,4)) as Qtr

into #tmp

From [FO_Innova].[dbo].proc_items i
inner join [FO_Innova].[dbo].proc_orders o on i.[order] = o.[order]
inner join [FO_Innova].[dbo].proc_prunits r on i.inventory = r.prunit
inner join [FO_Innova].[dbo].proc_materials m on m.material = i.material

Where r.prunit in (4) and cast(i.prday as date) between @from and @to

group by i.site,i.number, i.prday,i.weight,i.extcode,o.name,r.name,m.name,m.code


Select t.[site],t.ItemNo,t.Production,t.[Weight],t.KillNo,t.OrderNo,t.Inventory,t.Product,t.ProductCode,t.Qtr--,(select count(t2.KillNo) from #tmp t2 group by t2.killno)as qtr
 from #tmp t
 order by t.KillNo


 --select * from proc_prunits where name like '%dispat%'

drop table #tmp
END
GO
