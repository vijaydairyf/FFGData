SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Benjamin Aranyi
-- Create date: 28th June 2018
-- Description:	Combined [00000-HAStatus] Site SPs
-- =============================================

--exec [0-SwimDetailsTest]

CREATE PROCEDURE [dbo].[0-SwimDetailsTest]
as
Select h.[No_] 
Into #ffgso
From [ffgsql01].[FFG-Production].dbo.[FFG LIVE$Sales Header] h

		Select  o.[order], o.[name] As FFGSO, m.[code],
		Count(k.sscc) As PackQty
		Into #t
		From  [FD_Innova].dbo.proc_orders o With (NOLOCK)
		Inner Join [FD_Innova].dbo.proc_packs k With (NOLOCK) On o.[order]=k.[order]
		Inner Join [FD_Innova].dbo.proc_materials m On k.material=m.material
		Where o.[name]  COLLATE DATABASE_DEFAULT  In( Select No_ From #ffgso )
		Group By o.[order], o.[name], m.[code]

		insert into #t
		Select  o.[order], o.[name] As FFGSO, m.[code],
		Count(k.sscc) As PackQty
		From  [FH_Innova].dbo.proc_orders o With (NOLOCK)
		Inner Join [FH_Innova].dbo.proc_packs k With (NOLOCK) On o.[order]=k.[order]
		Inner Join [FH_Innova].dbo.proc_materials m On k.material=m.material
		Where o.[name]  COLLATE DATABASE_DEFAULT  In( Select No_ From #ffgso )
		Group By o.[order], o.[name], m.[code]

		insert into #t
		Select  o.[order], o.[name] As FFGSO, m.[code],
		Count(k.sscc) As PackQty
		From  [FO_Innova].dbo.proc_orders o With (NOLOCK)
		Inner Join [FO_Innova].dbo.proc_packs k With (NOLOCK) On o.[order]=k.[order]
		Inner Join [FO_Innova].dbo.proc_materials m On k.material=m.material
		Where o.[name]  COLLATE DATABASE_DEFAULT  In( Select No_ From #ffgso )
		Group By o.[order], o.[name], m.[code]

		insert into #t
		Select  o.[order], o.[name] As FFGSO, m.[code],
		Count(k.sscc) As PackQty
		From  [FM_Innova].dbo.proc_orders o With (NOLOCK)
		Inner Join [FM_Innova].dbo.proc_packs k With (NOLOCK) On o.[order]=k.[order]
		Inner Join [FM_Innova].dbo.proc_materials m On k.material=m.material
		Where o.[name]  COLLATE DATABASE_DEFAULT  In( Select No_ From #ffgso )
		Group By o.[order], o.[name], m.[code]

		insert into #t
		Select  o.[order], o.[name] As FFGSO, m.[code],
		Count(k.sscc) As PackQty
		From  [FG_Innova].dbo.proc_orders o With (NOLOCK)
		Inner Join [FG_Innova].dbo.proc_packs k With (NOLOCK) On o.[order]=k.[order]
		Inner Join [FG_Innova].dbo.proc_materials m On k.material=m.material
		Where o.[name]  COLLATE DATABASE_DEFAULT  In( Select No_ From #ffgso )
		Group By o.[order], o.[name], m.[code]


		Select  o.[order], o.[name] As FFGSO, m.[code], Sum(l.maxamount) As PackQty
		Into #ol
		From  [FD_Innova].dbo.proc_orders o With (NOLOCK)
		Inner Join [FD_Innova].dbo.proc_orderl l With (NOLOCK) On o.[order]=l.[order]
		Inner Join [FD_Innova].dbo.proc_materials m On l.material=m.material
		Where o.[name]  COLLATE DATABASE_DEFAULT  In( Select No_ From #ffgso)
		Group By o.[order], o.[name], m.[code]

		insert into #ol
		Select  o.[order], o.[name] As FFGSO, m.[code], Sum(l.maxamount) As PackQty
		From  [FH_Innova].dbo.proc_orders o With (NOLOCK)
		Inner Join [FH_Innova].dbo.proc_orderl l With (NOLOCK) On o.[order]=l.[order]
		Inner Join [FH_Innova].dbo.proc_materials m On l.material=m.material
		Where o.[name]  COLLATE DATABASE_DEFAULT  In( Select No_ From #ffgso)
		Group By o.[order], o.[name], m.[code]

		insert into #ol
		Select  o.[order], o.[name] As FFGSO, m.[code], Sum(l.maxamount) As PackQty
		From  [FO_Innova].dbo.proc_orders o With (NOLOCK)
		Inner Join [FO_Innova].dbo.proc_orderl l With (NOLOCK) On o.[order]=l.[order]
		Inner Join [FO_Innova].dbo.proc_materials m On l.material=m.material
		Where o.[name]  COLLATE DATABASE_DEFAULT  In( Select No_ From #ffgso)
		Group By o.[order], o.[name], m.[code]

		insert into #ol
		Select  o.[order], o.[name] As FFGSO, m.[code], Sum(l.maxamount) As PackQty
		From  [FM_Innova].dbo.proc_orders o With (NOLOCK)
		Inner Join [FM_Innova].dbo.proc_orderl l With (NOLOCK) On o.[order]=l.[order]
		Inner Join [FM_Innova].dbo.proc_materials m On l.material=m.material
		Where o.[name]  COLLATE DATABASE_DEFAULT  In( Select No_ From #ffgso)
		Group By o.[order], o.[name], m.[code]

		insert into #ol
		Select  o.[order], o.[name] As FFGSO, m.[code], Sum(l.maxamount) As PackQty
		From  [FG_Innova].dbo.proc_orders o With (NOLOCK)
		Inner Join [FG_Innova].dbo.proc_orderl l With (NOLOCK) On o.[order]=l.[order]
		Inner Join [FG_Innova].dbo.proc_materials m On l.material=m.material
		Where o.[name]  COLLATE DATABASE_DEFAULT  In( Select No_ From #ffgso)
		Group By o.[order], o.[name], m.[code]

		Select h.OrderNo, RIGHT(OrderSubNo,1) AS SubOrderNo , h.SSite AS FFGSite, h.NavSalesOrder,h.ProductCode, h.ProductDescription,  Cast(Sum(h.qty) As Decimal(18,0)) As AllocatedQty, 
		IsNull(ol.PackQty,0) As Ordered, 
		IsNull(t.PackQty,0) As Scanned, Cast(Sum(h.qty) As Decimal(18,0))-IsNull(t.PackQty,0) As A2SDifference
		From [FFGData].dbo.tblHROrders h 
		Left Join #t t On h.NavSalesOrder=t.[FFGSO] And h.ProductCode=t.code
		Left Join #ol ol On h.NavSalesOrder=ol.[FFGSO] And h.ProductCode=ol.code 
		Group By h.OrderNo, OrderSubNo, h.SSite, h.ProductCode, h.ProductDescription, h.NavSalesOrder, t.PackQty, ol.PackQty
		Order By h.ProductCode
	Drop Table #t, #ol, #ffgso
GO
