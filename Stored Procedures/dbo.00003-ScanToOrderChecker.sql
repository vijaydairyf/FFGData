SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [00003-ScanToOrderChecker] 'FFGSO320624','FC'

CREATE PROCEDURE [dbo].[00003-ScanToOrderChecker]

@Order NVarChar(Max),  -- Have this passing through before going live.
@FFGSite NVarChar(Max)

AS

Declare @SiteID NVarChar(100)
Set @SiteID=(Case When @FFGSite='FC' Then '1' When @FFGSite='FO' Then '2' When @FFGSite='FH' Then '3' When @FFGSite='FD' Then '4' 
When @FFGSite='FGL' Then '5' When @FFGSite='FMM' Then '6' End)

Declare @InnovaOrder NVarChar(50)

Select @InnovaOrder=(Select Top 1 [order]  FROM   [FD_Innova].dbo.proc_orders AS po WITH (nolock) WHERE po.code  = @Order)

Delete From tblHrOrdersChecker Where NavSalesOrder = @Order


IF @SiteID='1' 
	BEGIN
		INSERT INTO tblHROrdersChecker
		(
		SSite, SiteName, NavSalesOrder, ProductCode, ProductDescription, KillDate, ProductionDate, DNOB, UseByDate, PalletNo, Qty, HRBoxNo
		)

		SELECT				'FC', 'Foyle Campsie', po.code  as OrderNo, 
							mat1.code AS Product, mat1.name AS Description,    pl.expire2min AS Killdate, 
							pl.prdaymin  AS PackDate, pl.expire3min AS DNOB, pl.expire1min AS UseBy, '999999' As 'PalletNo'
							, pl.maxamount As 'Qty',
							case
							when po.orderstatus = 1 then 'Closed'
							when po.orderstatus = 2 then 'Cancelled'
							when po.orderstatus = 3 then 'On Hold'
							when po.orderstatus = 4 then 'Open'
							when po.orderstatus = 5 then 'Complete'
							when po.orderstatus = 6 then 'Complete & Closed'
							when po.orderstatus = 7 then 'Dispatched'
							else 'No Status'
							end as [Status]
		FROM   [FM_Innova].dbo.proc_orders AS po WITH (nolock)
		Inner Join [FM_Innova].dbo.proc_orderl (NOLOCK) pl On po.[order]=pl.[order]    
		inner join [FM_Innova].dbo.proc_materials AS mat1 WITH (nolock) on  pl.material = mat1.material  
		WHERE po.code  = @Order

		UNION ALL

		Select 'FC', 'Foyle Campsie', po.[name] As 'OrderNo', mat1.code As 'Product',  mat1.[name] AS 'Description',pp.expire2 As 'KillDate',
		pp.prday As 'PackDate', pp.expire3 As 'DNOB', pp.expire1 As 'UseBy',  
		pc.number As 'PalletNo', Count(pp.sscc) As Qty, 'Scanned' As 'Status'
		From [FM_Innova].dbo.proc_packs (NoLock) pp 
		Left Join [FM_Innova].dbo.proc_orders AS po WITH (nolock) on pp.[order]=po.[order]
		Inner Join [FM_Innova].dbo.proc_collections pc On pp.pallet=pc.id
		inner join [FM_Innova].dbo.proc_materials AS mat1 WITH (nolock) on  pp.material = mat1.material  
		Where pp.[order]=@InnovaOrder
		Group By 
		Grouping Sets 
		(
		(po.[name], pp.prday, pp.expire1, pp.expire2, pp.expire3,  mat1.code, mat1.[name]), 
		(po.[name], pp.prday, pp.expire1, pp.expire2, pp.expire3,  mat1.code, pc.number, mat1.[name]) 
		)

		Select SSite, SiteName, NavSalesOrder, ProductCode, ProductDescription, KillDate, ProductionDate, DNOB, UseByDate, PalletNo, Qty, HRBoxNo
		From tblHROrdersChecker
		Where NavSalesOrder=@Order
		Order By HRBoxNo, ProductCode,KillDate, ProductionDate, DNOB, UseByDate, Qty
	END

