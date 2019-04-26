SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <13/06/18>
-- Description:	<usrrep_Carcass_Stock_Report_Master>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_Carcass_Stock_Report_Master]
	-- Add the parameters for the stored procedure here
	@Site nvarchar (5)
AS
BEGIN

if @site = 'FC'
BEGIN
Exec [usrrep_Carcass_Stock_Report_FC]
END

if @site = 'FO'
BEGIN
Exec [usrrep_Carcass_Stock_Report_FO]
END

if @site = 'FD'
BEGIN
Exec [usrrep_Carcass_Stock_Report_FD]
END

if @site = 'FH'
BEGIN
Exec [usrrep_Carcass_Stock_Report_FH]
END

if @site = 'FG'
BEGIN
Exec [usrrep_Carcass_Stock_Report_FG]
END

--if @site = 'FC'
--BEGIN
--Exec [FM_Innova].[dbo].[usrrep_Carcass_Stock_Report]
--END

--if @site = 'FO'
--BEGIN
--Exec [FO_Innova].[dbo].[usrrep_Carcass_Stock_Report]
--END

--if @site = 'FD'
--BEGIN
--Exec [FD_Innova].[dbo].[usrrep_Carcass_Stock_Report]
--END

--if @site = 'FH'
--BEGIN
--Exec [FH_Innova].[dbo].[usrrep_Carcass_Stock_Report]
--END

--if @site = 'FG'
--BEGIN
--Exec [FG_innova].[dbo].[usrrep_Carcass_Stock_Report]
--END


END
GO
