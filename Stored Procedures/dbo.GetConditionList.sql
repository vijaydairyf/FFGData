SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <29/03/19>
-- Description:	<Get list of current in stock conditions>
-- =============================================
CREATE PROCEDURE [dbo].[GetConditionList]
	

AS
BEGIN

SELECT DISTINCT con.[name]
FROM FO_Innova.[dbo].proc_packs AS pp (NOLOCK)
LEFT JOIN FO_Innova.[dbo].proc_prunits AS pr WITH (NOLOCK) ON pr.prunit = pp.inventory
LEFT JOIN FO_Innova.dbo.proc_materials AS pm WITH (NOLOCK) ON pm.material = pp.material
LEFT JOIN FO_Innova.dbo.proc_conditions AS con WITH (NOLOCK) ON con.condition = pm.condition
WHERE pr.description2 = 'stock' AND con.[name] IS NOT NULL AND pm.fabcode3 = 'FRESH'

union

SELECT DISTINCT con.[name]
FROM FD_Innova.[dbo].proc_packs  AS pp (NOLOCK)
LEFT JOIN FD_Innova.[dbo].proc_prunits AS pr WITH (NOLOCK) ON pr.prunit = pp.inventory
LEFT JOIN FD_Innova.dbo.proc_materials AS pm WITH (NOLOCK) ON pm.material = pp.material
LEFT JOIN FD_Innova.dbo.proc_conditions AS con WITH (NOLOCK) ON con.condition = pm.condition
WHERE pr.description2  = 'stock' AND con.[name] IS NOT NULL AND pm.fabcode3 = 'FRESH'

union

SELECT DISTINCT con.[name]
FROM FG_Innova.[dbo].proc_packs  AS pp (NOLOCK)
LEFT JOIN FG_Innova.[dbo].proc_prunits AS pr WITH (NOLOCK) ON pr.prunit = pp.inventory
LEFT JOIN FG_Innova.dbo.proc_materials AS pm WITH (NOLOCK) ON pm.material = pp.material
LEFT JOIN FG_Innova.dbo.proc_conditions AS con WITH (NOLOCK) ON con.condition = pm.condition
WHERE pr.description2  = 'stock'  AND con.[name] IS NOT NULL AND pm.fabcode3 = 'FRESH'

union

SELECT DISTINCT con.[name]
FROM FH_Innova.[dbo].proc_packs  AS pp (NOLOCK)
LEFT JOIN FH_Innova.[dbo].proc_prunits AS pr WITH (NOLOCK) ON pr.prunit = pp.inventory
LEFT JOIN FH_Innova.dbo.proc_materials AS pm WITH (NOLOCK) ON pm.material = pp.material
LEFT JOIN FH_Innova.dbo.proc_conditions AS con WITH (NOLOCK) ON con.condition = pm.condition
WHERE pr.description2  = 'stock' AND con.[name] IS NOT NULL AND pm.fabcode3 = 'FRESH'

union

SELECT DISTINCT con.[name]
FROM FI_Innova.[dbo].proc_packs  AS pp (NOLOCK)
LEFT JOIN FI_Innova.[dbo].proc_prunits AS pr WITH (NOLOCK) ON pr.prunit = pp.inventory
LEFT JOIN FI_Innova.dbo.proc_materials AS pm WITH (NOLOCK) ON pm.material = pp.material
LEFT JOIN FI_Innova.dbo.proc_conditions AS con WITH (NOLOCK) ON con.condition = pm.condition
WHERE pr.description2  = 'stock' AND con.[name] IS NOT NULL AND pm.fabcode3 = 'FRESH'

union

SELECT DISTINCT con.[name]
FROM FMM_Innova.[dbo].proc_packs  AS pp (NOLOCK)
LEFT JOIN FMM_Innova.[dbo].proc_prunits AS pr WITH (NOLOCK) ON pr.prunit = pp.inventory
LEFT JOIN FMM_Innova.dbo.proc_materials AS pm WITH (NOLOCK) ON pm.material = pp.material
LEFT JOIN FMM_Innova.dbo.proc_conditions AS con WITH (NOLOCK) ON con.condition = pm.condition
WHERE pr.description2  = 'stock'  AND con.[name] IS NOT NULL AND pm.fabcode3 = 'FRESH' 

UNION 

SELECT DISTINCT con.[name] COLLATE DATABASE_DEFAULT
FROM FM_Innova.[dbo].proc_packs  AS pp (NOLOCK)
LEFT JOIN FM_Innova.[dbo].proc_prunits AS pr WITH (NOLOCK) ON pr.prunit = pp.inventory
LEFT JOIN FM_Innova.dbo.proc_materials AS pm WITH (NOLOCK) ON pm.material = pp.material
LEFT JOIN FM_Innova.dbo.proc_conditions AS con WITH (NOLOCK) ON con.condition = pm.condition
WHERE pr.description2  = 'stock' AND con.[name] IS NOT NULL AND pm.fabcode3 = 'FRESH'


ORDER BY con.[name] asc
END
GO
