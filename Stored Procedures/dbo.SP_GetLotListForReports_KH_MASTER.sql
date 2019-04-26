SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <08/12/16>
-- Description:	<Site Identifier For Yield Reports>
-- =============================================


--EXEC [dbo].[SP_GetLotListForReports_KH_MASTER] '01/12/2017','01/12/2017', 'FO', 1

CREATE PROCEDURE [dbo].[SP_GetLotListForReports_KH_MASTER]

@BeginDate datetime,
@EndDate datetime,
@Site nvarchar(3),
@LotsTypes int


AS


IF @site = 'FO'
begin

EXEC					[FFGSQL03].FO_Innova.[dbo].[SP_GetLotListForReports_KH] @BeginDate, @EndDate, @LotsTypes
end

IF @site = 'FC'
begin

EXEC					[FFGSQL03].FM_Innova.[dbo].[SP_GetLotListForReports_KH] @BeginDate, @EndDate, @LotsTypes
end

IF @site = 'FG'
begin

EXEC					[FFGSQL03].FG_Innova.[dbo].[SP_GetLotListForReports_KH] @BeginDate, @EndDate, @LotsTypes
end

IF @site = 'FD'
begin

EXEC					[FFGSQL03].FD_Innova.[dbo].[SP_GetLotListForReports_KH] @BeginDate, @EndDate, @LotsTypes
end

IF @site = 'FH'
begin

EXEC					[FFGSQL03].FH_Innova.[dbo].[SP_GetLotListForReports_KH] @BeginDate, @EndDate, @LotsTypes
end

IF @site = 'FI'
begin

EXEC					[FFGSQL03].FI_Innova.[dbo].[SP_GetLotListForReports_KH] @BeginDate, @EndDate, @LotsTypes
end

GO
