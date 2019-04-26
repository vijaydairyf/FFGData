SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,JOE MAGUIRE>
-- Create date: <Create Date,,>
-- Description:	<Description,,SSRS SCHEDULED REPORT - SNAPSHOT ON A SUNDAY>
-- =============================================
--exec [dbo].[usrrep_StockTakeFoundUnits] 'VacPac 19/12/2018 11:27:56'
--exec [dbo].[usrrep_StockTakeFoundUnits_CategoryBreakdown]'FO','VacPac 07/02/2019 11:00:11'
--EXEC [dbo].[usrrep_StockTakeFoundUnits_CategoryBreakDown] 'FD', 'B/Hall Stock 13/03/2019 09:10:42'
CREATE PROCEDURE [dbo].[usrrep_StockTakeFoundUnits_CategoryBreakDown] 
	@Site nvarchar(3),
	@stocktake nvarchar(50)

AS
BEGIN
--=========================================================================================================================
--FOYLE OMAGH
--=========================================================================================================================
if @Site = 'FO'
Begin
--FOUND UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'FOUND'													AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FO_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FO_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FO_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FO_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FO_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FO_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FO_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 3 

UNION

--NOT FOUND UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'NOT FOUND'												AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FO_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FO_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FO_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FO_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FO_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FO_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FO_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 0 

UNION

--NEW UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'NEW UNITS'												AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FO_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FO_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FO_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FO_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FO_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FO_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FO_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 4


UNION

--MOVED OUT UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'MOVED' 												AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FO_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FO_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FO_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FO_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FO_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FO_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FO_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 1

END

--=========================================================================================================================
--FOYLE CAMPSIE
--=========================================================================================================================

IF  @Site = 'FC'
BEGIN 
--FOUND UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'FOUND'													AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FM_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FM_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FM_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FM_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FM_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FM_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FM_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 3 

UNION

--NOT FOUND UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'NOT FOUND'												AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FM_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FM_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FM_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FM_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FM_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FM_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FM_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 0 

UNION

--NEW UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'NEW UNITS'												AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FM_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FM_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FM_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FM_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FM_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FM_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FM_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 4


UNION

--MOVED OUT UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'MOVED' 												AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FM_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FM_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FM_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FM_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FM_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FM_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FM_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 1

END

--=========================================================================================================================
--FOYLE DONEGAL
--=========================================================================================================================

IF  @Site = 'FD'
BEGIN 
--FOUND UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'FOUND'													AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FD_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FD_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FD_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FD_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FD_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FD_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FD_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 3 

UNION

--NOT FOUND UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'NOT FOUND'												AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FD_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FD_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FD_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FD_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FD_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FD_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FD_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 0 

UNION

--NEW UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'NEW UNITS'												AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FD_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FD_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FD_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FD_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FD_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FD_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FD_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 4


UNION

--MOVED OUT UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'MOVED' 												AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FD_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FD_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FD_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FD_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FD_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FD_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FD_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 1

END

--=========================================================================================================================
--FOYLE GLOUCESTER
--=========================================================================================================================
if @Site = 'FG'
Begin
--FOUND UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'FOUND'													AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FG_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FG_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FG_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FG_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FG_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FG_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FG_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 3 

UNION

--NOT FOUND UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'NOT FOUND'												AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FG_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FG_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FG_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FG_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FG_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FG_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FG_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 0 

UNION

--NEW UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'NEW UNITS'												AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FG_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FG_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FG_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FG_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FG_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FG_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FG_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 4


UNION

--MOVED OUT UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'MOVED' 												AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FG_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FG_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FG_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FG_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FG_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FG_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FG_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 1

END

--=========================================================================================================================
--FOYLE HILTON
--=========================================================================================================================
if @Site = 'FH'
Begin
--FOUND UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'FOUND'													AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FH_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FH_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FH_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FH_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FH_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FH_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FH_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 3 

UNION

--NOT FOUND UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'NOT FOUND'												AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FH_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FH_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FH_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FH_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FH_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FH_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FH_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 0 

UNION

--NEW UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'NEW UNITS'												AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FH_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FH_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FH_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FH_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FH_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FH_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FH_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 4


UNION

--MOVED OUT UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'MOVED' 												AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FH_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FH_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FH_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FH_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FH_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FH_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FH_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 1

END

--=========================================================================================================================
--FOYLE INGREDIENTS
--=========================================================================================================================
if @Site = 'FI'
Begin
--FOUND UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'FOUND'													AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FI_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FI_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FI_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FI_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FI_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FI_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FI_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 3 

UNION

--NOT FOUND UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'NOT FOUND'												AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FI_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FI_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FI_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FI_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FI_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FI_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FI_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 0 

UNION

--NEW UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'NEW UNITS'												AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FI_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FI_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FI_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FI_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FI_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FI_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FI_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 4


UNION

--MOVED OUT UNITS 
SELECT			
				mt.description3 + ' : ' + mt.[name]						AS ProductType	
			   ,st.stocktake											AS  stocktakeid
			   ,st.[description]										AS  StockTake
			   ,r.[name]												AS Inventory
			   ,m.code													AS ProductCode
			   ,m.[name]												AS ProductDescription
			   ,p.number											    AS PackNo
			   ,CAST(p.[weight] AS DECIMAL(10,2))					    AS Wgt  
			   ,m.[value]												AS [P/kg]
			   ,CAST(p.[weight]*m.[value]AS DECIMAL(10,2))			    AS [Value] 
			   ,m.fabcode2
			   ,CASE WHEN mt.description3 LIKE '%OFFAL%' 
						THEN  m.fabcode3 + ' OFFAL'
						ELSE m.fabcode3
						END												AS Fabcode3
			   ,loc.code												AS Invlocation
			   ,p.sscc													AS SSCC
			   ,'MOVED' 												AS CountStatus
			   ,sp.countstatus										    AS CountStatusID 

FROM			FI_Innova.dbo.proc_stocktakes st 
LEFT JOIN		FI_Innova.dbo.proc_stocktakep sp on st.stocktake = sp.stocktake
LEFT JOIN		FI_Innova.dbo.proc_packs p on sp.pack = p.id 
LEFT JOIN		FI_Innova.dbo.proc_materials m on p.material = m.material
LEFT JOIN		FI_Innova.dbo.proc_materialtypes mt on m.materialtype = mt.materialtype
INNER JOIN		FI_Innova.dbo.proc_prunits r on p.inventory = r.prunit 
LEFT JOIN		FI_Innova.dbo.proc_invlocations loc on p.invlocation = loc.id
WHERE		    st.[description] = @stocktake AND sp.countstatus = 1

END


END

GO
