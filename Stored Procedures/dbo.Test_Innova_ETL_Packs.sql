SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <31/03/2017>
-- Description:	<FO_Innova into PackItem Table for reporting>
-- =============================================

--exec [dbo].[Test_Innova_ETL_Packs] 

CREATE PROCEDURE [dbo].[Test_Innova_ETL_Packs] 

AS

DECLARE @time datetime

Select @time = LRP.TimeIndicator
from [FFGData].[dbo].[tblLRP] as LRP
where LRP.TableName = 'tblPack' and [Site]='TEST'

create table #TMP2(
					[StockSite] nvarchar(22), [PackNumber] bigint,[OriginalSite] nvarchar(22), [SSCC] nvarchar(18), [LotCode] nvarchar(30) , [LotName] nvarchar(30) , [PalletNo] int, [ProductionDate] datetime, 
					[DeviceName] nvarchar(30), [UseByDate] datetime, [KillDate] datetime, [DNOB] datetime, [InventoryName] nvarchar(30), [InventoryStorage] nvarchar(80),
					[InventoryCategory] nvarchar(80), [InventoryLocation] nvarchar(80), [ProductCode] nvarchar(30),[ProductDescription] nvarchar(30), [CustomerBrandCode] int,
					[CustomerBrand] nvarchar(100), [FrozenGrouping] nvarchar(50), [MaterialType] nvarchar(50), [ProductSubGrouping] nvarchar(50) ,[FreshFrozen] nvarchar(30),
					[Weight] decimal (18,2), [Pieces] int, [Xacttime] datetime, [ProductionLocation] nvarchar(50), [InventoryTime] datetime, [BatchNumber] nvarchar(50)
					, [RegistrationTime] datetime, [PackRtype] int, [ICOR] NVARCHAR(80)
					,[MaterialNo] Bigint, [PackStatus] int, [MaterialExtCode] int
					,[Side] NVARCHAR (100),
					[YieldGroup] NVARCHAR(30),
					[PackBatch] NVARCHAR (30), [MeatId] int, [ProductionOrder] NVARCHAR(30), [OrderStatus] NVARCHAR(30), [OrderName] NVARCHAR(max), 
					[CustomerName] NVARCHAR(max), [OrderDispatchDate] datetime  )

INSERT INTO #TMP2

SELECT	'Foyle Test' as [StockSite], pp.number as PackNumber, sites.[name] as OrginalSite, pp.sscc as SSCC, PL.code AS LotCode, PL.[name] as LotName, IsNull(PC.number,'') as PalletNo, IsNull(PP.prday,'1753-01-01') as ProductionDate, 
		IsNull(BD.[name],'') as Device,
		IsNull(PP.expire1,'1753-01-01') as UseByDate, IsNull(PP.expire2,'1753-01-01') as KillDate, IsNull(PP.expire3,'1753-01-01') as DNOB, IsNull(PR.[name],'') AS InventoryName, IsNull(PR.description1,'') as InventoryStorage, 
		IsNull(PR.description3,'') as InventoryCategory, IsNull(INVLOC.[code],'') as InventoryLocation, IsNull(MAT.code,'') as ProductCode, IsNull(MAT.[name],'') as ProductDescription, 
		IsNull(MAT.condition,'') as CustomerBrandCode, IsNull(COND.[name],'') as CustomerBrand, IsNull(CONS.[name],'') as FrozenGrouping, IsNull(MATTYPE.[name],'') as MaterialType, IsNull(MAT.fabcode2,'') as ProductSubGrouping,
		IsNull(MAT.fabcode3,'') as FreshFrozen, PP.nominal as [Weight], PP.pieces as Pieces, pp.xacttime as Xacttime,
		Case When pp.porder Is Null Then 'OTHER' Else 'BH' End As 'ProductionLocation',
		pp.invtime As 'InventoryTime',
		(Case when co.extcode = 'Ireland 292 EC' then '2'
			when co.extcode = 'United Kingdom 9042 EC' then '3'
			when co.extcode = 'United Kingdom 9025 EC' then '6'
			when co.extcode = 'United Kingdom 9016 EC' then '1'
			when co.extcode = 'United Kingdom 2172 EC' then '5'
			when co.extcode = 'United Kingdom 2077 EC' then '4'
			when co.extcode Is Null then '0'
			END ) + substring(cast(datepart(yy, pp.prday)as nvarchar),4,1)
			+ RIGHT((datepart(year, pp.prday) * 1000 + datepart(dy, pp.prday)),3) + '' + RIGHT((datepart(year, pp.expire2) * 1000 + datepart(dy, pp.expire2)),3)
			+(Case when MATTYPE.description3 = '101 - PRIMAL' then 'A'
			when MATTYPE.description3 = '102 - VL' then 'B'
			when MATTYPE.description3 = '103 - OFFAL' then 'C'
			when MATTYPE.description3 Is Null then 'Z'
			END) 
			+ CAST(IsNull(pp.extnum,0) AS nvarchar(30)) 
			as 'BatchNumber'
			,ISNULL(pp.regtime,'1753-01-01'), ISNULL(pp.rtype,''), ISNULL(pp.extcode,''), ISNULL(MAT.material,''), ISNULL(pp.[status],''), ISNULL(MATTYPE.extcode,'')
			, ISNULL(MATTYPE.description2,''), ISNULL(PL.description8,'')
		    ,ISNULL(pp.batch,''), ISNULL(MATTYPE.dimension3,''), ISNULL(pp.porder,''),
			case when po.orderstatus = 1 then 'Closed'
			when po.orderstatus = 2 then 'Cancelled'
			when po.orderstatus = 3 then 'On Hold'
			when po.orderstatus = 4 then 'Open'
			when po.orderstatus = 5 then 'Complete'
			when po.orderstatus = 6 then 'Complete&Closed'
			when po.orderstatus = 7 then 'Dispatched'
			else 'No Status' END as orderstatus, po.[name] as OrderName, co2.[name] as CustomerName, po.dispatchtime 

