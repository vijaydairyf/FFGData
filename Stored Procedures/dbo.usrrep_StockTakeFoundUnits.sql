SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [dbo].[usrrep_StockTakeFoundUnits] 'VacPac 19/12/2018 11:27:56'
--exec [dbo].[usrrep_StockTakeFoundUnits] 'Chamber B 11/09/2018 11:27:43'
CREATE PROCEDURE [dbo].[usrrep_StockTakeFoundUnits] 
	@Site nvarchar(3),
	@stocktake nvarchar(50)

AS
BEGIN

--============================================================================================================================
--FOYLE OMAGH
--============================================================================================================================
if @Site = 'FO'
BEGIN
SELECT			st.stocktake as stocktakeid
			   ,st.[description] as StockTake
			   ,r.[name] as Inventory
			   ,m.code as ProductCode
			   ,m.[name] as Product
			   ,count(p.number) as Qty
			   ,sum(p.[weight]) as Wgt  
			   ,m.[value] as [P/kg]
			   ,sum(p.[weight]*m.[value]) as [Value] 
			   ,mt.[name] as ProductType
			   ,c.number as Pallet
			   ,p.sscc AS PackSSCC
			   ,loc.code as Invlocation
			   ,p.regtime as Regtime
	  
FROM			FO_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FO_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FO_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FO_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FO_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
LEFT JOIN		FO_Innova.dbo.proc_collections c on p.pallet = c.id 
LEFT JOIN		FO_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FO_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id

WHERE		    st.[description] = @stocktake and sp.countstatus = 3

GROUP BY		st.stocktake,st.[description],r.[name],c.number,p.sscc,loc.code,m.code,m.[name],m.[value],mt.[name],p.regtime

						UNION
								
SELECT			st.stocktake as stocktakeid
				,st.[description]
				,r.[name] as inventory
				,m.code
				,m.[name] as [Description]
				,count(p.id)as Qty
				,sum(p.nominal) as wgt
				,p.[value] as pkg
				,sum(p.nominal * p.[value])as Val
				,mt.[name] as materialtype
				,c.number as pallet
				,p.sscc AS PackSSCC
				,i.code as Invlocation
				,p.regtime as Regtime

FROM			[FO_Innova].[dbo].[proc_stocktakec] sc 
LEFT JOIN		FO_Innova.dbo.proc_stocktakes st on sc.stocktake = st.stocktake
LEFT JOIN		FO_Innova.dbo.proc_collections c on sc.[collection] = c.id
LEFT JOIN		FO_Innova.dbo.proc_packs p on c.id = p.pallet
LEFT JOIN		FO_Innova.dbo.proc_prunits r on p.inventory = r.prunit
LEFT JOIN		FO_Innova.dbo.proc_invlocations i on p.invlocation = i.id
LEFT JOIN		FO_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FO_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype

WHERE			st.[description] = @stocktake and sc.countstatus = 3
GROUP BY		st.[description],c.number,p.sscc,m.code,m.[name], p.[value],mt.[name],i.code,r.[name],st.stocktake,r.prunit,p.regtime
END

--============================================================================================================================
--FOYLE CAMPSIE
--============================================================================================================================
IF @Site = 'FC'
BEGIN
SELECT			st.stocktake as stocktakeid
			   ,st.[description] as StockTake
			   ,r.[name] as Inventory
			   ,m.code as ProductCode
			   ,m.[name] as Product
			   ,count(p.number) as Qty
			   ,sum(p.[weight]) as Wgt  
			   ,m.[value] as [P/kg]
			   ,sum(p.[weight]*m.[value]) as [Value] 
			   ,mt.[name] as ProductType
			   ,c.number as Pallet
			   ,p.sscc AS PackSSCC
			   ,loc.code as Invlocation
			   ,p.regtime as Regtime
	  
FROM			FM_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FM_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FM_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FM_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FM_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
LEFT JOIN		FM_Innova.dbo.proc_collections c on p.pallet = c.id 
LEFT JOIN		FM_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FM_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id

