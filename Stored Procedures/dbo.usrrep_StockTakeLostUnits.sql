SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [dbo].[usrrep_StockTakeLostUnits] 'VacPac 11/09/2018 16:05:54'
--exec [dbo].[usrrep_StockTakeLostUnits] 'FD','B/Hall Stock 13/03/2019 09:10:42'
CREATE PROCEDURE [dbo].[usrrep_StockTakeLostUnits] 
	@Site nvarchar(3),
	@stocktake nvarchar(50)

AS
BEGIN

--==================================================================================================================================
-- FOYLE OMAGH
--==================================================================================================================================
if @Site = 'FO'
begin
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
INNER JOIN		FO_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
INNER JOIN		FO_Innova.dbo.proc_packs p on sp.pack = p.id 
INNER JOIN		FO_Innova.dbo.proc_materials m on p.material = m.material
INNER JOIN		FO_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
LEFT JOIN		FO_Innova.dbo.proc_collections c on p.pallet = c.id 
INNER JOIN		FO_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FO_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id

WHERE		    st.[description] = @stocktake and sp.countstatus = 0

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
INNER JOIN		FO_Innova.dbo.proc_stocktakes st on sc.stocktake = st.stocktake
INNER JOIN		FO_Innova.dbo.proc_collections c on sc.[collection] = c.id
INNER JOIN		FO_Innova.dbo.proc_packs p on c.id = p.pallet
INNER JOIN		FO_Innova.dbo.proc_prunits r on p.inventory = r.prunit
LEFT JOIN		FO_Innova.dbo.proc_invlocations i on p.invlocation = i.id
INNER JOIN		FO_Innova.dbo.proc_materials m on p.material = m.material
INNER JOIN		FO_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype


WHERE			st.[description] = @stocktake and sc.countstatus = 0

GROUP BY		st.[description],c.number,p.sscc,m.code,m.[name], p.[value],mt.[name],i.code,r.[name],st.stocktake,r.prunit,p.regtime

END
--==================================================================================================================================
-- FOYLE CAMPSIE
--==================================================================================================================================
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
INNER JOIN		FM_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
INNER JOIN		FM_Innova.dbo.proc_packs p on sp.pack = p.id 
INNER JOIN		FM_Innova.dbo.proc_materials m on p.material = m.material
INNER JOIN		FM_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
LEFT JOIN		FM_Innova.dbo.proc_collections c on p.pallet = c.id 
INNER JOIN		FM_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FM_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id

WHERE		    st.[description] = @stocktake and sp.countstatus = 0

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
INNER JOIN		FM_Innova.dbo.proc_stocktakes st on sc.stocktake = st.stocktake
INNER JOIN		FM_Innova.dbo.proc_collections c on sc.[collection] = c.id
INNER JOIN		FM_Innova.dbo.proc_packs p on c.id = p.pallet
INNER JOIN		FM_Innova.dbo.proc_prunits r on p.inventory = r.prunit
LEFT JOIN		FM_Innova.dbo.proc_invlocations i on p.invlocation = i.id
INNER JOIN		FM_Innova.dbo.proc_materials m on p.material = m.material
INNER JOIN		FM_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype


WHERE			st.[description] = @stocktake and sc.countstatus = 0

GROUP BY		st.[description],c.number,p.sscc,m.code,m.[name], p.[value],mt.[name],i.code,r.[name],st.stocktake,r.prunit,p.regtime

END

--==================================================================================================================================
-- FOYLE DONEGAL
--==================================================================================================================================
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
			   ,CASE WHEN c.sscc IS NULL THEN 0 ELSE c.number end as Pallet
			   ,p.sscc AS PackSSCC
			   ,loc.code as Invlocation
			   ,p.regtime as Regtime
	  

FROM			FD_Innova.dbo.proc_stocktakes st 
INNER JOIN		FD_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
INNER JOIN		FD_Innova.dbo.proc_packs p on sp.pack = p.id 
INNER JOIN		FD_Innova.dbo.proc_materials m on p.material = m.material
INNER JOIN		FD_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
LEFT JOIN		FD_Innova.dbo.proc_collections c on p.pallet = c.id 
INNER JOIN		FD_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FD_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id

WHERE		    st.[description] = @stocktake and sp.countstatus = 0

GROUP BY		st.stocktake,st.[description],r.[name],c.number,c.sscc,p.sscc,loc.code,m.code,m.[name],m.[value],mt.[name],p.regtime 


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
INNER JOIN		FD_Innova.dbo.proc_stocktakes st on sc.stocktake = st.stocktake
INNER JOIN		FD_Innova.dbo.proc_collections c on sc.[collection] = c.id
INNER JOIN		FD_Innova.dbo.proc_packs p on c.id = p.pallet
INNER JOIN		FD_Innova.dbo.proc_prunits r on p.inventory = r.prunit
LEFT JOIN		FD_Innova.dbo.proc_invlocations i on p.invlocation = i.id
INNER JOIN		FD_Innova.dbo.proc_materials m on p.material = m.material
INNER JOIN		FD_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype


WHERE			st.[description] = @stocktake and sc.countstatus = 0

GROUP BY		st.[description],c.number,p.sscc,m.code,m.[name], p.[value],mt.[name],i.code,r.[name],st.stocktake,r.prunit,p.regtime

END

--==================================================================================================================================
-- FOYLE GLOUCESTER
--==================================================================================================================================
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
			   ,CASE WHEN c.sscc IS NULL THEN 0 ELSE c.number end as Pallet
			   ,p.sscc AS PackSSCC
			   ,loc.code as Invlocation
			   ,p.regtime as Regtime
	  