FROM [test1-Innova].[dbo].[proc_packs] AS PP (nolock)

left join [test1-Innova].[dbo].[proc_lots] as PL with (nolock) on PL.lot = PP.lot
left join [test1-Innova].[dbo].[base_devices] as BD with (nolock) on BD.device = PP.device
left join [test1-Innova].[dbo].[proc_prunits] as PR with (nolock) on  PP.inventory=PR.prunit
left join [test1-Innova].[dbo].[proc_invlocations] as INVLOC with (nolock) on INVLOC.id = pp.invlocation
left join [test1-Innova].[dbo].[proc_materials] as MAT with (nolock) on MAT.material = PP.material
left join [test1-Innova].[dbo].[proc_conditions] as COND with (nolock) on COND.condition = MAT.condition
left join [test1-Innova].[dbo].[proc_conservations] as CONS with (nolock) on CONS.conservation = MAT.conservation
left join [test1-Innova].[dbo].[proc_materialtypes] as MATTYPE with (nolock) on MATTYPE.materialtype = MAT.materialtype
left join [test1-Innova].[dbo].[base_sites] as Sites with (nolock) on  Sites.[site] = pp.[site] -- added by KH -- Changed From Dimension1 to Site by MMG 06/04/2017
left join [test1-Innova].[dbo].[proc_collections] as PC with (nolock) on PC.id = PP.pallet
left join [test1-Innova].[dbo].[base_companies] co WITH (NOLOCK) on PL.processor = co.company
left join [test1-Innova].[dbo].[proc_orders] po with (nolock) on po.[order] = PP.[order]
left join [test1-Innova].[dbo].[base_companies] co2 WITH (NOLOCK) on co2.company = po.customer



WHERE pp.xacttime > @time and PP.rtype <> 4 --- packs are not deleted

Select  StockSite, PackNumber, OriginalSite, SSCC, LotCode, LotName , PalletNo, ProductionDate, [DeviceName], UseByDate, KillDate, DNOB, InventoryName, InventoryStorage, InventoryCategory, InventoryLocation, ProductCode,
		ProductDescription, CustomerBrandCode, CustomerBrand, FrozenGrouping, MaterialType, ProductSubGrouping, FreshFrozen, [Weight], Pieces, Xacttime,
		[ProductionLocation], [InventoryTime], [BatchNumber]
		,[RegistrationTime], [PackRtype], [ICOR] ,[MaterialNo], [PackStatus], [MaterialExtCode]
		, [Side], [YieldGroup] 
		,[PackBatch], [MeatId] , [ProductionOrder] , OrderStatus, OrderName, CustomerName, OrderDispatchDate
into #tmp
from #TMP2


Select * from #TMP

