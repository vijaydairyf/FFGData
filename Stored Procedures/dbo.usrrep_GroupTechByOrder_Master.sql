SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <20/07/17>
-- Description:	<Site Identifier For SalesOrderDetail Report>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_GroupTechByOrder_Master]

--exec [dbo].[usrrep_GroupTechByOrder_Master] FFGSO236435 ,'United Kingdom', 'FO'
@Order nvarchar (15),
@site nvarchar (3)


AS


IF @site = 'FO'
begin
EXEC					[dbo].[ussrep_GroupTechByOrder_FC] @Order
end

IF @site = 'FC'
begin
EXEC					[dbo].[usrrep_GroupTechByOrder_FC] @Order
end

IF @site = 'FG'
begin
EXEC					[dbo].[usrrep_GroupTechByOrder_FG] @Order
end

IF @site = 'FD'
begin
EXEC					[dbo].[usrrep_GroupTechByOrder_FD] @Order
end

IF @site = 'FH'
begin
EXEC					[dbo].[usrrep_GroupTechByOrder_FH] @Order
end

IF @site = 'FI'
begin
EXEC					[dbo].[usrrep_GroupTechByOrder_FI] @Order
end

IF @site = 'FMM'
begin
EXEC					[dbo].[usrrep_GroupTechByOrder_FMM] @Order
end

--IF @site = 'FO'
--begin
--EXEC					[FFGSQL03].FO_Innova.[dbo].[usrrep_GroupTechByOrder] @Order
--end

--IF @site = 'FC'
--begin
--EXEC					[FFGSQL03].FM_Innova.[dbo].[usrrep_GroupTechByOrder] @Order
--end

--IF @site = 'FG'
--begin
--EXEC					[FFGSQL03].FG_Innova.[dbo].[usrrep_GroupTechByOrder] @Order
--end

--IF @site = 'FD'
--begin
--EXEC					[FFGSQL03].FD_Innova.[dbo].[usrrep_GroupTechByOrder] @Order
--end

--IF @site = 'FH'
--begin
--EXEC					[FFGSQL03].FH_Innova.[dbo].[usrrep_GroupTechByOrder] @Order
--end

--IF @site = 'FI'
--begin
--EXEC					[FFGSQL03].FI_Innova.[dbo].[usrrep_GroupTechByOrder] @Order
--end

--IF @site = 'FMM'
--begin
--EXEC					[FFGSQL03].FMM_Innova.[dbo].[usrrep_GroupTechByOrder] @Order
--end
GO
