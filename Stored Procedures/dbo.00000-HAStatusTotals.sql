SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [00000-HAStatusTotals] '128107','1','FD'

CREATE PROCEDURE [dbo].[00000-HAStatusTotals]

@OrderNo NVarChar(Max), 
@SubOrderNo NVarChar(Max), 
@FFGSite NVarChar(Max)

AS

		Select h.[No_] Into #ffgso
		From [ffgsql01].[FFG-Production].dbo.[FFG LIVE$Sales Header] h
		Where h.[External Document No_]=@OrderNo And h.SubOrder = @SubOrderNo And h.[Location Code] = @FFGSite
		
		Select 'FD' As SSite, o.[order], o.[name] As FFGSO, m.[code], Count(k.sscc) As PackQty
		Into #t
		From  [FD_Innova].dbo.proc_orders o With (NOLOCK)
		Inner Join [FD_Innova].dbo.proc_packs k With (NOLOCK) On o.[order]=k.[order]
		Inner Join [FD_Innova].dbo.proc_materials m On k.material=m.material
		Where o.[name]  COLLATE DATABASE_DEFAULT  In( Select No_ From #ffgso )
		Group By o.[order], o.[name], m.[code]

		Select 'FD' As SSite, o.[order], o.[name] As FFGSO, m.[code], Sum(l.maxamount) As PackQty
		Into #ol
		From  [FD_Innova].dbo.proc_orders o With (NOLOCK)
		Inner Join [FD_Innova].dbo.proc_orderl l With (NOLOCK) On o.[order]=l.[order]
		Inner Join [FD_Innova].dbo.proc_materials m On l.material=m.material
		Where o.[name]  COLLATE DATABASE_DEFAULT  In( Select No_ From #ffgso)
		Group By o.[order], o.[name], m.[code]
		
		Select h.OrderNo, Right(h.OrderSubNo,1) As SubOrder, h.SSite, h.ProductCode, h.ProductDescription, h.NavSalesOrder, Cast(Sum(h.qty) As Decimal(18,0)) As AllocatedQty, 
		IsNull(ol.PackQty,0) As InnovaOrderedQty, IsNull(t.PackQty,0) As InnovaScannedQty,
		Case When Cast(Sum(h.qty) As Decimal(18,0)) = IsNull(t.PackQty,0) Then 'Complete' Else '-' End As OrderLineStatus
		From [FFGData].dbo.tblHROrders h 
		Left Join #t t On h.NavSalesOrder=t.[FFGSO] And h.ProductCode=t.code
		Left Join #ol ol On h.NavSalesOrder=ol.[FFGSO] And h.ProductCode=ol.code 
		where h.OrderNo=@OrderNo And Right(h.OrderSubNo,1)=@SubOrderNo And h.SSite = @FFGSite
		Group By h.OrderNo, h.SSite, h.ProductCode, h.ProductDescription, h.NavSalesOrder, t.PackQty, ol.PackQty, Right(h.OrderSubNo,1)
		Order By h.ProductCode

		Drop Table #t, #ol, #ffgso
GO
