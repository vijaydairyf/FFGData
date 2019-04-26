SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <25/07/17>
-- Description:	<Master SP to call site sp's>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_GroupOrderPicklist_Header_Master]
	
--exec [dbo].[usrrep_GroupOrderPicklist_Header_Master] 'FT','2018/04/11','2018/04/11','SAWYERS','FFGSO275577'

	@Site nvarchar(5),
	@fromshipdate date,
	@toshipdate date,
	@Shipmethod nvarchar(max),
	@extcoldstore nvarchar(max),
	@OrderNo nvarchar(MAX)

AS

set @OrderNo = LEFT(@OrderNo,11)
	

IF @site = 'FO'
begin
EXEC					[usrrep_GroupOrderPicklist_Header_FO] @Site, @fromshipdate,@toshipdate,@Shipmethod,@extcoldstore, @OrderNo 
end

IF @site = 'FC'
begin
EXEC					[usrrep_GroupOrderPicklist_Header_FC] @Site, @fromshipdate,@toshipdate,@Shipmethod,@extcoldstore, @OrderNo 
end

IF @site = 'FGL'
begin
EXEC					[usrrep_GroupOrderPicklist_Header_FGL] @Site, @fromshipdate,@toshipdate,@Shipmethod,@extcoldstore, @OrderNo 
end

IF @site = 'FD'
begin
EXEC					[usrrep_GroupOrderPicklist_Header_FD] @Site, @fromshipdate,@toshipdate,@Shipmethod,@extcoldstore, @OrderNo 
end

IF @site = 'FH'
begin
EXEC					[usrrep_GroupOrderPicklist_Header_FH] @Site, @fromshipdate,@toshipdate,@Shipmethod,@extcoldstore, @OrderNo
--EXEC					
end

IF @site = 'FI'
begin
EXEC					[usrrep_GroupOrderPicklist_Header_FI] @Site, @fromshipdate,@toshipdate,@Shipmethod,@extcoldstore, @OrderNo 
end

IF @site = 'FMM'
begin
EXEC					[usrrep_GroupOrderPicklist_Header_FMM] @Site, @fromshipdate,@toshipdate,@Shipmethod,@extcoldstore, @OrderNo 
end

--IF @Site = 'FT'		
--begin
--EXEC					[FFGSQLTEST\MSSQL_INNOVA].[Innova_FO].[dbo].[usrrep_GroupOrderPicklist_Header] @Site, @fromshipdate,@toshipdate,@Shipmethod,@extcoldstore, @OrderNo 
--end

--IF @site = 'FC'
--begin
--EXEC					[FFGSQL03].FM_Innova.[dbo].[usrrep_GroupOrderPicklist_Header] @Site, @fromshipdate,@toshipdate,@Shipmethod,@extcoldstore, @OrderNo 
--end

--IF @site = 'FGL'
--begin
--EXEC					[FFGSQL03].FG_Innova.[dbo].[usrrep_GroupOrderPicklist_Header] @Site, @fromshipdate,@toshipdate,@Shipmethod,@extcoldstore, @OrderNo 
--end

--IF @site = 'FD'
--begin
--EXEC					[FFGSQL03].FD_Innova.[dbo].[usrrep_GroupOrderPicklist_Header] @Site, @fromshipdate,@toshipdate,@Shipmethod,@extcoldstore, @OrderNo 
--end

--IF @site = 'FH'
--begin
--EXEC					[FFGSQL03].FH_Innova.[dbo].[usrrep_GroupOrderPicklist_Header] @Site, @fromshipdate,@toshipdate,@Shipmethod,@extcoldstore, @OrderNo
----EXEC					
--end

--IF @site = 'FI'
--begin
--EXEC					[FFGSQL03].FI_Innova.[dbo].[usrrep_GroupOrderPicklist_Header] @Site, @fromshipdate,@toshipdate,@Shipmethod,@extcoldstore, @OrderNo 
--end

--IF @site = 'FMM'
--begin
--EXEC					[FFGSQL03].FMM_Innova.[dbo].[usrrep_GroupOrderPicklist_Header] @Site, @fromshipdate,@toshipdate,@Shipmethod,@extcoldstore, @OrderNo 
--end

GO