Merge [FFGData].dbo.tblPack AS pit
using #tmp AS tmp
on pit.sscc = tmp.sscc and pit.[StockSite] = 'Foyle Test'
	
	When Matched then
	Update
	Set pit.originalsite = tmp.[OriginalSite], pit.sscc = tmp.sscc, pit.lotcode = tmp.lotcode, pit.lotname = tmp.lotname, pit.[PalletNo] = tmp.palletno, pit.productiondate = tmp.productiondate, pit.devicename = tmp.devicename, pit.usebydate = tmp.usebydate,
	pit.killdate = tmp.killdate, pit.DNOB = tmp.DNOB, pit.InventoryName = tmp.inventoryname, pit.inventorystorage = tmp.inventorystorage, pit.inventorycategory = tmp.inventorycategory,
	pit.inventorylocation = tmp.inventorylocation, pit.productcode = tmp.productcode, pit.productdescription = tmp.productdescription, pit.customerbrandcode = tmp.customerbrandcode,
	pit.customerbrand = tmp.customerbrand, pit.frozengrouping = tmp.frozengrouping, pit.materialtype = tmp.materialtype, pit.productsubgrouping = tmp.productsubgrouping,
	pit.freshfrozen = tmp.freshfrozen, pit.[weight] = ISNULL(tmp.[weight],0.0), pit.pieces = tmp.pieces, pit.xacttime = tmp.xacttime, 
	pit.ProductionLocation = tmp.ProductionLocation, pit.[InventoryTime] = tmp.[InventoryTime], pit.[BatchNumber] = tmp.[BatchNumber]
	, pit.[RegistrationTime] = tmp.[RegistrationTime], pit.[PackRtype] = tmp.[PackRtype],
	pit.[ICOR] = tmp.[ICOR], pit.[MaterialNo] = tmp.[MaterialNo], pit.[PackStatus] = tmp.[PackStatus], pit.[MaterialExtCode]= tmp.[MaterialExtCode]
	,pit.[Side] = tmp.[Side], pit.[YieldGroup] = tmp.[YieldGroup]
	, pit.[PackBatch] = tmp.[PackBatch], pit.[MeatId] = tmp.[MeatId], pit.[ProductionOrder] = tmp.[ProductionOrder], pit.[OrderStatus] = tmp.[OrderStatus], 
	pit.[OrderName] = tmp.[OrderName], pit.[CustomerName] = tmp.[CustomerName], pit.[OrderDispatchDate] = tmp.[OrderDispatchDate]

	When Not Matched THEN
	Insert ([StockSite], [PackNumber], [OriginalSite],[SSCC], [LotCode], [LotName], [PalletNo], [ProductionDate], [DeviceName], [UseByDate], [KillDate], [DNOB], [InventoryName], [InventoryStorage]
			,[InventoryCategory], [InventoryLocation], [ProductCode],[ProductDescription], [CustomerBrandCode], [CustomerBrand] ,[FrozenGrouping], [MaterialType], [ProductSubGrouping]
			,[FreshFrozen], [Weight], [Pieces], [ProductionLocation], [InventoryTime], [BatchNumber], [xacttime]
			, [RegistrationTime], [PackRtype], [ICOR] ,[MaterialNo], [PackStatus], [MaterialExtCode]
			,[Side],[YieldGroup] 
			,[PackBatch], [MeatId] , [ProductionOrder], [OrderStatus],[OrderName],[CustomerName],[OrderDispatchDate])

	Values  (tmp.[StockSite], tmp.[PackNumber], tmp.[OriginalSite], tmp.[SSCC], tmp.[LotCode], tmp.[LotName], tmp.[PalletNo], tmp.[ProductionDate], tmp.[Devicename], tmp.[UseByDate], tmp.[KillDate], tmp.[DNOB],
			 tmp.[InventoryName], tmp.[InventoryStorage], tmp.[InventoryCategory], tmp.[InventoryLocation], tmp.[ProductCode], tmp.[ProductDescription], tmp.[CustomerBrandCode]
			 , tmp.[CustomerBrand] , tmp.[FrozenGrouping], tmp.[MaterialType], tmp.[ProductSubGrouping], tmp.[FreshFrozen], tmp.[Weight], tmp.[Pieces]
			 ,tmp.[ProductionLocation],tmp.[InventoryTime],tmp.[BatchNumber],tmp.[xacttime]
			 , tmp.[RegistrationTime], tmp.[PackRtype], tmp.[ICOR] ,tmp.[MaterialNo], tmp.[PackStatus], tmp.[MaterialExtCode]
			 , tmp.[Side], tmp.[YieldGroup]
			 ,tmp.[PackBatch], tmp.[MeatId] , tmp.[ProductionOrder], tmp.[OrderStatus], tmp.[OrderName],tmp.[CustomerName],tmp.[OrderDispatchDate]); 
 
Update [FFGData].[dbo].[tblLRP]
Set TimeIndicator =( Select TOP 1 Xacttime FROM [FFGData].[dbo].[tblPack] order by Xacttime desc)
From [FFGData].[dbo].[tblLRP] Where TableName='tblPack' and [Site] = 'TEST'

  drop table #TMP




  
GO
