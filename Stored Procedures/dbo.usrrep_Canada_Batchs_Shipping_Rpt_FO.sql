SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_Canada_Batchs_Shipping_Rpt_FO]
	-- Add the parameters for the stored procedure here
@FromProdDate date,
@ToProdDate date

-- exec [dbo].[usrrep_Canada_Batchs_Shipping_Rpt_FO] '02/08/19', '02/08/19'

AS
BEGIN
Select pp.fixedcode, pm.code , pm.[name], COUNT(pp.sscc) as QTY, Cast(SUM(pp.nominal) as decimal(18,2)) as [Weight], pp.prday, pr.[name]
from [FFGSQL03].[FO_innova].[dbo].proc_packs pp
left join [FFGSQL03].[FO_innova].[dbo].proc_materials as pm with (nolock) on pm.material = pp.material
left join [FFGSQL03].[FO_innova].[dbo].proc_orders as po with (nolock) on po.[order] = pp.[order]
left join [FFGSQL03].[FO_innova].[dbo].base_companies as com with (nolock) on com.company = po.customer
LEFT JOIN [FFGSQL03].[FO_innova].[dbo].proc_prunits AS pr WITH (NOLOCK) ON pr.prunit = pp.inventory
where 
pp.prday Between @FromProdDate and @ToProdDate  
and pm.code in ('994825960','994825961','994825962','964825688','994825969')
and pp.inventory IS NOT NULL AND pr.[name] <> 'Rework'

group by pp.fixedcode, pm.code, pm.[name], pp.prday, pr.[name]

END
GO
