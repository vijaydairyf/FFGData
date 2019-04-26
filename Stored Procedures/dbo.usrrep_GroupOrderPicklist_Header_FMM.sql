SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <24/07/2017>
-- Description:	<Group Picklist Report>
-- =============================================
Create PROCEDURE [dbo].[usrrep_GroupOrderPicklist_Header_FMM]

--exec [dbo].[usrrep_GroupOrderPicklist_Header] '236435'

-- Add the parameters for the stored procedure here
	@Site nvarchar(5),
	@fromshipdate date,
	@toshipdate date,
	@Shipmethod nvarchar(max),
	@extcoldstore nvarchar(max),
	@OrderNo nvarchar(max)
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

Declare @OrderNoParamTable Table ( OrderNoParaValues Nvarchar(max) )
DECLARE @SQL VARCHAR(MAX)
SELECT  @SQL = 'SELECT ''' + REPLACE  (@OrderNo,',',''' UNION SELECT ''') + ''''

 INSERT INTO @OrderNoParamTable																-----Breakdown of Born In COuntry parameter
 (OrderNoParaValues)
 EXEC (@SQL)

 -----------------------------------------------------------------------------------------------------------------------------

DECLARE @TotalKGQTY decimal(18,2)
Declare @TotalCSQTY decimal(18,2)


SET @TotalKGQTY = (Select SUM(CAST(sl.[Original Ordered Qty_] as decimal(18,2))) as TotalKGQTY

			 from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Header] as sh 
		     left join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Line] as sl with (nolock) on sl.[Document No_] = sh.[No_]				---added by Kh to get sum of Nav Qty
			 left join [FMM_innova].[dbo].proc_orders as po with (nolock) on po.[name]COLLATE DATABASE_DEFAULT =  sh.[No_] 

			 	where 
					sh.[Shortcut Dimension 1 Code] = @Site -- changed temp KH 
					and sh.[Shipment Method Code] = @Shipmethod 
					and po.[name] IN ( Select OrderNoParaValues from @OrderNoParamTable) 
					and  cast(sh.[Shipment Date] as date) BETWEEN @fromshipdate and @toshipdate 
					 and LEN(sl.[No_]) = 9
					 and sl.[Ordered UOM] = 'KG'

					group by sl.[Ordered UOM] )

					Print @TotalKGQTY

SET @TotalCSQTY = (Select SUM(CAST(sl.[Ordered Qty_] as decimal(18,2))) as TotalCSQTY

			 from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Header] as sh 
		     left join [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Sales Line] as sl with (nolock) on sl.[Document No_] = sh.[No_]				---added by Kh to get sum of Nav Qty
			 left join [FMM_innova].[dbo].proc_orders as po with (nolock) on po.[name]COLLATE DATABASE_DEFAULT =  sh.[No_] 

			 	where 
					sh.[Shortcut Dimension 1 Code] = @Site -- changed temp KH 
					and sh.[Shipment Method Code] = @Shipmethod 
					and po.[name] IN ( Select OrderNoParaValues from @OrderNoParamTable) 
					and  cast(sh.[Shipment Date] as date) BETWEEN @fromshipdate and @toshipdate 
					 and LEN(sl.[No_]) = 9
					 and sl.[Ordered UOM] = 'CASE'

					group by sl.[Ordered UOM] )

					Print @TotalCSQTY

				
--------------------------------------------------------------------------------------------------------------------------------------------


    -- Insert statements for procedure here

Select  po.[name] as OrderNo ,
				sl.[No_] as ProductCode,
				bc.[name] as Customer, 
				cast(po.dispatchtime as date) as DispatchTime, 
				sl.[description] as ProductDescription,
		 SUM(pol.curamount) as QtyScanned,
			SUM(pol.maxamount) as InnovaQty, 
		case when sl.[Ordered UOM] = 'KG' then CAST(sl.[Original Ordered Qty_] as decimal(18,2)) 
			 when sl.[Ordered UOM] = 'CASE' then CAST(sl.[Ordered Qty_] as decimal(18,2)) 
			 END as OrderQty, 
		@TotalCSQTY as totalCSQty,
		@TotalKGQTY as totalKGQty, --- added by kh to get nav qty
		sh.[Shipment Method Code] as [TransportMethod],
		sh.[created by user],
		sh.[Delivery Date],
		sh.[Ship-to Name],
		sh.[Ship-to Address],
		sh.[Ship-to Address 2],
		sh.[Ship-to City],
		sh.[Sell-to Customer Name],
case
when pol.olstatus = 1 then 'Closed'
when pol.olstatus= 2 then 'Open'
when pol.olstatus= 3 then 'Complete'
when pol.olstatus= 4 then 'Cancelled'
when pol.olstatus= 5 then 'Complete'
when pol.olstatus= 6 then 'Complete&Closed'
when pol.olstatus= 7 then 'Dispatched'
else 'Not Allocated'
END as orderstatus, pol.olstatus,
pol.ValidLots as Lots, pol.prdaymax as ProductionDay, pol.expire1max as UseByDate, pol.expire3max as DNOB, pol.expire2max as KillDate, sl.[Ordered UOM] as UOM,
Case when substring(pol.description6,1,1) = 0 THEN 'All'
	 when substring(pol.description6,1,1) = 1 THEN 'Dates'
	 when substring(pol.description6,1,1) = 2 THEN 'Lots'
	 when substring(pol.description6,1,1) = 3 THEN 'None'
	 end	as Constraints,
	 pol.description6

	from [ffgsql01].[FFG-Production].[dbo].[FFG LIVE$Sales Header] as sh 
		left join [ffgsql01].[FFG-Production].[dbo].[FFG LIVE$Sales Line] as sl with (nolock) on sl.[Document No_] = sh.[No_] 
		left join [FMM_innova].[dbo].proc_orders as po with (nolock) on po.[name]COLLATE DATABASE_DEFAULT =  sh.[No_] 
		left join [FMM_innova].[dbo].proc_materials as pm with (nolock) on  sl.No_ COLLATE DATABASE_DEFAULT = pm.extcode 
		left join [FMM_innova].[dbo].proc_orderl as pol with (nolock) on po.[order] = pol.[order] and pol.material = pm.material
		left join [FMM_innova].[dbo].base_companies as bc with (nolock) on bc.company = po.customer

	where 
	sh.[Shortcut Dimension 1 Code] = @Site 
	and sh.[Shipment Method Code] = @Shipmethod 
	and 
	po.[name] COLLATE DATABASE_DEFAULT IN ( Select OrderNoParaValues from @OrderNoParamTable) 
	and  cast(sh.[Shipment Date] as date) BETWEEN @fromshipdate and @toshipdate 
	and LEN(sl.[No_]) = 9
	
	
group by po.[name],bc.[name] , po.dispatchtime, pol.olstatus,sh.[Shipment Method Code],
	pol.ValidLots, pol.prdaymax, pol.expire1max, pol.expire2max, pol.expire3max,
	 sh.[created by user],
		sh.[Delivery Date],
		sh.[Ship-to Name],
		sh.[Ship-to Address],
		sh.[Ship-to Address 2],
		sh.[Ship-to City],
		sl.[Original Ordered Qty_],
	sl.[description],
	sl.[No_],
	sl.[Ordered Qty_],
	sl.[Ordered UOM],
	pol.description6,
	sh.[Sell-to Customer Name]

	order by sl.[No_]



	
	--select * from proc_orders where [name] = 'FFGSO253284'
	--select * from proc_orderl where [order] = '106947'

		
END
GO