WHERE		    st.[description] = @stocktake and sp.countstatus = 3

GROUP BY		st.stocktake,st.[description],r.[name],c.number,p.sscc,loc.code,m.code,m.[name],m.[value],mt.[name],p.regtime

						UNION
								
SELECT			st.stocktake as stocktakeid
				,st.[description]
				,r.[name] as inventory
				,m.code
				,m.[name] as [Description]
				,count(p.id)as Qty
				,sum(p.nominal) as wgt
				,p.[value] as pkg
				,sum(p.nominal * p.[value])as Val
				,mt.[name] as materialtype
				,c.number as pallet
				,p.sscc AS PackSSCC
				,i.code as Invlocation
				,p.regtime as Regtime

FROM			[FM_Innova].[dbo].[proc_stocktakec] sc 
LEFT JOIN		FM_Innova.dbo.proc_stocktakes st on sc.stocktake = st.stocktake
LEFT JOIN		FM_Innova.dbo.proc_collections c on sc.[collection] = c.id
LEFT JOIN		FM_Innova.dbo.proc_packs p on c.id = p.pallet
LEFT JOIN		FM_Innova.dbo.proc_prunits r on p.inventory = r.prunit
LEFT JOIN		FM_Innova.dbo.proc_invlocations i on p.invlocation = i.id
LEFT JOIN		FM_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FM_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype

WHERE			st.[description] = @stocktake and sc.countstatus = 3
GROUP BY		st.[description],c.number,p.sscc,m.code,m.[name], p.[value],mt.[name],i.code,r.[name],st.stocktake,r.prunit,p.regtime

END

--============================================================================================================================
--FOYLE DONEGAL
--============================================================================================================================
IF @Site = 'FD'
BEGIN
SELECT			st.stocktake as stocktakeid
			   ,st.[description] as StockTake
			   ,r.[name] as Inventory
			   ,m.code as ProductCode
			   ,m.[name] as Product
			   ,count(p.number) as Qty
			   ,sum(p.[weight]) as Wgt  
			   ,m.[value] as [P/kg]
			   ,sum(p.[weight]*m.[value]) as [Value] 
			   ,mt.[name] as ProductType
			   ,c.number as Pallet
			   ,p.sscc AS PackSSCC
			   ,loc.code as Invlocation
			   ,p.regtime as Regtime
	  
FROM			FD_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FD_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FD_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FD_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FD_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
LEFT JOIN		FD_Innova.dbo.proc_collections c on p.pallet = c.id 
LEFT JOIN		FD_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FD_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id

WHERE		    st.[description] = @stocktake and sp.countstatus = 3

GROUP BY		st.stocktake,st.[description],r.[name],c.number,p.sscc,loc.code,m.code,m.[name],m.[value],mt.[name],p.regtime

						UNION
								
SELECT			st.stocktake as stocktakeid
				,st.[description]
				,r.[name] as inventory
				,m.code
				,m.[name] as [Description]
				,count(p.id)as Qty
				,sum(p.nominal) as wgt
				,p.[value] as pkg
				,sum(p.nominal * p.[value])as Val
				,mt.[name] as materialtype
				,c.number as pallet
				,p.sscc AS PackSSCC
				,i.code as Invlocation
				,p.regtime as Regtime

FROM			[FD_Innova].[dbo].[proc_stocktakec] sc 
LEFT JOIN		FD_Innova.dbo.proc_stocktakes st on sc.stocktake = st.stocktake
LEFT JOIN		FD_Innova.dbo.proc_collections c on sc.[collection] = c.id
LEFT JOIN		FD_Innova.dbo.proc_packs p on c.id = p.pallet
LEFT JOIN		FD_Innova.dbo.proc_prunits r on p.inventory = r.prunit
LEFT JOIN		FD_Innova.dbo.proc_invlocations i on p.invlocation = i.id
LEFT JOIN		FD_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FD_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype

