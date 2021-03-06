SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <20/07/17>
-- Description:	<Site Identifier For Yield Reports>
-- =============================================


--EXEC [RPT_GrocontinentalStockbyProduct] FG

CREATE PROCEDURE [dbo].[RPT_GrocontinentalStockbyProduct]

@site nvarchar(3)



AS


--IF @site = 'FO'
--begin

--EXEC					[FFGSQL03].FO_Innova.[dbo].[RPT_GrocontinentalStockbyProduct]
--end

--IF @site = 'FC'
--begin

--EXEC					[FFGSQL03].FM_Innova.[dbo].[RPT_GrocontinentalStockbyProduct]
--end

IF @site = 'FG'
begin

EXEC					[FFGSQL03].FG_Innova.[dbo].[RPT_GrocontinentalStockbyProduct]
end

--IF @site = 'FD'
--begin

--EXEC					[FFGSQL03].FD_Innova.[dbo].[RPT_GrocontinentalStockbyProduct]
--end

--IF @site = 'FH'
--begin

--EXEC					[FFGSQL03].FH_Innova.[dbo].[RPT_GrocontinentalStockbyProduct]
--end

--IF @site = 'FI'
--begin

--EXEC					[FFGSQL03].FI_Innova.[dbo].[RPT_GrocontinentalStockbyProduct]
--end

IF @site = 'FMM'
begin

EXEC					[FFGSQL03].FMM_Innova.[dbo].[RPT_GrocontinentalStockbyProduct]
end

GO
