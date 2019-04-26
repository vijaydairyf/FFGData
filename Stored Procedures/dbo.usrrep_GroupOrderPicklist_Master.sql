SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <25/07/17>
-- Description:	<Master SP to call site sp's>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_GroupOrderPicklist_Master]

-- EXEC [dbo].[usrrep_GroupOrderPicklist_Master] 'FO', 'FFGSO252362,FFGSO252363'
	
@Site nvarchar(5),
@OrderNo nvarchar(max)

AS

set @OrderNo = LEFT(@OrderNo,11)

--IF @site = 'FO'
--begin
--EXEC					[FFGSQL03].FO_Innova.[dbo].[usrrep_GroupOrderPicklist] @OrderNo 
--end

--IF @site = 'FC'
--begin
--EXEC					[FFGSQL03].FM_Innova.[dbo].[usrrep_GroupOrderPicklist] @OrderNo 
--end

--IF @site = 'FGL'
--begin
--EXEC					[FFGSQL03].FG_Innova.[dbo].[usrrep_GroupOrderPicklist] @OrderNo 
--end

--IF @site = 'FD'
--begin
--EXEC					[FFGSQL03].FD_Innova.[dbo].[usrrep_GroupOrderPicklist] @OrderNo 
--end

--IF @site = 'FH'
--begin
--EXEC					[FFGSQL03].FH_Innova.[dbo].[usrrep_GroupOrderPicklist] @OrderNo 

--end

--IF @site = 'FI'
--begin
--EXEC					[FFGSQL03].FI_Innova.[dbo].[usrrep_GroupOrderPicklist] @OrderNo 
--end

--IF @site = 'FMM'
--begin
--EXEC					[FFGSQL03].FMM_Innova.[dbo].[usrrep_GroupOrderPicklist] @OrderNo 
--end

--IF @Site = 'FT'		
--begin
--EXEC					[FFGSQLTEST\MSSQL_INNOVA].[Innova_FO].[dbo].[usrrep_GroupOrderPicklist] @OrderNo
--end

IF @site = 'FO'
begin
EXEC					[usrrep_GroupOrderPicklist_FO] @OrderNo 
end

IF @site = 'FC'
begin
EXEC					[usrrep_GroupOrderPicklist_FC] @OrderNo 
end

IF @site = 'FGL'
begin
EXEC					[usrrep_GroupOrderPicklist_FG] @OrderNo 
end

IF @site = 'FD'
begin
EXEC					[usrrep_GroupOrderPicklist_FD] @OrderNo 
end

IF @site = 'FH'
begin
EXEC					[usrrep_GroupOrderPicklist_FH] @OrderNo 

end

IF @site = 'FI'
begin
EXEC					[usrrep_GroupOrderPicklist_FI] @OrderNo 
end

IF @site = 'FMM'
begin
EXEC					[usrrep_GroupOrderPicklist_FMM] @OrderNo 
end

GO