WHERE			st.[description] = @stocktake and sc.countstatus = 3
GROUP BY		st.[description],c.number,p.sscc,m.code,m.[name], p.[value],mt.[name],i.code,r.[name],st.stocktake,r.prunit,p.regtime

END

--============================================================================================================================
--FOYLE GLOUCESTER
--============================================================================================================================
IF @Site = 'FG'
BEGIN
SELECT			st.stocktake as stocktakeid
			   ,st.[description] as StockTake
			   ,r.[name] as Inventory
			   ,m.code as ProductCode
			   ,m.[name] as Product
			   ,count(p.number) as Qty
			   ,sum(p.[weight]) as Wgt  
			   ,m.[value] as [P/kg]
			   ,sum(p.[weight]*m.[value]) as [Value] 
			   ,mt.[name] as ProductType
			   ,c.number as Pallet
			   ,p.sscc AS PackSSCC
			   ,loc.code as Invlocation
			   ,p.regtime as Regtime
	  
FROM			FG_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FG_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FG_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FG_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FG_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
LEFT JOIN		FG_Innova.dbo.proc_collections c on p.pallet = c.id 
LEFT JOIN		FG_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FG_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id

WHERE		    st.[description] = @stocktake and sp.countstatus = 3

GROUP BY		st.stocktake,st.[description],r.[name],c.number,p.sscc,loc.code,m.code,m.[name],m.[value],mt.[name],p.regtime

						UNION
								
SELECT			st.stocktake as stocktakeid
				,st.[description]
				,r.[name] as inventory
				,m.code
				,m.[name] as [Description]
				,count(p.id)as Qty
				,sum(p.nominal) as wgt
				,p.[value] as pkg
				,sum(p.nominal * p.[value])as Val
				,mt.[name] as materialtype
				,c.number as pallet
				,p.sscc AS PackSSCC
				,i.code as Invlocation
				,p.regtime as Regtime

FROM			[FG_Innova].[dbo].[proc_stocktakec] sc 
LEFT JOIN		FG_Innova.dbo.proc_stocktakes st on sc.stocktake = st.stocktake
LEFT JOIN		FG_Innova.dbo.proc_collections c on sc.[collection] = c.id
LEFT JOIN		FG_Innova.dbo.proc_packs p on c.id = p.pallet
LEFT JOIN		FG_Innova.dbo.proc_prunits r on p.inventory = r.prunit
LEFT JOIN		FG_Innova.dbo.proc_invlocations i on p.invlocation = i.id
LEFT JOIN		FG_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FG_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype

WHERE			st.[description] = @stocktake and sc.countstatus = 3
GROUP BY		st.[description],c.number,p.sscc,m.code,m.[name], p.[value],mt.[name],i.code,r.[name],st.stocktake,r.prunit,p.regtime

END


--============================================================================================================================
--FOYLE HILTON
--============================================================================================================================
IF @Site = 'FH'
BEGIN
SELECT			st.stocktake as stocktakeid
			   ,st.[description] as StockTake
			   ,r.[name] as Inventory
			   ,m.code as ProductCode
			   ,m.[name] as Product
			   ,count(p.number) as Qty
			   ,sum(p.[weight]) as Wgt  
			   ,m.[value] as [P/kg]
			   ,sum(p.[weight]*m.[value]) as [Value] 
			   ,mt.[name] as ProductType
			   ,c.number as Pallet
			   ,p.sscc AS PackSSCC
			   ,loc.code as Invlocation
			   ,p.regtime as Regtime
	  
FROM			FH_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FH_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FH_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FH_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FH_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
LEFT JOIN		FH_Innova.dbo.proc_collections c on p.pallet = c.id 
LEFT JOIN		FH_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FH_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id

WHERE		    st.[description] = @stocktake and sp.countstatus = 3

GROUP BY		st.stocktake,st.[description],r.[name],c.number,p.sscc,loc.code,m.code,m.[name],m.[value],mt.[name],p.regtime

						UNION
								
