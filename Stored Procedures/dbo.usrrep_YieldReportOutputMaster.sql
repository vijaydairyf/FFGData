SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <12/07/17>
-- Description:	<Site Identifier For Yield Reports>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_YieldReportOutputMaster]

@BeginDate datetime,
@EndDate datetime,
@_Lots nvarchar(max),
@FromBatch int,
@ToBatch int,
@Site nvarchar(10)

-- exec [dbo].[usrrep_YieldReportOutputMaster] '11/15/2018', '11/15/2018', '111111101012', '0', '99999999', 'FC BH 1'
AS

--DROP TABLE tbl1

IF @site = 'FO'
begin
EXEC					[usrrep_YieldReportOutput_FO] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch
end

IF @site = 'FC BH 1'
begin
EXEC					[usrrep_YieldReportOutput_FC] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch
end

IF @site = 'FC BH 2'
begin
EXEC					[usrrep_YieldReportOutput_FC_BH2] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch
end

IF @site = 'FG'
begin
EXEC					[usrrep_YieldReportOutput_FG] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch
end

IF @site = 'FD'
begin
EXEC					[usrrep_YieldReportOutput_FD] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch
end

IF @site = 'FH'
begin
EXEC				[usrrep_YieldReportOutput_FH] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch
end




--IF @site = 'FO'
--begin
--EXEC					[FFGSQL03].FO_Innova.[dbo].[usrrep_YieldReportOutput] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch
--end

--IF @site = 'FC'
--begin
--EXEC					[FFGSQL03].FM_Innova.[dbo].[usrrep_YieldReportOutput] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch
--end

--IF @site = 'FG'
--begin
--EXEC					[FFGSQL03].FG_Innova.[dbo].[usrrep_YieldReportOutput] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch
--end

--IF @site = 'FD'
--begin
--EXEC					[FFGSQL03].FD_Innova.[dbo].[usrrep_YieldReportOutput] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch
--end

--IF @site = 'FH'
--begin
--EXEC					[FFGSQL03].FH_Innova.[dbo].[usrrep_YieldReportOutput] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch
--end

--IF @site = 'FI'
--begin
--EXEC					[FFGSQL03].FI_Innova.[dbo].[usrrep_YieldReportOutput] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch
--end
GO
