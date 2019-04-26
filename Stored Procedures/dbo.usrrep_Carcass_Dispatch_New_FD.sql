SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- [dbo].[usrrep_Carcass_Dispatch_New] '2018-08-06','2018-08-06'
Create PROCEDURE [dbo].[usrrep_Carcass_Dispatch_New_FD] 
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

into #tmp

From [FD_Innova].[dbo].proc_items i
inner join [FD_Innova].[dbo].proc_orders o on i.[order] = o.[order]
inner join [FD_Innova].[dbo].proc_prunits r on i.inventory = r.prunit
inner join [FD_Innova].[dbo].proc_materials m on m.material = i.material

Where r.prunit in (37,30) and cast(i.prday as date) between @from and @to

group by i.site,i.number, i.prday,i.weight,i.extcode,o.name,r.name,m.name,m.code


Select t.[site],t.ItemNo,t.Production,t.[Weight],t.KillNo,t.OrderNo,t.Inventory,t.Product,t.ProductCode,t.qtr --,(select count(t2.KillNo) from #tmp t2 group by t2.killno)as qtr
 from #tmp t
 order by t.KillNo


-- Select * from proc_prunits where name like '%dispatch%'

drop table #tmp
END
GO
