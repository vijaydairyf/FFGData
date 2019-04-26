SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <18/06/18>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_PalletvsOrderline_Check_FD]
	-- Add the parameters for the stored procedure here
--exec [dbo].[usrrep_PalletvsOrderline_Check] '100547','317089'
 
 @palletnum nvarchar(15),
 @ordernum nvarchar(15)
AS

BEGIN
Select   pp.sscc,pp.prday, pp.expire2, pp.expire3, pp.expire1,pm.code, pm.[name],
						
						  	CAST(ISNULL(YEAR(pp.expire2)*1000+DATEPART(y,pp.expire2),'1753001') AS NVARCHAR(20))+
							CAST(ISNULL(YEAR(pp.prday)*1000+DATEPART(y,pp.prday),'1753001') AS NVARCHAR(20))+
							CAST(ISNULL(YEAR(pp.expire1)*1000+DATEPART(y,pp.expire1),'1753001') AS NVARCHAR(20))+
							CAST(ISNULL(YEAR(pp.expire3)*1000+DATEPART(y,pp.expire3),'1753001') AS NVARCHAR(20)) 
							+IsNull(pm.code,'123456789')
							+IsNull(pl.code,'123456789012')  as [ALL],

							CAST(ISNULL(YEAR(pp.expire2)*1000+DATEPART(y,pp.expire2),'1753001') AS NVARCHAR(20))+
							CAST(ISNULL(YEAR(pp.prday)*1000+DATEPART(y,pp.prday),'1753001') AS NVARCHAR(20))+
							CAST(ISNULL(YEAR(pp.expire1)*1000+DATEPART(y,pp.expire1),'1753001') AS NVARCHAR(20))+
							CAST(ISNULL(YEAR(pp.expire3)*1000+DATEPART(y,pp.expire3),'1753001') AS NVARCHAR(20)) 
							+IsNull(pm.code,'123456789') as [DATES],
						
							IsNull(pm.code,'123456789')
							+IsNull(pl.code,'123456789012') as [LOTS],

					
							IsNull(pl.code,'123456789') as [NONE]

into #tmp					
from [FD_Innova].[dbo].proc_packs as pp
left join [FD_Innova].[dbo].proc_collections as pc with (nolock) on pc.id = pp.pallet
left join [FD_Innova].[dbo].proc_lots as pl with (nolock) on pl.lot = pp.lot 
left join [FD_Innova].[dbo].proc_materials as pm with (nolock) on pm.material = pp.material
left join [FD_Innova].[dbo].proc_prunits as inv with (nolock) on inv.prunit = pp.inventory

where @palletnum = pc.number and inv.description2 = 'STOCK'


--Select * from #tmp

Select pol.id, SUBSTRING(pol.description6,2,(LEN(pol.description6)-1)) as text6
into #tmp2
from [FD_Innova].[dbo].proc_orders as po
left join [FD_Innova].[dbo].proc_orderl as pol with (nolock) on pol.[order] = po.[order]
where @ordernum = po.[shname] and pol.olstatus = '2' --- Open

--Select * from #tmp2

Select t.sscc, case when t.[ALL] = t2.text6 then 'ALL' 
					when t.DATES = t2.text6 then 'DATES'
					when t.LOTS = t2.text6 then 'LOTS'
					when t.[NONE] = t2.text6 then 'NONE'
					else 'No Match' end as [Con]
into #tmp3
from #tmp as t
inner join #tmp2 as t2 with (nolock) on t.[ALL] = t2.text6 or t.DATES = t2.text6 or t.LOTS = t2.text6 or t.[NONE] = t2.text6

