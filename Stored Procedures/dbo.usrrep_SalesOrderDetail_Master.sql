SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <20/07/17>
-- Description:	<Site Identifier For SalesOrderDetail Report>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_SalesOrderDetail_Master]

--exec [dbo].[usrrep_SalesOrderDetail_Master] 346362 ,'United Kingdom', 'FMM'
@OrderNo nvarchar (max),
@BIC nvarchar(max),
@site nvarchar (max)



AS


IF @site = 'FO'
begin
EXEC					[dbo].[usrrep_SalesOrderDetail_FO] @OrderNo, @BIC
end

IF @site = 'FC'
begin
EXEC					[dbo].[usrrep_SalesOrderDetail_FC] @OrderNo, @BIC
end

IF @site = 'FG'
begin
EXEC					[dbo].[usrrep_SalesOrderDetail_FG] @OrderNo, @BIC
end

IF @site = 'FD'
begin
EXEC					[dbo].[usrrep_SalesOrderDetail_FD] @OrderNo, @BIC
end

IF @site = 'FH'
begin
EXEC					[dbo].[usrrep_SalesOrderDetail_FH] @OrderNo, @BIC
end

IF @site = 'FI'
begin
EXEC					[dbo].[usrrep_SalesOrderDetail_FI] @OrderNo, @BIC
END

IF @site = 'FMM'
begin
EXEC					[dbo].[usrrep_SalesOrderDetail_FMM] @OrderNo, @BIC
end



--IF @site = 'FO'
--begin
--EXEC					[FFGSQL03].FO_Innova.[dbo].[usrrep_SalesOrderDetail] @OrderNo, @BIC
--end

--IF @site = 'FC'
--begin
--EXEC					[FFGSQL03].FM_Innova.[dbo].[usrrep_SalesOrderDetail] @OrderNo, @BIC
--end

--IF @site = 'FG'
--begin
--EXEC					[FFGSQL03].FG_Innova.[dbo].[usrrep_SalesOrderDetail] @OrderNo, @BIC
--end

--IF @site = 'FD'
--begin
--EXEC					[FFGSQL03].FD_Innova.[dbo].[usrrep_SalesOrderDetail] @OrderNo, @BIC
--end

--IF @site = 'FH'
--begin
--EXEC					[FFGSQL03].FH_Innova.[dbo].[usrrep_SalesOrderDetail] @OrderNo, @BIC
--end

--IF @site = 'FI'
--begin
--EXEC					[FFGSQL03].FI_Innova.[dbo].[usrrep_YieldReportOutput] @OrderNo, @BIC

--IF @site = 'FMM'
--begin
--EXEC					[FFGSQL03].FMM_Innova.[dbo].[usrrep_YieldReportOutput] @OrderNo, @BIC
--end

--END
GO
