SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <31/03/2017>
-- Description:	<FMM_Innova into PackItem Table for reporting>
-- =============================================

--exec [dbo].[FM_Innova_ETL_Items] 

CREATE PROCEDURE [dbo].[FM_Innova_ETL_Items] 

AS

DECLARE @time datetime

Select @time = LRP.TimeIndicator
from [FFGData].[dbo].[tblLRP] as LRP
where LRP.TableName = 'tblItems' and [Site]='FC'


SELECT	'Foyle Campsie' as [StockSite], PItems.number as ItemNumber, SUBSTRING(Pitems.extcode,1,1) as OriginalSite, ISNULL(pitems.extcode ,'')as ExternalCode, PL.code as LotCode, PL.[name] as LotName, IsNull(PItems.prday,'1753-01-01') as ProductionDate,
		IsNull(BD.[name],'') as [DeviceName], IsNull(PItems.expire1,'1753-01-01') as UseByDate, ISNULL(PR.[name],'') as ItemInventory,
		IsNull(MAT.code,'') as ProductCode, IsNull(MAT.[name],'') as ProductDescription, PItems.nominal as ItemNominal, PItems.regtime as ItemRegtime,
		PItems.oweight as OriginalWeight, SUBSTRING(pitems.extcode, 2,2) as WeekNo, SUBSTRING (pitems.extcode,4,1) as Part, SUBSTRING(pitems.extcode, 5,4) as KillNo,
		ISNULL(PItems.parentitem,'') as ParentItem, ISNULL(BE.[name],'') as Employee, ISNULL(PItems.yieldgroup,'') as YieldGroup, ISNULL(PItems.tare,'') as ItemTare, ISNULL(PItems.rtype,'') as ItemRtype,
		ISNULL(PItems.[weight],'') as ItemWeight, ISNULL(PMX.id,'') as ItemID, ISNULL(PMX.xactpath,'') as Xactpath, ISNULL(pmx.regtime,'1753-01-01') as XactRegtime, ISNULL(pmx.rtype,'') as XactRtype, 
		ISNULL(pmx.batch,'') as Batch,	ISNULL(pmx.[weight],'') as XactWeight, ISNULL(pmx.cday,'') as ManualKillNo, ISNULL(PL2.[name],'') as ToLotName, ISNULL(PL2.[code],'') as ToLotCode, ISNULL(PL2.dimension1,'') as BoningHallLotId, ISNULL(PMX.item,'') as XactItem, ISNULL(PMX.pack,'') as XactPack
		,ISNULL(pmx.prday,'1753-01-01') as XactProductionDate, ISNULL(XP.description1,'') as XactPathDescription

into #tmp2
FROM [FM_Innova].[dbo].[proc_items] AS PItems (nolock)

left join [FM_Innova].[dbo].[proc_lots] as PL with (nolock) on PL.lot = PItems.lot
left join [FM_Innova].[dbo].[base_devices] as BD with (nolock) on BD.device = PItems.device
left join [FM_Innova].[dbo].[proc_prunits] as PR with (nolock) on  PItems.inventory=PR.prunit
left join [FM_Innova].[dbo].[proc_invlocations] as INVLOC with (nolock) on INVLOC.id = PItems.invlocation
left join [FM_Innova].[dbo].[proc_materials] as MAT with (nolock) on MAT.material = PItems.material
left join [FM_Innova].[dbo].[proc_materialtypes] as MATTYPE with (nolock) on MATTYPE.materialtype = MAT.materialtype
left join [FM_Innova].[dbo].[base_employees] as BE with (nolock) on BE.employee = PItems.employee
left join [FM_Innova].[dbo].[proc_matxacts] as PMX with (nolock) on PMX.item = PItems.id
left join [FM_Innova].[dbo].[proc_lots] as PL2 with (nolock) on PL2.lot = PMX.tolot
left join [FM_Innova].[dbo].[proc_xactpaths] as XP with (nolock) on XP.xactpath = PMX.xactpath



WHERE PItems.prday > @time

Select  StockSite, ItemNumber,
		
		Case	when OriginalSite = '1' then 'Foyle Campsie'
				when OriginalSite = '2' then 'Foyle Donegal'
				when OriginalSite = '3' then 'Foyle Omagh'
				when OriginalSite = '4' then 'Foyle Melton Mowbray'
				when OriginalSite = '5' then 'Foyle Gloucester'	
		
		END as OriginalSite,

		ExternalCode, LotCode, LotName, ProductionDate,DeviceName, UseByDate, ItemInventory, ProductCode, ProductDescription,
		ItemNominal, ItemRegtime, OriginalWeight, WeekNo,
		
		Case	when Part= '1' then 'FQ'
				when Part= '2' then 'HQ'
				when Part= '3' then 'FQ'
				when Part= '4' then 'HQ'
		End as Part,

		KillNo, ParentItem, Employee, YieldGroup, ItemTare, ItemRtype, ItemWeight, ItemID, Xactpath, XactRegtime, XactRtype, Batch, XactWeight, ManualKillNo, ToLotCode,
		ToLotName, BoningHallLotId,XactItem, XactPack,XactProductionDate, XactPathDescription
															