--select * from #tmp3
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Select COUNT(pp.sscc) as QTY, pp.prday, pp.expire2, pp.expire3, pp.expire1, pm.code, pm.[name], 
							
							CAST(ISNULL(YEAR(pp.expire2)*1000+DATEPART(y,pp.expire2),'1753001') AS NVARCHAR(20))+
							CAST(ISNULL(YEAR(pp.prday)*1000+DATEPART(y,pp.prday),'1753001') AS NVARCHAR(20))+
							CAST(ISNULL(YEAR(pp.expire1)*1000+DATEPART(y,pp.expire1),'1753001') AS NVARCHAR(20))+
							CAST(ISNULL(YEAR(pp.expire3)*1000+DATEPART(y,pp.expire3),'1753001') AS NVARCHAR(20)) 
							+IsNull(pm.code,'123456789')
							+IsNull(pl.code,'123456789012')  as [ALL],

							CAST(ISNULL(YEAR(pp.expire2)*1000+DATEPART(y,pp.expire2),'1753001') AS NVARCHAR(20))+
							CAST(ISNULL(YEAR(pp.prday)*1000+DATEPART(y,pp.prday),'1753001') AS NVARCHAR(20))+
							CAST(ISNULL(YEAR(pp.expire1)*1000+DATEPART(y,pp.expire1),'1753001') AS NVARCHAR(20))+
							CAST(ISNULL(YEAR(pp.expire3)*1000+DATEPART(y,pp.expire3),'1753001') AS NVARCHAR(20)) 
							+IsNull(pm.code,'123456789') as [DATES],
						
							IsNull(pm.code,'123456789')
							+IsNull(pl.code,'123456789012') as [LOTS],

					
							IsNull(pl.code,'123456789') as [NONE],
							pl.[name] as LotName,
							pl.code as LotCode,
							SUM(CAST(pp.nominal AS DECIMAL(18,2))) AS KG

into #tmp4
from [FD_Innova].[dbo].proc_packs as pp
left join [FD_Innova].[dbo].proc_collections as pc with (nolock) on pc.id = pp.pallet
left join [FD_Innova].[dbo].proc_lots as pl with (nolock) on pl.lot = pp.lot 
left join [FD_Innova].[dbo].proc_materials as pm with (nolock) on pm.material = pp.material
left join [FD_Innova].[dbo].proc_prunits as inv with (nolock) on inv.prunit = pp.inventory
where @palletnum = pc.number and inv.description2 = 'STOCK'

group by pp.prday, pp.expire2, pp.expire3, pp.expire1, pm.code, pm.[name], pl.code, pl.[name]

--select * from #tmp4

Select pol.id, SUBSTRING(pol.description6,2,(LEN(pol.description6)-1)) as text6, (pol.maxamount-ISNULL(pol.curamount,0)) as RemQty, pol.description2
into #tmp5
from [FD_Innova].[dbo].proc_orders as po
left join [FD_Innova].[dbo].proc_orderl as pol with (nolock) on pol.[order] = po.[order]
where @ordernum = po.[shname]

--select * from #tmp5

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Create table table1( ProductName nvarchar(max), Productcode nvarchar(max), prday date, expire2 date, expire3 date, 
					expire1 date, ISSUE nvarchar(50),OrderlineQTY nvarchar(10), PalletQTY nvarchar(10), AmountDiff nvarchar(10), UnitType NVARCHAR(10))

INSERT into table1
Select pm.[name] as ProductName, pm.code as productcode, pp.prday, pp.expire2, pp.expire3,pp.expire1, 'Date Issue' as ISSUE, 
		' ' as OrderlineQTY, ' ' as PalletQTY ,' ' as AmountDiff, ''

from [FD_Innova].[dbo].proc_packs as pp
left join [FD_Innova].[dbo].proc_collections pc with (nolock) on pc.id= pp.pallet
left join [FD_Innova].[dbo].proc_lots as pl with (nolock) on pl.lot = pp.lot 
left join [FD_Innova].[dbo].proc_materials as pm with (nolock) on pm.material = pp.material
left join #tmp3 as t3 with (nolock) on t3.sscc = pp.sscc
left join [FD_Innova].[dbo].proc_prunits as inv with (nolock) on inv.prunit = pp.inventory

where pc.number = @palletnum and t3.Con IS NULL and inv.description2 = 'STOCK'

Order by 1 desc

INSERT into table1
Select t4.[name] as ProductName, t4.code as productcode, t4.prday, t4.expire2, t4.expire3, t4.expire1, 'Amount Issue' as ISSUE , 
t5.RemQty as OrderlineQTY, 
CASE WHEN t5.description2 = 'KG' then SUM(t4.KG)
	 WHEN t5.description2 = 'CASE' THEN SUM(t4.qty) END AS PalletQty,
CASE WHEN t5.description2 = 'CASE' then(SUM(t4.qty-t5.RemQty))
	 WHEN t5.description2 = 'KG' THEN (SUM(t4.kg-t5.RemQty)) END  as AmountDiff,
	 
	t5.description2
from #tmp4 as t4
inner join #tmp5 as t5 with (nolock) on t4.[ALL] = t5.text6 or t4.DATES = t5.text6 or t4.LOTS = t5.text6 or t4.[NONE] = t5.text6
group by t4.[name], t4.code , t4.prday, t4.expire2, t4.expire3, t4.expire1, t5.RemQty, t5.description2
having t5.RemQty < SUM(t4.QTY) OR t5.RemQty < SUM(t4.KG)