IF @SiteID = '2'
	BEGIN
		INSERT INTO tblHROrdersChecker
		(
		SSite, SiteName, NavSalesOrder, ProductCode, ProductDescription, KillDate, ProductionDate, DNOB, UseByDate, PalletNo, Qty, HRBoxNo
		)

		SELECT				'FO', 'Foyle Omagh', po.code  as OrderNo, 
							mat1.code AS Product, mat1.name AS Description,    pl.expire2min AS Killdate, 
							pl.prdaymin  AS PackDate, pl.expire3min AS DNOB, pl.expire1min AS UseBy, '999999' As 'PalletNo'
							, pl.maxamount As 'Qty',
							case
							when po.orderstatus = 1 then 'Closed'
							when po.orderstatus = 2 then 'Cancelled'
							when po.orderstatus = 3 then 'On Hold'
							when po.orderstatus = 4 then 'Open'
							when po.orderstatus = 5 then 'Complete'
							when po.orderstatus = 6 then 'Complete & Closed'
							when po.orderstatus = 7 then 'Dispatched'
							else 'No Status'
							end as [Status]
		FROM   [FO_Innova].dbo.proc_orders AS po WITH (nolock)
		Inner Join [FO_Innova].dbo.proc_orderl (NOLOCK) pl On po.[order]=pl.[order]    
		inner join [FO_Innova].dbo.proc_materials AS mat1 WITH (nolock) on  pl.material = mat1.material  
		WHERE po.code  = @Order

		UNION ALL

		Select 'FO', 'Foyle Omagh', po.[name] As 'OrderNo', mat1.code As 'Product',  mat1.[name] AS 'Description',pp.expire2 As 'KillDate',
		pp.prday As 'PackDate', pp.expire3 As 'DNOB', pp.expire1 As 'UseBy',  
		pc.number As 'PalletNo', Count(pp.sscc) As Qty, 'Scanned' As 'Status'
		From [FO_Innova].dbo.proc_packs (NoLock) pp 
		Left Join [FO_Innova].dbo.proc_orders AS po WITH (nolock) on pp.[order]=po.[order]
		Inner Join [FO_Innova].dbo.proc_collections pc On pp.pallet=pc.id
		inner join [FO_Innova].dbo.proc_materials AS mat1 WITH (nolock) on  pp.material = mat1.material  
		Where pp.[order]=@InnovaOrder
		Group By 
		Grouping Sets 
		(
		(po.[name], pp.prday, pp.expire1, pp.expire2, pp.expire3,  mat1.code, mat1.[name]), 
		(po.[name], pp.prday, pp.expire1, pp.expire2, pp.expire3,  mat1.code, pc.number, mat1.[name]) 
		)

		Select SSite, SiteName, NavSalesOrder, ProductCode, ProductDescription, KillDate, ProductionDate, DNOB, UseByDate, PalletNo, Qty, HRBoxNo
		From tblHROrdersChecker
		Where NavSalesOrder=@Order
		Order By HRBoxNo, ProductCode,KillDate, ProductionDate, DNOB, UseByDate, Qty
	END

