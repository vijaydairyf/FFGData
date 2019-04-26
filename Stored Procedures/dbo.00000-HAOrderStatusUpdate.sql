SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [00000-HAOrderStatusUpdate] '129743','1','FH'

CREATE PROCEDURE [dbo].[00000-HAOrderStatusUpdate]

@OrderNo NVarChar(Max), 
@SubOrder NVarChar(Max), 
@Site NVarChar(Max)

AS

Declare @InnovaOrder NVarChar(50)
Declare @Goods NVarChar(25)


	Delete From tblHAChecker Where Not Cast(OrderNo As NVarChar(10)) + Cast(SubOrder As NVarChar(10))  
			In (Select Cast(GroupOrderNo As NVarChar(10)) + Cast(SubOrder As NVarChar(10))  From tblHROrdersHeader Where Tracker='True') 

	Delete From tblHaChecker Where SiteName=@Site And OrderNo=@OrderNo And SubOrder=@SubOrder

	Delete From tblHrOrdersChecker Where NavSalesOrder Collate database_default  IN 
	(Select h.[No_] From [ffgsql01].[FFG-Production].dbo.[FFG LIVE$Sales Header] h Where h.[External Document No_]=@OrderNo And h.[SubOrder]=@SubOrder)

--->
	Select h.[No_] AS 'FFGSO', h.[External Document No_] As 'OrderNo',h.[SubOrder] As 'SubOrderNo', IIF(h.[Goods]='6','Fresh','Frozen') As Storage, h.[Location Code]  As FFGSite
	Into #nav From [ffgsql01].[FFG-Production].dbo.[FFG LIVE$Sales Header] h Where h.[External Document No_]=@OrderNo And h.[SubOrder]= @SubOrder And h.[Goods] In('6','7')

	Select a.OrderNo, a.SubOrderNo, a.ProductCode, a.DNOB, a.UseBy,
	Case When a.siteid='1' Then 'FC' When a.siteid='2' Then 'FO' When a.siteid='3' Then 'FH' When a.siteid='4' Then 'FD' When a.siteid='5' Then 'FGL'
	End As FFGSite, Count(b.SSCC) As Qty, IIF (a.ProductCode Like '9%','Frozen','Fresh') As 'Storage', 'FFGSO1234567' As 'FFGSO'
	Into #ecs 	From [ffgbi-serv].[ffg_dw].[dbo].[HR_Order_Allocation] a  Left Join FFGData.dbo.HaECS b On a.BoxNO=b.sscc
	Where a.orderno=@OrderNo And a.SubOrderNo=@SubOrder And Not b.SSCC Is Null
	Group By a.DNOB, a.UseBy, a.OrderNo, a.SubOrderNo, a.ProductCode, a.siteID
	Order By a.siteid, a.ProductCode

	Update a Set a.FFGSO=b.FFGSO From #ecs a
	Left Join #nav b On a.OrderNo =b.OrderNo And a.SubOrderNo  =b.SubOrderNo And a.FFGSite Collate Database_Default =b.FFGSite And a.Storage Collate Database_Default =b.Storage

	Update #ecs Set FFGSO='' Where FFGSO='FFGSO123456'
