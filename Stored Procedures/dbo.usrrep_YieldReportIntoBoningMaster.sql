SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <08/12/16>
-- Description:	<Site Identifier For Yield Reports>
-- =============================================

--exec [usrrep_YieldReportIntoBoningMaster] '01/15/2019','01/15/2019', '141616101012','0','999999', 'FH'

CREATE PROCEDURE [dbo].[usrrep_YieldReportIntoBoningMaster]

@BeginDate datetime,
@EndDate datetime,
@_Lots nvarchar(max),
@FromBatch int,
@ToBatch int,
@Site nvarchar(10)



AS

declare @tbl1 table (HQTotal DECIMAL(18,2),FQTotal DECIMAL(18,2), [Into Boning Code] nvarchar(20), [Into Boning Description] nvarchar(100), [Into Boning Name] nvarchar(100), 
					[Into Boning QTY] int, [Into Boning WEIGHT] decimal(18,2), [Into Boning Lots] nvarchar(20), [ValuePerKg] DECIMAL(18,2), [Value] DECIMAL(18,2) )



IF @site = 'FO'
BEGIN
INSERT INTO @tbl1
EXEC					[usrrep_YieldReportIntoBoning_FO] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch
Select * from @tbl1
end

IF @site = 'FC BH 1'
BEGIN
INSERT INTO @tbl1
EXEC					[usrrep_YieldReportIntoBoning_FC] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch
Select * from @tbl1
end

IF @site = 'FC BH 2'
BEGIN
INSERT INTO @tbl1
EXEC					[usrrep_YieldReportIntoBoning_FC_BH2] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch
Select * from @tbl1

end

IF @site = 'FG'
BEGIN
INSERT INTO @tbl1
EXEC					[usrrep_YieldReportIntoBoning_FG] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch
Select * from @tbl1

end

IF @site = 'FD'
BEGIN
INSERT INTO @tbl1
EXEC					[usrrep_YieldReportIntoBoning_FD] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch
Select * from @tbl1

end

IF @site = 'FH'
BEGIN
INSERT INTO @tbl1
EXEC					[usrrep_YieldReportIntoBoning_FH] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch
Select * from @tbl1

End

--IF @site = 'FI'
--begin
--EXEC					[usrrep_YieldReportIntoBoning_FI] @BeginDate, @EndDate, @_Lots, @FromBatch, @ToBatch

--end
GO