into #tmp
from #tmp2


Select * from #tmp


Merge [FFGData].dbo.tblItems AS pit
using #tmp AS tmp
on pit.ItemNumber = tmp.ItemNumber and pit.itemID = tmp.itemID and pit.[StockSite] = 'Foyle Campsie'
	
	When Matched then
	Update
	Set pit.StockSite = tmp.Stocksite, pit.ItemNumber = tmp.ItemNumber, pit.OriginalSite = tmp.OriginalSite, pit.ExternalCode = tmp.ExternalCode, pit.LotCode = tmp.LotCode, pit.LotName = tmp.LotName, pit.ProductionDate = tmp.ProductionDate, pit.DeviceName = tmp.DeviceName,
	pit.UseByDate = tmp.UseByDate, pit.ItemInventory = tmp.ItemInventory, pit.ProductCode = tmp.ProductCode, pit.ProductDescription = tmp.ProductDescription, pit.ItemNominal = tmp.ItemNominal,
	pit.ItemRegtime = tmp.ItemRegtime, pit.OriginalWeight = tmp.OriginalWeight, pit.WeekNo = tmp.WeekNo, pit.Part = tmp.Part,
	pit.KillNo = tmp.KillNo, pit.ParentItem = tmp.ParentItem, pit.Employee = tmp.Employee, pit.YieldGroup = tmp.YieldGroup,
	pit.ItemTare = tmp.ItemTare, pit.ItemRtype = tmp.ItemRtype, pit.ItemWeight = tmp.ItemWeight, pit.ItemID = tmp.ItemID, 
	pit.Xactpath = tmp.Xactpath, pit.XactRegtime = tmp.XactRegtime, pit.XactRtype = tmp.XactRtype, pit.Batch = tmp.Batch, pit.XactWeight = tmp.XactWeight, pit.ManualKillNo = tmp.ManualKillNo,
	pit.ToLotCode = tmp.ToLotCode, pit.ToLotName = tmp.ToLotName, pit.BoningHallLotId = tmp.BoningHallLotId, pit.XactItem = tmp.XactItem, pit.XactPack = tmp.XactPack
	,pit.XactProductionDate = tmp.XactProductionDate, pit.XactPathDescription = tmp.XactPathDescription

	When Not Matched THEN
	Insert ([StockSite],[ItemNumber], [OriginalSite],[ExternalCode],[LotCode], [LotName],[ProductionDate], [DeviceName], [UseByDate],[ItemInventory], [ProductCode],[ProductDescription], [ItemNominal], [ItemRegtime] ,[OriginalWeight], [WeekNo], [Part]
			,[KillNo], [ParentItem], [Employee], [YieldGroup], [ItemTare], [ItemRtype], [ItemWeight],[ItemID],[Xactpath],[XactRegtime],[XactRtype],[Batch],[XactWeight],[ManualKillNo],
			[ToLotCode], [ToLotName], [BoningHallLotId], [XactItem], [XactPack], [XactProductionDate],[XactPathDescription])

	Values  (tmp.[StockSite], tmp.[ItemNumber], tmp.[OriginalSite], tmp.[ExternalCode], tmp.[LotCode], tmp.[LotName], tmp.[ProductionDate], tmp.[Devicename], tmp.[UseByDate], tmp.[ItemInventory], tmp.[ProductCode],
			 tmp.[ProductDescription], tmp.[ItemNominal], tmp.[ItemRegtime], tmp.[OriginalWeight], tmp.[WeekNo], tmp.[Part], tmp.[KillNo]
			 , tmp.[ParentItem] , tmp.[Employee], tmp.[YieldGroup], tmp.[ItemTare], tmp.[ItemRtype], tmp.[ItemWeight], tmp.[ItemID]
			 ,tmp.[Xactpath],tmp.[XactRegtime],tmp.[XactRtype],tmp.[Batch], tmp.[XactWeight], tmp.[ManualKillNo],tmp.[ToLotCode], tmp.[ToLotName], tmp.[BoningHallLotId], tmp.[XactItem], tmp.[XactPack]
			 , tmp.[XactProductionDate], tmp.[XactPathDescription] ); 
 
Update [FFGData].[dbo].[tblLRP]
Set TimeIndicator =( Select TOP 1 ItemRegtime FROM [FFGData].[dbo].[tblItems] where stocksite = 'Foyle Campsie' order by ItemRegtime desc)
From [FFGData].[dbo].[tblLRP] Where TableName='tblItems' and [Site] = 'FM'

  drop table #TMP2
  drop table #TMP
 
 --Truncate table[dbo].[tblItems]
GO