--->


	IF @Site='FD'
		BEGIN
			INSERT INTO tblHROrdersChecker
			(
			SSite, SiteName, NavSalesOrder, ProductCode, ProductDescription, KillDate, ProductionDate, DNOB, UseByDate, PalletNo, Qty, HRBoxNo, Wgt
			)

			SELECT				'FD', 'FD', po.code  as OrderNo, 
								mat1.code AS Product, mat1.name AS Description,    pl.expire2min AS Killdate, 
								pl.prdaymin  AS PackDate, pl.expire3min AS DNOB, pl.expire1min AS UseBy, '999999' As 'PalletNo'
								, IsNull(pl.maxamount,0) As 'Qty',
								'Allocated' As 'Status', pl.curamount As 'Scanned'
			FROM   [FD_Innova].dbo.proc_orders AS po WITH (nolock)
			Inner Join [FD_Innova].dbo.proc_orderl (NOLOCK) pl On po.[order]=pl.[order]    
			inner join [FD_Innova].dbo.proc_materials AS mat1 WITH (nolock) on  pl.material = mat1.material  
			WHERE po.[name] Collate database_default In (Select h.[No_] From [ffgsql01].[FFG-Production].dbo.[FFG LIVE$Sales Header] h Where h.[External Document No_]=@OrderNo And h.[SubOrder]=@SubOrder)
		END

	IF @Site='FO'
		BEGIN
			INSERT INTO tblHROrdersChecker
			(
			SSite, SiteName, NavSalesOrder, ProductCode, ProductDescription, KillDate, ProductionDate, DNOB, UseByDate, PalletNo, Qty, HRBoxNo, Wgt
			)

			SELECT				'FO', 'FO', po.code  as OrderNo, 
								mat1.code AS Product, mat1.name AS Description,    pl.expire2min AS Killdate, 
								pl.prdaymin  AS PackDate, pl.expire3min AS DNOB, pl.expire1min AS UseBy, '999999' As 'PalletNo'
								, IsNull(pl.maxamount,0) As 'Qty',
								'Allocated' As 'Status', pl.curamount As 'Scanned'
			FROM   [FO_Innova].dbo.proc_orders AS po WITH (nolock)
			Inner Join [FO_Innova].dbo.proc_orderl (NOLOCK) pl On po.[order]=pl.[order]    
			inner join [FO_Innova].dbo.proc_materials AS mat1 WITH (nolock) on  pl.material = mat1.material  
			WHERE po.[name] Collate database_default In (Select h.[No_] From [ffgsql01].[FFG-Production].dbo.[FFG LIVE$Sales Header] h Where h.[External Document No_]=@OrderNo And h.[SubOrder]=@SubOrder)
		END

	IF @Site='FH'
		BEGIN
			INSERT INTO tblHROrdersChecker
			(
			SSite, SiteName, NavSalesOrder, ProductCode, ProductDescription, KillDate, ProductionDate, DNOB, UseByDate, PalletNo, Qty, HRBoxNo, Wgt
			)

			SELECT				'FH', 'FH', po.code  as OrderNo, 
								mat1.code AS Product, mat1.name AS Description,    pl.expire2min AS Killdate, 
								pl.prdaymin  AS PackDate, pl.expire3min AS DNOB, pl.expire1min AS UseBy, '999999' As 'PalletNo'
								, IsNull(pl.maxamount,0) As 'Qty',
								'Allocated' As 'Status', pl.curamount As 'Scanned'
			FROM   [FH_Innova].dbo.proc_orders AS po WITH (nolock)
			Inner Join [FH_Innova].dbo.proc_orderl (NOLOCK) pl On po.[order]=pl.[order]    
			inner join [FH_Innova].dbo.proc_materials AS mat1 WITH (nolock) on  pl.material = mat1.material  
			WHERE po.[name] Collate database_default In (Select h.[No_] From [ffgsql01].[FFG-Production].dbo.[FFG LIVE$Sales Header] h Where h.[External Document No_]=@OrderNo And h.[SubOrder]=@SubOrder)
		END

	IF @Site='FC'
		BEGIN
			INSERT INTO tblHROrdersChecker
			(
			SSite, SiteName, NavSalesOrder, ProductCode, ProductDescription, KillDate, ProductionDate, DNOB, UseByDate, PalletNo, Qty, HRBoxNo, Wgt
			)

			SELECT				'FC', 'FC', po.code  as OrderNo, 
								mat1.code AS Product, mat1.name AS Description,    pl.expire2min AS Killdate, 
								pl.prdaymin  AS PackDate, pl.expire3min AS DNOB, pl.expire1min AS UseBy, '999999' As 'PalletNo'
								, IsNull(pl.maxamount,0) As 'Qty',
								'Allocated' As 'Status', pl.curamount As 'Scanned'
			FROM   [FM_Innova].dbo.proc_orders AS po WITH (nolock)
			Inner Join [FM_Innova].dbo.proc_orderl (NOLOCK) pl On po.[order]=pl.[order]    
			inner join [FM_Innova].dbo.proc_materials AS mat1 WITH (nolock) on  pl.material = mat1.material  
			WHERE po.[name] Collate database_default In (Select h.[No_] From [ffgsql01].[FFG-Production].dbo.[FFG LIVE$Sales Header] h Where h.[External Document No_]=@OrderNo And h.[SubOrder]=@SubOrder)
		END