FROM			FG_Innova.dbo.proc_stocktakes st 
INNER JOIN		FG_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
INNER JOIN		FG_Innova.dbo.proc_packs p on sp.pack = p.id 
INNER JOIN		FG_Innova.dbo.proc_materials m on p.material = m.material
INNER JOIN		FG_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
LEFT JOIN		FG_Innova.dbo.proc_collections c on p.pallet = c.id 
INNER JOIN		FG_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FG_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id

WHERE		    st.[description] = @stocktake and sp.countstatus = 0

GROUP BY		st.stocktake,st.[description],r.[name],c.number,c.sscc,p.sscc,loc.code,m.code,m.[name],m.[value],mt.[name],p.regtime 


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
INNER JOIN		FG_Innova.dbo.proc_stocktakes st on sc.stocktake = st.stocktake
INNER JOIN		FG_Innova.dbo.proc_collections c on sc.[collection] = c.id
INNER JOIN		FG_Innova.dbo.proc_packs p on c.id = p.pallet
INNER JOIN		FG_Innova.dbo.proc_prunits r on p.inventory = r.prunit
LEFT JOIN		FG_Innova.dbo.proc_invlocations i on p.invlocation = i.id
INNER JOIN		FG_Innova.dbo.proc_materials m on p.material = m.material
INNER JOIN		FG_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype


WHERE			st.[description] = @stocktake and sc.countstatus = 0

GROUP BY		st.[description],c.number,p.sscc,m.code,m.[name], p.[value],mt.[name],i.code,r.[name],st.stocktake,r.prunit,p.regtime
END  
--==================================================================================================================================
-- FOYLE HILTON
--==================================================================================================================================
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
			   ,CASE WHEN c.sscc IS NULL THEN 0 ELSE c.number end as Pallet
			   ,p.sscc AS PackSSCC
			   ,loc.code as Invlocation
			   ,p.regtime as Regtime
	  

FROM			FH_Innova.dbo.proc_stocktakes st 
INNER JOIN		FH_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
INNER JOIN		FH_Innova.dbo.proc_packs p on sp.pack = p.id 
INNER JOIN		FH_Innova.dbo.proc_materials m on p.material = m.material
INNER JOIN		FH_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
LEFT JOIN		FH_Innova.dbo.proc_collections c on p.pallet = c.id 
INNER JOIN		FH_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FH_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id

WHERE		    st.[description] = @stocktake and sp.countstatus = 0

GROUP BY		st.stocktake,st.[description],r.[name],c.number,c.sscc,p.sscc,loc.code,m.code,m.[name],m.[value],mt.[name],p.regtime 


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
INNER JOIN		FH_Innova.dbo.proc_stocktakes st on sc.stocktake = st.stocktake
INNER JOIN		FH_Innova.dbo.proc_collections c on sc.[collection] = c.id
INNER JOIN		FH_Innova.dbo.proc_packs p on c.id = p.pallet
INNER JOIN		FH_Innova.dbo.proc_prunits r on p.inventory = r.prunit
LEFT JOIN		FH_Innova.dbo.proc_invlocations i on p.invlocation = i.id
INNER JOIN		FH_Innova.dbo.proc_materials m on p.material = m.material
INNER JOIN		FH_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype


WHERE			st.[description] = @stocktake and sc.countstatus = 0

GROUP BY		st.[description],c.number,p.sscc,m.code,m.[name], p.[value],mt.[name],i.code,r.[name],st.stocktake,r.prunit,p.regtime
END


--==================================================================================================================================
-- FOYLE INGREDIENTS
--==================================================================================================================================
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
			   ,CASE WHEN c.sscc IS NULL THEN 0 ELSE c.number end as Pallet
			   ,p.sscc AS PackSSCC
			   ,loc.code as Invlocation
			   ,p.regtime as Regtime
	  

FROM			FI_Innova.dbo.proc_stocktakes st 
INNER JOIN		FI_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
INNER JOIN		FI_Innova.dbo.proc_packs p on sp.pack = p.id 
INNER JOIN		FI_Innova.dbo.proc_materials m on p.material = m.material
INNER JOIN		FI_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
LEFT JOIN		FI_Innova.dbo.proc_collections c on p.pallet = c.id 
INNER JOIN		FI_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FI_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id

WHERE		    st.[description] = @stocktake and sp.countstatus = 0

GROUP BY		st.stocktake,st.[description],r.[name],c.number,c.sscc,p.sscc,loc.code,m.code,m.[name],m.[value],mt.[name],p.regtime 


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
INNER JOIN		FI_Innova.dbo.proc_stocktakes st on sc.stocktake = st.stocktake
INNER JOIN		FI_Innova.dbo.proc_collections c on sc.[collection] = c.id
INNER JOIN		FI_Innova.dbo.proc_packs p on c.id = p.pallet
INNER JOIN		FI_Innova.dbo.proc_prunits r on p.inventory = r.prunit
LEFT JOIN		FI_Innova.dbo.proc_invlocations i on p.invlocation = i.id
INNER JOIN		FI_Innova.dbo.proc_materials m on p.material = m.material
INNER JOIN		FI_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype


WHERE			st.[description] = @stocktake and sc.countstatus = 0

GROUP BY		st.[description],c.number,p.sscc,m.code,m.[name], p.[value],mt.[name],i.code,r.[name],st.stocktake,r.prunit,p.regtime
END

END

GO
