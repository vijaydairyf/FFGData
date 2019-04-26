SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_Canada_Batchs_Shipping_Rpt_FMM_By_Order]
	-- Add the parameters for the stored procedure here
@ordername NVARCHAR(20)

-- exec [dbo].[usrrep_Canada_Batchs_Shipping_Rpt_FC_By_Order] 'FFGSO'

AS
BEGIN
Select pp.fixedcode, pm.code , pm.[name], COunt(pp.sscc) as QTY, Cast(SUM(pp.nominal) as decimal(18,2)) as [Weight], pp.prday
from [FFGSQL03].[FMM_Innova].[dbo].proc_packs pp
left join [FFGSQL03].[FMM_Innova].[dbo].proc_materials as pm with (nolock) on pm.material = pp.material
left join [FFGSQL03].[FMM_Innova].[dbo].proc_orders as po with (nolock) on po.[order] = pp.[order]
left join [FFGSQL03].[FMM_Innova].[dbo].base_companies as com with (nolock) on com.company = po.customer
where 
po.[name] = @ordername
and pm.code in ('994825960','994825961','994825962','964825688','994825969')
and pp.inventory IS NOT NULL
AND pp.rtype <> 4

group by pp.fixedcode, pm.code, pm.[name], pp.prday

END
GO