Select * from table1




 
drop table #tmp
drop table #tmp2
drop table #tmp3
drop table #tmp4
drop table #tmp5
drop table table1
END

--Select   pp.sscc,pp.prday, pp.expire2, pp.expire3, pp.expire1,pm.code, pm.[name],
						
--						  	CAST(ISNULL(YEAR(pp.expire2)*1000+DATEPART(y,pp.expire2),'1753001') AS NVARCHAR(20))+
--							CAST(ISNULL(YEAR(pp.prday)*1000+DATEPART(y,pp.prday),'1753001') AS NVARCHAR(20))+
--							CAST(ISNULL(YEAR(pp.expire1)*1000+DATEPART(y,pp.expire1),'1753001') AS NVARCHAR(20))+
--							CAST(ISNULL(YEAR(pp.expire3)*1000+DATEPART(y,pp.expire3),'1753001') AS NVARCHAR(20)) 
--							+IsNull(pm.code,'123456789')
--							+IsNull(pl.code,'123456789012')  as [ALL],

--							CAST(ISNULL(YEAR(pp.expire2)*1000+DATEPART(y,pp.expire2),'1753001') AS NVARCHAR(20))+
--							CAST(ISNULL(YEAR(pp.prday)*1000+DATEPART(y,pp.prday),'1753001') AS NVARCHAR(20))+
--							CAST(ISNULL(YEAR(pp.expire1)*1000+DATEPART(y,pp.expire1),'1753001') AS NVARCHAR(20))+
--							CAST(ISNULL(YEAR(pp.expire3)*1000+DATEPART(y,pp.expire3),'1753001') AS NVARCHAR(20)) 
--							+IsNull(pm.code,'123456789') as [DATES],
						
--							IsNull(pm.code,'123456789')
--							+IsNull(pl.code,'123456789012') as [LOTS],

					
--							IsNull(pl.code,'123456789') as [NONE]

--into #tmp					
--from [FD_innova].[dbo].proc_packs as pp
--left join [FD_innova].[dbo].proc_collections as pc with (nolock) on pc.id = pp.pallet
--left join [FD_innova].[dbo].proc_lots as pl with (nolock) on pl.lot = pp.lot 
--left join [FD_innova].[dbo].proc_materials as pm with (nolock) on pm.material = pp.material
--left join [FD_innova].[dbo].proc_prunits as inv with (nolock) on inv.prunit = pp.inventory

--where @palletnum = pc.number and inv.description2 = 'STOCK'


----Select * from #tmp

--Select pol.id, SUBSTRING(pol.description6,2,(LEN(pol.description6)-1)) as text6
--into #tmp2
--from [FD_innova].[dbo].proc_orders as po
--left join [FD_innova].[dbo].proc_orderl as pol with (nolock) on pol.[order] = po.[order]
--where @ordernum = po.[shname] and pol.olstatus = '2' --- Open

----Select * from #tmp2

--Select t.sscc, case when t.[ALL] = t2.text6 then 'ALL' 
--					when t.DATES = t2.text6 then 'DATES'
--					when t.LOTS = t2.text6 then 'LOTS'
--					when t.[NONE] = t2.text6 then 'NONE'
--					else 'No Match' end as [Con]
--into #tmp3
--from #tmp as t
--inner join #tmp2 as t2 with (nolock) on t.[ALL] = t2.text6 or t.DATES = t2.text6 or t.LOTS = t2.text6 or t.[NONE] = t2.text6

----select * from #tmp3
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Select COUNT(pp.sscc) as QTY, pp.prday, pp.expire2, pp.expire3, pp.expire1, pm.code, pm.[name], 
							
--							CAST(ISNULL(YEAR(pp.expire2)*1000+DATEPART(y,pp.expire2),'1753001') AS NVARCHAR(20))+
--							CAST(ISNULL(YEAR(pp.prday)*1000+DATEPART(y,pp.prday),'1753001') AS NVARCHAR(20))+
--							CAST(ISNULL(YEAR(pp.expire1)*1000+DATEPART(y,pp.expire1),'1753001') AS NVARCHAR(20))+
--							CAST(ISNULL(YEAR(pp.expire3)*1000+DATEPART(y,pp.expire3),'1753001') AS NVARCHAR(20)) 
--							+IsNull(pm.code,'123456789')
--							+IsNull(pl.code,'123456789012')  as [ALL],

