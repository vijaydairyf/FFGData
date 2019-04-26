SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,joe maguire>
-- Create date: <Create Date,,>
-- Description:	<Description,,a load of dung>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_PackagingData_OnRequest]
	-- Add the parameters for the stored procedure here

AS
BEGIN
--========================================================================================================================================================
--Foyle Omagh
--========================================================================================================================================================
select	  count(p.number) as PackQty
		 ,sum(p.curpieces)as QtyPieces
		 ,pm.code as productCode
		 ,o.[name] as OrderName
		 ,'FO' as SiteIdentifier
		
		 into #Iorders

from [FO_Innova].dbo.proc_packs p 
inner join [FO_Innova].dbo.proc_prunits r on p.inventory = r.prunit
inner join [FO_Innova].dbo.proc_orders o on p.[order] = o.[order]
inner join [FO_Innova].dbo.proc_materials as pm on p.material = pm.material
where cast(p.invtime as date) between '2018-01-01' and '2018-12-31' and r.prunit = 4 and p.rtype = 1
group by pm.code,o.[name]
--========================================================================================================================================================
--foyle campsie
--========================================================================================================================================================
insert into #Iorders
select	  count(p.number) as PackQty
		 ,sum(p.curpieces)as QtyPieces
		 ,pm.code as productCode
		 ,o.[name] as OrderName
		 ,'FC' as SiteIdentifier
		
from [FM_Innova].dbo.proc_packs p 
inner join [FM_Innova].dbo.proc_prunits r on p.inventory = r.prunit
inner join [FM_Innova].dbo.proc_orders o on p.[order] = o.[order]
inner join [FM_Innova].dbo.proc_materials as pm on p.material = pm.material
where cast(p.invtime as date) between '2018-01-01' and '2018-12-31' and r.prunit = 19 and p.rtype = 1
group by pm.code,o.[name]
--========================================================================================================================================================
--foyle donegal
--========================================================================================================================================================
insert into #Iorders
select	  count(p.number) as PackQty
		 ,sum(p.curpieces)as QtyPieces
		 ,pm.code as productCode
		 ,o.[name] as OrderName
		 ,'FD' as SiteIdentifier
		 
from [FD_Innova].dbo.proc_packs p 
inner join [FD_Innova].dbo.proc_prunits r on p.inventory = r.prunit
inner join [FD_Innova].dbo.proc_orders o on p.[order] = o.[order]
inner join [FD_Innova].dbo.proc_materials as pm on p.material = pm.material
where cast(p.invtime as date) between '2018-01-01' and '2018-12-31' and r.prunit = 30 and p.rtype = 1
group by pm.code,o.[name]
--========================================================================================================================================================
--foyle gloucester
--========================================================================================================================================================
insert into #Iorders
select	  count(p.number) as PackQty
		 ,sum(p.curpieces)as QtyPieces
		 ,pm.code as productCode
		 ,o.[name] as OrderName
		 ,'FG' as SiteIdentifier
			 
from [FG_Innova].dbo.proc_packs p 
inner join [FG_Innova].dbo.proc_prunits r on p.inventory = r.prunit
inner join [FG_Innova].dbo.proc_orders o on p.[order] = o.[order]
inner join [FG_Innova].dbo.proc_materials as pm on p.material = pm.material
where cast(p.invtime as date) between '2018-01-01' and '2018-12-31' and r.prunit = 3 and p.rtype = 1
group by pm.code,o.[name]
--========================================================================================================================================================
--foyle hilton
--========================================================================================================================================================
insert into #Iorders
select	  count(p.number) as PackQty
		 ,sum(p.curpieces)as QtyPieces
		 ,pm.code as productCode
		 ,o.[name] as OrderName
		 ,'FH' as SiteIdentifier
			 
from [FH_Innova].dbo.proc_packs p 
inner join [FH_Innova].dbo.proc_prunits r on p.inventory = r.prunit
inner join [FH_Innova].dbo.proc_orders o on p.[order] = o.[order]
inner join [FH_Innova].dbo.proc_materials as pm on p.material = pm.material
where cast(p.invtime as date) between '2018-01-01' and '2018-12-31' and r.prunit = 17 and p.rtype = 1
group by pm.code,o.[name]

--========================================================================================================================================================
--																Navision
--========================================================================================================================================================
select 
     case when FLSSH.[Ship-to Country_Region Code] in ('UK','GB','EN','NI','SC','WA') then 'UK' else FLSSH.[Ship-to Country_Region Code] end as ShipToCode
	 ,flp.code as PackagingCode
	 ,flp.Packaging as PackagingName
	 ,count(flp.Packaging) as CountP
	 ,i.SiteIdentifier
	 , FLSSH.[Gen_ Bus_ Posting Group]
	 

		into #navision

	 from ffgsql02.[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] as [FLSSH]
	 inner join ffgsql02.[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Line] as [FLSSL] on FLSSH.[Order No_] = FLSSL.[Order No_]
	 inner join ffgsql02.[FFG-Production].[dbo].[FFG LIVE$Packaging] as [FLP] on FLSSL.Packaging = FLP.code
	 inner join #Iorders as I on FLSSH.[Order No_] collate database_default = i.OrderName
	 where flssh.[ship-to Country_Region Code]in ('UK','GB','EN','NI','SC','WA') AND FLSSH.[Gen_ Bus_ Posting Group] NOT IN ('intercomp') --and flssl.Packaging <> 0
	 group by FLSSH.[Ship-to Country_Region Code],flp.code,flp.Packaging,i.SiteIdentifier , FLSSH.[Gen_ Bus_ Posting Group]
	 --,flssh.[Bill-to Country_Region Code],flssh.[Sell-to Country_Region Code]
	 order by FLSSH.[Ship-to Country_Region Code],flp.Code,i.SiteIdentifier

	 --SELECT * FROM #navision
--=================================================================================================================================================================
	 Select 
	 n.PackagingCode,n.PackagingName,n.ShipToCode,n.SiteIdentifier,sum(n.CountP)as OuterCase 
	 from #navision n
	 group by n.PackagingCode,n.PackagingName,n.ShipToCode,n.SiteIdentifier
	 ORDER BY n.SiteIdentifier

--========================================================================================================================================================
	 select sum(i.QtyPieces)as PackedPieces,i.productCode,i.SiteIdentifier 
	 from #Iorders i
	 inner join ffgsql02.[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header]  h with (nolock) on i.OrderName collate database_default = h.[order no_]
	 where h.[ship-to Country_Region Code] IN ('UK','GB','EN','NI','SC','WA') AND h.[Gen_ Bus_ Posting Group] NOT IN ('InterComp')
	 group by i.productCode,i.SiteIdentifier
	 order by i.SiteIdentifier,i.productCode
--========================================================================================================================================================


	 drop table #Iorders,#navision
--========================================================================================================================================================

END
GO
