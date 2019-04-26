SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--[dbo].[usrrep_PingoOrderSheet-Technical_Master]  'FD','360410'
CREATE PROCEDURE [dbo].[usrrep_PingoOrderSheet-Technical_Master] 
	-- Add the parameters for the stored procedure here
	@Site NVARCHAR(3),
	@OrderNo NVARCHAR(11)
AS
BEGIN

DECLARE @info TABLE(

ID INT NULL,
PalletNo NVARCHAR(max) NULL,
Department NVARCHAR(150)NULL,
Product NVARCHAR(max)NULL,
[Description] NVARCHAR(MAX)NULL,
BoxNo NVARCHAR(25)NULL,
BoxWeight DECIMAL(10,2)NULL,
BoxTare DECIMAL(10,2)NULL,
Created DATETIME NULL,
Updated DATETIME NULL,
ArtNo NVARCHAR(max)NULL,
ArticleNo NVARCHAR(max)NULL,
ExpiryDate DATE NULL,
CrateType NVARCHAR(max)NULL,
KillDate DATE NULL,
PackDate DATE NULL,
DNOB DATE NULL,
LotCode NVARCHAR(MAX)NULL,
BornIn NVARCHAR(max)NULL,
RearedIn  NVARCHAR(max)NULL,
SlaughteredIn  NVARCHAR(max) NULL,
BonedIn  NVARCHAR(max)NULL,
[DayOfYear] INT NULL,
[Name]  NVARCHAR(max)NULL,
[Depot] NVARCHAR(MAX)NULL,
CustomerName NVARCHAR(max)NULL,
Country  NVARCHAR(max),
SiteCode INT,
External_Doc_No  NVARCHAR(max),
[Value] DECIMAL(10,2) NULL,
Batch  NVARCHAR(max)NULL



)
	
	IF @Site = 'FD'
	BEGIN
		INSERT INTO @info
		EXEC FD_Innova.dbo.[usrrep_Technical_Trace_ByOrder] @OrderNo
		SELECT * FROM @info
	END

	IF @Site = 'FMM'
	BEGIN
		INSERT INTO @info
		EXEC FMM_innova.dbo.[usrrep_Technical_Trace_ByOrder] @OrderNo
		SELECT * FROM @info
	END 
    


END
GO