--							CAST(ISNULL(YEAR(pp.expire2)*1000+DATEPART(y,pp.expire2),'1753001') AS NVARCHAR(20))+
--							CAST(ISNULL(YEAR(pp.prday)*1000+DATEPART(y,pp.prday),'1753001') AS NVARCHAR(20))+
--							CAST(ISNULL(YEAR(pp.expire1)*1000+DATEPART(y,pp.expire1),'1753001') AS NVARCHAR(20))+
--							CAST(ISNULL(YEAR(pp.expire3)*1000+DATEPART(y,pp.expire3),'1753001') AS NVARCHAR(20)) 
--							+IsNull(pm.code,'123456789') as [DATES],
						
--							IsNull(pm.code,'123456789')
--							+IsNull(pl.code,'123456789012') as [LOTS],

					
--							IsNull(pl.code,'123456789') as [NONE],
--							pl.[name] as LotName,
--							pl.code as LotCode

--into #tmp4
--from [FD_innova].[dbo].proc_packs as pp
--left join [FD_innova].[dbo].proc_collections as pc with (nolock) on pc.id = pp.pallet
--left join [FD_innova].[dbo].proc_lots as pl with (nolock) on pl.lot = pp.lot 
--left join [FD_innova].[dbo].proc_materials as pm with (nolock) on pm.material = pp.material
--left join [FD_innova].[dbo].proc_prunits as inv with (nolock) on inv.prunit = pp.inventory
--where @palletnum = pc.number and inv.description2 = 'STOCK'

--group by pp.prday, pp.expire2, pp.expire3, pp.expire1, pm.code, pm.[name], pl.code, pl.[name]

----select * from #tmp4

--Select pol.id, SUBSTRING(pol.description6,2,(LEN(pol.description6)-1)) as text6, (pol.maxamount-ISNULL(pol.curamount,0)) as RemQty
--into #tmp5
--from [FD_innova].[dbo].proc_orders as po
--left join [FD_innova].[dbo].proc_orderl as pol with (nolock) on pol.[order] = po.[order]
--where @ordernum = po.[shname]

----select * from #tmp5

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Create table table1( ProductName nvarchar(max), Productcode nvarchar(max), prday date, expire2 date, expire3 date, expire1 date, ISSUE nvarchar(50),OrderlineQTY nvarchar(10), PalletQTY nvarchar(10), AmountDiff nvarchar(10))

--INSERT into table1
--Select pm.[name] as ProductName, pm.code as productcode, pp.prday, pp.expire2, pp.expire3,pp.expire1, 'Date Issue' as ISSUE, 
--		' ' as OrderlineQTY, ' ' as PalletQTY ,' ' as AmountDiff

--from [FD_innova].[dbo].proc_packs as pp
--left join [FD_innova].[dbo].proc_collections pc with (nolock) on pc.id= pp.pallet
--left join [FD_innova].[dbo].proc_lots as pl with (nolock) on pl.lot = pp.lot 
--left join [FD_innova].[dbo].proc_materials as pm with (nolock) on pm.material = pp.material
--left join #tmp3 as t3 with (nolock) on t3.sscc = pp.sscc
--left join [FD_innova].[dbo].proc_prunits as inv with (nolock) on inv.prunit = pp.inventory

--where pc.number = @palletnum and t3.Con IS NULL and inv.description2 = 'STOCK'

--Order by 1 desc

--INSERT into table1
--Select t4.[name] as ProductName, t4.code as productcode, t4.prday, t4.expire2, t4.expire3, t4.expire1, 'Amount Issue' as ISSUE , t5.RemQty as OrderlineQTY, SUM(t4.qty) as PalletQty,(SUM(t4.qty-t5.RemQty)) as AmountDiff
--from #tmp4 as t4
--inner join #tmp5 as t5 with (nolock) on t4.[ALL] = t5.text6 or t4.DATES = t5.text6 or t4.LOTS = t5.text6 or t4.[NONE] = t5.text6
--group by t4.[name], t4.code , t4.prday, t4.expire2, t4.expire3, t4.expire1, t5.RemQty
--having t5.RemQty < SUM(t4.QTY)

--Select * from table1




 
--drop table #tmp
--drop table #tmp2
--drop table #tmp3
--drop table #tmp4
--drop table #tmp5
--drop table table1
--END
GO