SELECT			st.stocktake as stocktakeid
				,st.[description]
				,r.[name] as inventory
				,m.code
				,m.[name] as [Description]
				,count(p.id)as Qty
				,sum(p.nominal) as wgt
				,p.[value] as pkg
				,sum(p.nominal * p.[value])as Val
				,mt.[name] as materialtype
				,c.number as pallet
				,p.sscc AS PackSSCC
				,i.code as Invlocation
				,p.regtime as Regtime

FROM			[FH_Innova].[dbo].[proc_stocktakec] sc 
LEFT JOIN		FH_Innova.dbo.proc_stocktakes st on sc.stocktake = st.stocktake
LEFT JOIN		FH_Innova.dbo.proc_collections c on sc.[collection] = c.id
LEFT JOIN		FH_Innova.dbo.proc_packs p on c.id = p.pallet
LEFT JOIN		FH_Innova.dbo.proc_prunits r on p.inventory = r.prunit
LEFT JOIN		FH_Innova.dbo.proc_invlocations i on p.invlocation = i.id
LEFT JOIN		FH_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FH_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype

WHERE			st.[description] = @stocktake and sc.countstatus = 3
GROUP BY		st.[description],c.number,p.sscc,m.code,m.[name], p.[value],mt.[name],i.code,r.[name],st.stocktake,r.prunit,p.regtime

END

--============================================================================================================================
--FOYLE INGREDIENTS
--============================================================================================================================
IF @Site = 'FI'
BEGIN
SELECT			st.stocktake as stocktakeid
			   ,st.[description] as StockTake
			   ,r.[name] as Inventory
			   ,m.code as ProductCode
			   ,m.[name] as Product
			   ,count(p.number) as Qty
			   ,sum(p.[weight]) as Wgt  
			   ,m.[value] as [P/kg]
			   ,sum(p.[weight]*m.[value]) as [Value] 
			   ,mt.[name] as ProductType
			   ,c.number as Pallet
			   ,p.sscc AS PackSSCC
			   ,loc.code as Invlocation
			   ,p.regtime as Regtime
	  
FROM			FI_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FI_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FI_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FI_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FI_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
LEFT JOIN		FI_Innova.dbo.proc_collections c on p.pallet = c.id 
LEFT JOIN		FI_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FI_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id

WHERE		    st.[description] = @stocktake and sp.countstatus = 3

GROUP BY		st.stocktake,st.[description],r.[name],c.number,p.sscc,loc.code,m.code,m.[name],m.[value],mt.[name],p.regtime

						UNION
								
SELECT			st.stocktake as stocktakeid
				,st.[description]
				,r.[name] as inventory
				,m.code
				,m.[name] as [Description]
				,count(p.id)as Qty
				,sum(p.nominal) as wgt
				,p.[value] as pkg
				,sum(p.nominal * p.[value])as Val
				,mt.[name] as materialtype
				,c.number as pallet
				,p.sscc AS PackSSCC
				,i.code as Invlocation
				,p.regtime as Regtime

FROM			[FI_Innova].[dbo].[proc_stocktakec] sc 
LEFT JOIN		FI_Innova.dbo.proc_stocktakes st on sc.stocktake = st.stocktake
LEFT JOIN		FI_Innova.dbo.proc_collections c on sc.[collection] = c.id
LEFT JOIN		FI_Innova.dbo.proc_packs p on c.id = p.pallet
LEFT JOIN		FI_Innova.dbo.proc_prunits r on p.inventory = r.prunit
LEFT JOIN		FI_Innova.dbo.proc_invlocations i on p.invlocation = i.id
LEFT JOIN		FI_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FI_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype

WHERE			st.[description] = @stocktake and sc.countstatus = 3
GROUP BY		st.[description],c.number,p.sscc,m.code,m.[name], p.[value],mt.[name],i.code,r.[name],st.stocktake,r.prunit,p.regtime

END

END



GO
