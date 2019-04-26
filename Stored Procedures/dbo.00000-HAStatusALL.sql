SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Kevin Hargan
-- Create date: 1st April 2019
-- Description:	Porgress of orders from all sites by PO number
-- =============================================

--exec [00000-HAStatusALL] 135103 , 1

CREATE PROCEDURE [dbo].[00000-HAStatusALL] 

@OrderNo NVarChar(Max), 
@SubOrderNo NVarChar(Max)

AS

		Select h.[No_] 
		Into #ffgso
		From [ffgsql01].[FFG-Production].dbo.[FFG LIVE$Sales Header] h
		Where h.[External Document No_]=@OrderNo
		And h.SubOrder In (@SubOrderNo)

		

		
			BEGIN

			DECLARE @t TABLE(SSite nvarchar(20), [ORDER] nvarchar(30), [FFGSO] nvarchar(20), [code] nvarchar(12), PackQTY INT, [Weight] DECIMAL (18,2)) 
			DECLARE @ol TABLE([ORDER] NVARCHAR(30), FFGSO NVARCHAR(20), code NVARCHAR(12), PackQTY int ) 
				
				INSERT INTO @t
				Select 'FC' AS SSite, o.[order], o.[name] As FFGSO, m.[code],
				Count(k.sscc) As PackQty, SUM(k.nominal)
				From  [FM_Innova].dbo.proc_orders o With (NOLOCK)
				Inner Join [FM_Innova].dbo.proc_packs k With (NOLOCK) On o.[order]=k.[order]
				Inner Join [FM_Innova].dbo.proc_materials m On k.material=m.material
				Where o.[name]  COLLATE DATABASE_DEFAULT  In( Select No_ From #ffgso )
				Group By o.[order], o.[name], m.[code]
				
				INSERT INTO @t
				SELECT 'FO' As SSite, o.[order], o.[name] As FFGSO, m.[code],
				Count(k.sscc) As PackQty, SUM(k.nominal)
				From  [FO_Innova].dbo.proc_orders o With (NOLOCK)
				Inner Join [FO_Innova].dbo.proc_packs k With (NOLOCK) On o.[order]=k.[order]
				Inner Join [FO_Innova].dbo.proc_materials m On k.material=m.material
				Where o.[name]  COLLATE DATABASE_DEFAULT  In( Select No_ From #ffgso )
				Group By o.[order], o.[name], m.[code]


				INSERT INTO @ol
				Select o.[order], o.[name] As FFGSO, m.[code], Sum(l.maxamount) As PackQty
				From  [FM_Innova].dbo.proc_orders o With (NOLOCK)
				Inner Join [FM_Innova].dbo.proc_orderl l With (NOLOCK) On o.[order]=l.[order]
				Inner Join [FM_Innova].dbo.proc_materials m On l.material=m.material
				Where o.[name]  COLLATE DATABASE_DEFAULT  In( Select No_ From #ffgso)
				Group By o.[order], o.[name], m.[code]
				
				INSERT INTO @ol
				SELECT o.[order], o.[name] As FFGSO, m.[code], Sum(l.maxamount) As PackQty
				From  [FO_Innova].dbo.proc_orders o With (NOLOCK)
				Inner Join [FO_Innova].dbo.proc_orderl l With (NOLOCK) On o.[order]=l.[order]
				Inner Join [FO_Innova].dbo.proc_materials m On l.material=m.material
				Where o.[name]  COLLATE DATABASE_DEFAULT  In( Select No_ From #ffgso)
				Group By o.[order], o.[name], m.[code]




				Select h.OrderNo, @SubOrderNo As 'SubOrder',h.ProductCode, h.ProductDescription,  Cast(Sum(h.qty) As Decimal(18,0)) As AllocatedQty, 
				IsNull(SUM(ol.PackQty),0) As InnovaOrderedQty, 
				IsNull(SUM(t.PackQty),0) As InnovaScannedQty, Cast(Sum(h.qty) As Decimal(18,0))-IsNull(SUM(t.PackQty),0) As A2SDifference, ISNULL(SUM(t.[Weight]),0) AS ScannedWgt, CAST(SUM(h.Qty * ium.[Qty_ per Unit of Measure]) AS DECIMAL (18,2)) AS AllocatedWgt
				From [FFGData].dbo.tblHROrders h 
				Left Join @t t On h.NavSalesOrder collate database_default =t.[FFGSO] And h.ProductCode collate database_default =t.code
				Left Join @ol ol On h.NavSalesOrder collate database_default =ol.[FFGSO] And h.ProductCode collate database_default =ol.code 
				LEFT JOIN FFGSQL02.[FFG-Production].[dbo].[FFG LIVE$Item Unit of Measure] AS ium WITH (NOLOCK) ON ium.[Item No_] COLLATE DATABASE_DEFAULT = h.ProductCode AND ium.code = 'Case'
				where	h.OrderNo collate database_default =@OrderNo 
						AND Right(h.OrderSubNo,1) collate database_default =@SubOrderNo AND H.SSite IN ('FO','FC')
				
				GROUP By h.OrderNo, h.ProductCode, h.ProductDescription
				
				ORDER By h.ProductCode

			
			END

			Drop Table #ffgso
GO
