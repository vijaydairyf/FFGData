SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <25/10/18>
-- Description:	<Master SP to call site sp's>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_HR_Dispatch_Summary_Report_Master]

-- EXEC [dbo].[usrrep_HR_Dispatch_Summary_Report_Master] 
@site nvarchar(10),	
@pallet int

AS


IF @site = 'FO'
begin
EXEC					[FFGSQL03].[FFGData].[dbo].[USREP_HR_Dispatch_Summary_Report_FO] @pallet 
end

IF @site = 'FC'
begin
EXEC					[FFGSQL03].[FFGData].[dbo].[USREP_HR_Dispatch_Summary_Report_FC] @pallet 
end

IF @site = 'FG'
begin
EXEC					[FFGSQL03].[FFGData].[dbo].[USREP_HR_Dispatch_Summary_Report_FG] @pallet 
end

IF @site = 'FD'
begin
EXEC					[FFGSQL03].[FFGData].[dbo].[USREP_HR_Dispatch_Summary_Report_FD] @pallet 
end

IF @site = 'FH'
begin
EXEC					[FFGSQL03].[FFGData].[dbo].[USREP_HR_Dispatch_Summary_Report_FH] @pallet 
end

IF @site = 'FI'
begin
EXEC					[FFGSQL03].[FFGData].[dbo].[USREP_HR_Dispatch_Summary_Report_FI] @pallet 
end

IF @site = 'FMM'
begin
EXEC					[FFGSQL03].[FFGData].[dbo].[USREP_HR_Dispatch_Summary_Report_FMM] @pallet 
end

GO
