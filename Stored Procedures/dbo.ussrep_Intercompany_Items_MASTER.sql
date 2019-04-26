SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

-- exec [ussrep_Intercompany_Items_MASTER] 'FG','2017-08-01','2017-11-01'
CREATE PROCEDURE [dbo].[ussrep_Intercompany_Items_MASTER]
	
 @site as nvarchar(3),
 @StartDate date, 
 @EndDate date
AS

Declare @items table(
Order_NO nvarchar(25),
ProductCode nvarchar(25),
Product nvarchar(35),
EXTCODE nvarchar(20),
WGT_Items decimal(10,2),
Value_Items decimal(10,2),
Rec_Site nvarchar(30),
Time_Sent Datetime,
Inventory nvarchar(25),
OrderStatus nvarchar(20),
Complete nvarchar(15)
)


BEGIN
if @site = 'FC'
BEGIN
INSERT INTO @items
Exec [ussrep_Intercompany_ITEMS_FC] @StartDate, @EndDate
Select * from @items
END

if @site = 'FD'
BEGIN
INSERT INTO @items
Exec [ussrep_Intercompany_ITEMS_FD]@StartDate, @EndDate
Select * from @items


END

if @site = 'FG'
BEGIN
INSERT INTO @items
Exec [ussrep_Intercompany_ITEMS_FG]@StartDate, @EndDate
Select * from @items
END

if @site = 'FMM'
BEGIN
INSERT INTO @items
Exec [ussrep_Intercompany_ITEMS_FMM] @StartDate, @EndDate
Select * from @items
END

if @site = 'FH'
BEGIN
INSERT INTO @items
Exec [ussrep_Intercompany_ITEMS_FH] @StartDate, @EndDate
Select * from @items
END

if @site = 'FO'
BEGIN
INSERT INTO @items 
EXEC [ussrep_Intercompany_ITEMS_FO] @StartDate, @EndDate
SELECT * FROM @items
END

--if @site = 'FI'
--BEGIN
--INSERT INTO @items 
--EXEC [FI_innova].[dbo].[ussrep_Intercompany_ITEMS_FI] @StartDate, @EndDate
--SELECT * FROM @items
--END

END


--BEGIN
--if @site = 'FC'
--BEGIN
--INSERT INTO @items
--Exec [FM_Innova].[dbo].[ussrep_Intercompany_ITEMS_FC] @StartDate, @EndDate
--Select * from @items
--END

--if @site = 'FD'
--BEGIN
--INSERT INTO @items
--Exec [FD_Innova].[dbo].[ussrep_Intercompany_ITEMS_FD]@StartDate, @EndDate
--Select * from @items


--END

--if @site = 'FG'
--BEGIN
--INSERT INTO @items
--Exec [FG_innova].[dbo].[ussrep_Intercompany_ITEMS_FG]@StartDate, @EndDate
--Select * from @items
--END

--if @site = 'FMM'
--BEGIN
--INSERT INTO @items
--Exec [FMM_innova].[dbo].[ussrep_Intercompany_ITEMS_FMM] @StartDate, @EndDate
--Select * from @items
--END

--if @site = 'FH'
--BEGIN
--INSERT INTO @items
--Exec [FH_innova].[dbo].[ussrep_Intercompany_ITEMS_FH] @StartDate, @EndDate
--Select * from @items
--END

--if @site = 'FO'
--BEGIN
--INSERT INTO @items 
--EXEC [FO_Innova].[dbo].[ussrep_Intercompany_ITEMS_FO] @StartDate, @EndDate
--SELECT * FROM @items
--END

----if @site = 'FI'
----BEGIN
----INSERT INTO @items 
----EXEC [FI_innova].[dbo].[ussrep_Intercompany_ITEMS_FI] @StartDate, @EndDate
----SELECT * FROM @items
----END

--END
GO