IF @SiteID='3' 
	BEGIN
		INSERT INTO tblHROrdersChecker
		(
		SSite, SiteName, NavSalesOrder, ProductCode, ProductDescription, KillDate, ProductionDate, DNOB, UseByDate, PalletNo, Qty, HRBoxNo
		)

		SELECT				'FH', 'Foyle Hilton', po.code  as OrderNo, 
							mat1.code AS Product, mat1.name AS Description,    pl.expire2min AS Killdate, 
							pl.prdaymin  AS PackDate, pl.expire3min AS DNOB, pl.expire1min AS UseBy, '999999' As 'PalletNo'
							, pl.maxamount As 'Qty',
							case
							when po.orderstatus = 1 then 'Closed'
							when po.orderstatus = 2 then 'Cancelled'
							when po.orderstatus = 3 then 'On Hold'
							when po.orderstatus = 4 then 'Open'
							when po.orderstatus = 5 then 'Complete'
							when po.orderstatus = 6 then 'Complete & Closed'
							when po.orderstatus = 7 then 'Dispatched'
							else 'No Status'
							end as [Status]
		FROM   [FH_Innova].dbo.proc_orders AS po WITH (nolock)
		Inner Join [FH_Innova].dbo.proc_orderl (NOLOCK) pl On po.[order]=pl.[order]    
		inner join [FH_Innova].dbo.proc_materials AS mat1 WITH (nolock) on  pl.material = mat1.material  
		WHERE po.code  = @Order

		UNION ALL

		Select 'FH', 'Foyle Hilton', po.[name] As 'OrderNo', mat1.code As 'Product',  mat1.[name] AS 'Description',pp.expire2 As 'KillDate',
		pp.prday As 'PackDate', pp.expire3 As 'DNOB', pp.expire1 As 'UseBy',  
		pc.number As 'PalletNo', Count(pp.sscc) As Qty, 'Scanned' As 'Status'
		From [FH_Innova].dbo.proc_packs (NoLock) pp 
		Left Join [FH_Innova].dbo.proc_orders AS po WITH (nolock) on pp.[order]=po.[order]
		Inner Join [FH_Innova].dbo.proc_collections pc On pp.pallet=pc.id
		inner join [FH_Innova].dbo.proc_materials AS mat1 WITH (nolock) on  pp.material = mat1.material  
		Where pp.[order]=@InnovaOrder
		Group By 
		Grouping Sets 
		(
		(po.[name], pp.prday, pp.expire1, pp.expire2, pp.expire3,  mat1.code, mat1.[name]), 
		(po.[name], pp.prday, pp.expire1, pp.expire2, pp.expire3,  mat1.code, pc.number, mat1.[name]) 
		)

		Select SSite, SiteName, NavSalesOrder, ProductCode, ProductDescription, KillDate, ProductionDate, DNOB, UseByDate, PalletNo, Qty, HRBoxNo
		From tblHROrdersChecker
		Where NavSalesOrder=@Order
		Order By HRBoxNo, ProductCode,KillDate, ProductionDate, DNOB, UseByDate, Qty
	END

IF @SiteID='4' 
	BEGIN
		INSERT INTO tblHROrdersChecker
		(
		SSite, SiteName, NavSalesOrder, ProductCode, ProductDescription, KillDate, ProductionDate, DNOB, UseByDate, PalletNo, Qty, HRBoxNo
		)

		SELECT				'FD', 'Foyle Donegal', po.code  as OrderNo, 
							mat1.code AS Product, mat1.name AS Description,    pl.expire2min AS Killdate, 
							pl.prdaymin  AS PackDate, pl.expire3min AS DNOB, pl.expire1min AS UseBy, '999999' As 'PalletNo'
							, pl.maxamount As 'Qty',
							case
							when po.orderstatus = 1 then 'Closed'
							when po.orderstatus = 2 then 'Cancelled'
							when po.orderstatus = 3 then 'On Hold'
							when po.orderstatus = 4 then 'Open'
							when po.orderstatus = 5 then 'Complete'
							when po.orderstatus = 6 then 'Complete & Closed'
							when po.orderstatus = 7 then 'Dispatched'
							else 'No Status'
							end as [Status]
		FROM   [FD_Innova].dbo.proc_orders AS po WITH (nolock)
		Inner Join [FD_Innova].dbo.proc_orderl (NOLOCK) pl On po.[order]=pl.[order]    
		inner join [FD_Innova].dbo.proc_materials AS mat1 WITH (nolock) on  pl.material = mat1.material  
		WHERE po.code  = @Order

		UNION ALL

		Select 'FD', 'Foyle Donegal', po.[name] As 'OrderNo', mat1.code As 'Product',  mat1.[name] AS 'Description',pp.expire2 As 'KillDate',
		pp.prday As 'PackDate', pp.expire3 As 'DNOB', pp.expire1 As 'UseBy',  
		pc.number As 'PalletNo', Count(pp.sscc) As Qty, 'Scanned' As 'Status'
		From [FD_Innova].dbo.proc_packs (NoLock) pp 
		Left Join [FD_Innova].dbo.proc_orders AS po WITH (nolock) on pp.[order]=po.[order]
		Inner Join [FD_Innova].dbo.proc_collections pc On pp.pallet=pc.id
		inner join [FD_Innova].dbo.proc_materials AS mat1 WITH (nolock) on  pp.material = mat1.material  
		Where pp.[order]=@InnovaOrder
		Group By 
		Grouping Sets 
		(
		(po.[name], pp.prday, pp.expire1, pp.expire2, pp.expire3,  mat1.code, mat1.[name]), 
		(po.[name], pp.prday, pp.expire1, pp.expire2, pp.expire3,  mat1.code, pc.number, mat1.[name]) 
		)

		Select SSite, SiteName, NavSalesOrder, ProductCode, ProductDescription, KillDate, ProductionDate, DNOB, UseByDate, PalletNo, Qty, HRBoxNo
		From tblHROrdersChecker
		Where NavSalesOrder=@Order
		Order By HRBoxNo, ProductCode,KillDate, ProductionDate, DNOB, UseByDate, Qty
	END

