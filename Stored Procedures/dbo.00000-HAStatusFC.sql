SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [00000-HAStatusFC] '128463','1','FC'

CREATE PROCEDURE [dbo].[00000-HAStatusFC]

@OrderNo NVarChar(Max), 
@SubOrderNo NVarChar(Max), 
@FFGSite NVarChar(Max)

AS

		Select h.[No_] 
		Into #ffgso
		From [ffgsql01].[FFG-Production].dbo.[FFG LIVE$Sales Header] h
		Where h.[External Document No_]=@OrderNo
		And h.SubOrder In (@SubOrderNo) And h.[Location Code]=@FFGSite

		If @FFGSite='FC'
			BEGIN
				Select 'FC' As SSite, o.[order], o.[name] As FFGSO, m.[code],
				Count(k.sscc) As PackQty
				Into #t
				From  [FM_Innova].dbo.proc_orders o With (NOLOCK)
				Inner Join [FM_Innova].dbo.proc_packs k With (NOLOCK) On o.[order]=k.[order]
				Inner Join [FM_Innova].dbo.proc_materials m On k.material=m.material
				Where o.[name]  COLLATE DATABASE_DEFAULT  In( Select No_ From #ffgso )
				Group By o.[order], o.[name], m.[code]

				Select @FFGSite As SSite, o.[order], o.[name] As FFGSO, m.[code], Sum(l.maxamount) As PackQty
				Into #ol
				From  [FM_Innova].dbo.proc_orders o With (NOLOCK)
				Inner Join [FM_Innova].dbo.proc_orderl l With (NOLOCK) On o.[order]=l.[order]
				Inner Join [FM_Innova].dbo.proc_materials m On l.material=m.material
				Where o.[name]  COLLATE DATABASE_DEFAULT  In( Select No_ From #ffgso)
				Group By o.[order], o.[name], m.[code]

				Select h.OrderNo, @SubOrderNo As 'SubOrder', h.SSite, h.NavSalesOrder,h.ProductCode, h.ProductDescription,  Cast(Sum(h.qty) As Decimal(18,0)) As AllocatedQty, 
				IsNull(ol.PackQty,0) As InnovaOrderedQty, 
				IsNull(t.PackQty,0) As InnovaScannedQty, Cast(Sum(h.qty) As Decimal(18,0))-IsNull(t.PackQty,0) As A2SDifference
				From [FFGData].dbo.tblHROrders h 
				Left Join #t t On h.NavSalesOrder collate database_default =t.[FFGSO] And h.ProductCode collate database_default =t.code
				Left Join #ol ol On h.NavSalesOrder collate database_default =ol.[FFGSO] And h.ProductCode collate database_default =ol.code 
				where h.OrderNo collate database_default =@OrderNo And Right(h.OrderSubNo,1) collate database_default =@SubOrderNo And h.SSite collate database_default =@FFGSite
				Group By h.OrderNo, h.SSite, h.ProductCode, h.ProductDescription, h.NavSalesOrder, t.PackQty, ol.PackQty
				Order By h.ProductCode


			END

			Drop Table #t, #ol, #ffgso
GO
