SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe Maguire>
-- Create date: <Create Date,,12/09/2017>
-- Description:	<Description,,Master >
-- =============================================

-- exec[usrrep_Intercompany_To_Omagh_MASTER] 'fg','2018-03-12','2018-03-12'
CREATE PROCEDURE [dbo].[usrrep_Intercompany_To_Omagh_MASTER]
	-- Add the parameters for the stored procedure here
 @site as nvarchar(3),
 @StartDate date,
 @EndDate date
AS
DECLARE @InterCompanyTransfers table (
PalletNO nvarchar(14),
SSCC nvarchar(50),
OrderNO nvarchar(15),
Customer nvarchar (250),
ProductName nvarchar(300),
ProductCode nvarchar(20),
QTY smallint,
WGT decimal(10,2),
TransactionTime date,
Inventory nvarchar(250),
OrderStatus nvarchar(20),
TotValue decimal(10,2),
CurrentInv nvarchar(450),
TransferComplete nvarchar(5)

)


BEGIN
if @site = 'FC'
BEGIN
INSERT INTO @InterCompanyTransfers
Exec [usrrep_Intercompany_To_Omagh_FC] @StartDate, @EndDate
SELECT * FROM @InterCompanyTransfers
END

if @site = 'FD'
BEGIN
INSERT INTO @InterCompanyTransfers
Exec [usrrep_Intercompany_To_Omagh_FD]@StartDate, @EndDate
SELECT * FROM @InterCompanyTransfers
END

if @site = 'FG'
BEGIN
INSERT INTO @InterCompanyTransfers
Exec [usrrep_Intercompany_To_Omagh_FG]@StartDate, @EndDate
SELECT * FROM @InterCompanyTransfers
END

if @site = 'FMM'
BEGIN
INSERT INTO @InterCompanyTransfers
Exec [usrrep_Intercompany_To_Omagh_FMM] @StartDate, @EndDate
SELECT * FROM @InterCompanyTransfers
END

if @site = 'FH'
BEGIN
INSERT INTO @InterCompanyTransfers
Exec [usrrep_Intercompany_To_Omagh_FH] @StartDate, @EndDate
SELECT * FROM @InterCompanyTransfers
END

if @site = 'FO'
BEGIN
INSERT INTO @InterCompanyTransfers
Exec [usrrep_Intercompany_FO]@StartDate, @EndDate
SELECT * FROM @InterCompanyTransfers
END

if @site = 'FI'
BEGIN
INSERT INTO @InterCompanyTransfers
Exec [usrrep_Intercompany_To_FI]@StartDate, @EndDate
SELECT * FROM @InterCompanyTransfers
END

END


--BEGIN
--if @site = 'FC'
--BEGIN
--INSERT INTO @InterCompanyTransfers
--Exec [FM_Innova].[dbo].[usrrep_Intercompany_To_Omagh] @StartDate, @EndDate
--SELECT * FROM @InterCompanyTransfers
--END

--if @site = 'FD'
--BEGIN
--INSERT INTO @InterCompanyTransfers
--Exec [FD_Innova].[dbo].[usrrep_Intercompany_To_Omagh]@StartDate, @EndDate
--SELECT * FROM @InterCompanyTransfers
--END

--if @site = 'FG'
--BEGIN
--INSERT INTO @InterCompanyTransfers
--Exec [FG_innova].[dbo].[usrrep_Intercompany_To_Omagh]@StartDate, @EndDate
--SELECT * FROM @InterCompanyTransfers
--END

--if @site = 'FMM'
--BEGIN
--INSERT INTO @InterCompanyTransfers
--Exec [FMM_innova].[dbo].[usrrep_Intercompany_To_Omagh] @StartDate, @EndDate
--SELECT * FROM @InterCompanyTransfers
--END

--if @site = 'FH'
--BEGIN
--INSERT INTO @InterCompanyTransfers
--Exec [FH_innova].[dbo].[usrrep_Intercompany_To_Omagh] @StartDate, @EndDate
--SELECT * FROM @InterCompanyTransfers
--END

--if @site = 'FO'
--BEGIN
--INSERT INTO @InterCompanyTransfers
--Exec [FO_Innova].[dbo].[usrrep_Intercompany_]@StartDate, @EndDate
--SELECT * FROM @InterCompanyTransfers
--END

--if @site = 'FI'
--BEGIN
--INSERT INTO @InterCompanyTransfers
--Exec [FI_Innova].[dbo].[usrrep_Intercompany_To_]@StartDate, @EndDate
--SELECT * FROM @InterCompanyTransfers
--END

--END
GO