Select SSite, SiteName, NavSalesOrder, ProductCode, ProductDescription, Max(KillDate) As KillDate, Max(ProductionDate) As ProductionDate, DNOB, UseByDate, PalletNo, 
Sum(Qty) Qty, HRBoxNo, '0-Level' As 'LineLevel', IsNull(Sum(Wgt),0) As 'QtyScanned', '-----' As 'Warning', 0 As 'HA', 0 As 'QtyDiff'
Into #t From tblHROrdersChecker
Where NavSalesOrder Collate database_default In (Select h.[No_] From [ffgsql01].[FFG-Production].dbo.[FFG LIVE$Sales Header] h Where h.[External Document No_]=@OrderNo And h.[SubOrder]=@SubOrder)
Group By SSite, SiteName, NavSalesOrder, ProductCode, ProductDescription, DNOB, UseByDate, PalletNo, HRBoxNo
Order By NavSalesOrder,ProductCode DESC, ProductDescription Desc, ProductionDate, DNOB, UseByDate,PalletNo Desc 

Update #t Set LineLevel='3-Level' Where ProductCode Is Null
Update #t Set LineLevel='2-Level' Where UseByDate Is Null And Not ProductCode Is Null
Update #t Set LineLevel='1-Level' Where PalletNo Is Null And Not UseByDate Is Null 

Update #t Set LineLevel=IIF(NavSalesOrder Collate Database_Default In (Select FFGSO From #nav),'ECS','FFG')

Declare @SSiteID NVarChar(50)
Set @SSiteID=(Case When @Site='FC' Then '1' When @Site='FO' Then '2' When @Site='FH' Then '3' When @Site='FD' Then '4' When @Site='FGL' Then '5' When @Site='FMM' Then '6' End)

Update t 
set HA = IsNull(
(
	Select Count(a.ProductCode) 
	From [ffgbi-serv].[ffg_dw].[dbo].[HR_Order_Allocation] a 
	Where a.ProductCode=t.ProductCode And a.UseBy=t.UseByDate And a.DNOB=t.DNOB And a.SiteID=@SSiteID And a.orderno=@OrderNo And a.[SubOrderNo]=@SubOrder
),0)
From #t t Where t.PalletNo='999999'

Update a Set a.HA=IsNull(b.Qty,0) From #t a Left Join #ecs b On a.ProductCode=b.ProductCode And a.DNOB=b.DNOB And a.UseByDate=b.UseBy And a.[SiteName]=b.FFGSite Where a.LineLevel='ECS'

Update a Set a.HA=a.HA-IsNull(b.Qty,0) From #t a Left Join #ecs b On a.ProductCode=b.ProductCode And a.DNOB=b.DNOB And a.UseByDate=b.UseBy And a.[SiteName]=b.FFGSite Where Not a.LineLevel='ECS'

Update t Set Warning=(IIF(t.qty-t.QtyScanned=0,'Green','Red')) From #t t Where t.PalletNo='999999'

Update t Set Warning='BLACK' From #t t Where t.PalletNo='999999' And t.HA<> t.Qty

Update t Set Warning='Amber' From #t t Where t.PalletNo='999999' And t.HA=0

Update t Set QtyDiff=IsNull(t.HA,0)-IsNull(t.QtyScanned,0)  From #t t Where t.PalletNo='999999'

Insert Into tblHAChecker
(OrderNo, SubOrder, SiteName, NavSalesOrder, ProductCode, ProductDescription, ProductionDate, KillDate, DNOB, UseByDate, Status, LOCN, Qty, QtyScanned, HA, QtyDiff, Warning)

Select @OrderNo As OrderNo, @SubOrder As SubOrder, a.SiteName, a.NavSalesOrder, a.ProductCode, a.ProductDescription, a.ProductionDate,  a.KillDate, a.DNOB, a.UseByDate, a.HRBoxNo AS 'Status',
a.LineLevel As 'LOCN', a.Qty, a.QtyScanned, a.HA, a.QtyDiff,a.Warning--, IsNull(b.Qty,0) As ECSQty 
From #t a
Left Join #ecs b On a.ProductCode=b.ProductCode And a.DNOB=b.DNOB And a.UseByDate=b.UseBy And a.[SiteName]=b.FFGSite
Order by  a.NavSalesOrder, a.ProductCode, a.KillDate Desc, a.ProductionDate Desc, a.DNOB Desc, a.UseByDate Desc,  a.LineLevel

--Select * From tblHAChecker Where OrderNo=@OrderNo And SubOrder=@SubOrder And SiteName=@Site

Drop Table #t, #ecs, #nav
GO
