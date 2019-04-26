SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <06/02/19>
-- Description:	<Insert of data into table Group Fresh Daily Snapshot for FI site>
-- =============================================

--EXEC [dbo].[Group_Fresh_StockSnapshot_Daily_Insert]

CREATE PROCEDURE [dbo].[Group_Fresh_StockSnapshot_Daily_Insert_FI]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


INSERT INTO [dbo].[Group_Fresh_Snapshot_Daily]

   SELECT GETDATE() AS ImportDate, 'FI' AS SITEID, pm.code AS ProductCode, pm.description1 AS ProductName, mt.[name] AS MaterialType, con.name AS [condition], pr.name AS Inventory,
		pp.prday AS ProductionDay, pp.expire2 AS KillDate, pp.expire1 AS UseByDate, pp.expire3 AS DNOBDate, SUM(pp.weight) AS [weight], pm.[value] AS [P/KG], 
		(SUM(pp.weight) * pm.[value])  AS [Value], COUNT(pp.sscc) AS QTY

FROM [FFGSQL03].[FI_Innova].dbo.proc_packs AS pp
	 left JOIN [FFGSQL03].[FI_Innova].dbo.proc_materials AS pm WITH (NOLOCK) ON pm.material = pp.material	
	 left JOIN [FFGSQL03].[FI_Innova].dbo.proc_materialtypes AS mt WITH (NOLOCK) ON mt.materialtype = pm.materialtype
	 left JOIN [FFGSQL03].[FI_Innova].dbo.proc_prunits AS pr WITH (NOLOCK) ON pr.prunit = pp.inventory
	 LEFT JOIN [FFGSQL03].[FI_Innova].dbo.proc_conditions AS con WITH (NOLOCK) ON pm.condition = con.condition	
	 
	 	
	WHERE pr.description1 NOT LIKE '%FROZEN%' AND pr.description2 = 'STOCK' AND pp.regtime <> GETDATE() AND pm.code <> '999999999'

	AND pp.[weight] > 0.1 AND mt.[name] NOT LIKE '%Waste%' AND pm.fabcode3  = 'FRESH'


	GROUP BY pm.code, pm.description1, mt.name, con.name, pr.name, pp.prday, pp.expire2, pp.expire1, pp.expire3, pm.[value] 

END
GO