If @SiteID='5'

	BEGIN
		INSERT INTO tblHROrdersChecker
		(
		SSite, SiteName, NavSalesOrder, ProductCode, ProductDescription, KillDate, ProductionDate, DNOB, UseByDate, PalletNo, Qty, HRBoxNo
		)

		SELECT				'FGL', 'Foyle Gloucester', po.code  as OrderNo, 
							mat1.code AS Product, mat1.name AS Description,    pl.expire2min AS Killdate, 
							pl.prdaymin  AS PackDate, pl.expire3min AS DNOB, pl.expire1min AS UseBy, '999999' As 'PalletNo'
							, pl.maxamount As 'Qty',
							case
							when po.orderstatus = 1 then 'Closed'
							when po.orderstatus = 2 then 'Cancelled'
							when po.orderstatus = 3 then 'On Hold'
							when po.orderstatus = 4 then 'Open'
							when po.orderstatus = 5 then 'Complete'
							when po.orderstatus = 6 then 'Complete & Closed'
							when po.orderstatus = 7 then 'Dispatched'
							else 'No Status'
							end as [Status]
		FROM   [FG_Innova].dbo.proc_orders AS po WITH (nolock)
		Inner Join [FG_Innova].dbo.proc_orderl (NOLOCK) pl On po.[order]=pl.[order]    
		inner join [FG_Innova].dbo.proc_materials AS mat1 WITH (nolock) on  pl.material = mat1.material  
		WHERE po.code  = @Order

		UNION ALL

		Select 'FGL', 'Foyle Gloucester', po.[name] As 'OrderNo', mat1.code As 'Product',  mat1.[name] AS 'Description',pp.expire2 As 'KillDate',
		pp.prday As 'PackDate', pp.expire3 As 'DNOB', pp.expire1 As 'UseBy',  
		pc.number As 'PalletNo', Count(pp.sscc) As Qty, 'Scanned' As 'Status'
		From [FG_Innova].dbo.proc_packs (NoLock) pp 
		Left Join [FG_Innova].dbo.proc_orders AS po WITH (nolock) on pp.[order]=po.[order]
		Inner Join [FG_Innova].dbo.proc_collections pc On pp.pallet=pc.id
		inner join [FG_Innova].dbo.proc_materials AS mat1 WITH (nolock) on  pp.material = mat1.material  
		Where pp.[order]=@InnovaOrder
		Group By 
		Grouping Sets 
		(
		(po.[name], pp.prday, pp.expire1, pp.expire2, pp.expire3,  mat1.code, mat1.[name]), 
		(po.[name], pp.prday, pp.expire1, pp.expire2, pp.expire3,  mat1.code, pc.number, mat1.[name]) 
		)

		Select SSite, SiteName, NavSalesOrder, ProductCode, ProductDescription, KillDate, ProductionDate, DNOB, UseByDate, PalletNo, Qty, HRBoxNo
		From tblHROrdersChecker
		Where NavSalesOrder=@Order
		Order By HRBoxNo, ProductCode,KillDate, ProductionDate, DNOB, UseByDate, Qty
	END


GO
