SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 24th October 2018
-- Description:	Open Order on relevant Innova 
-- =============================================

--exec [13748-CreateNewOrder] 'SystemAdmin', '1190129576'

CREATE PROCEDURE [dbo].[13748-CreateNewOrder]

@User NVarChar(50),
@ExistingOrder BigInt

AS

Declare @PrimaryKey Int
Declare @Order BigInt
Declare @OrderCount Int
Declare @Supplier NVarChar(50)
Declare @KillDate DateTime

Set @Order = 0 
Set @OrderCount = 0

Set @Order= IsNull((Select Top 1 [Order] FROM [ffgsql01].[FFG-Production].[dbo].[FFG LIVE$Producer Payment Header] Where [Order]=@ExistingOrder Order By [Primary Key] DESC),0)

If @Order = 0
	BEGIN
		RETURN
	END

Set @PrimaryKey=	(Select Top 1 [Primary Key] FROM [ffgsql01].[FFG-Production].[dbo].[FFG LIVE$Producer Payment Header]	Where [Order]=@ExistingOrder Order By [Primary Key] DESC)
Set @Order=			(Select Top 1 [Order] FROM [ffgsql01].[FFG-Production].[dbo].[FFG LIVE$Producer Payment Header]		Where [Order]=@ExistingOrder Order By [Primary Key] DESC)
Set @Supplier=		(Select Top 1 [Supplier] FROM [ffgsql01].[FFG-Production].[dbo].[FFG LIVE$Producer Payment Header]		Where [Order]=@ExistingOrder Order By [Primary Key] DESC)
Set @KillDate=		(Select Top 1 [Date] FROM [ffgsql01].[FFG-Production].[dbo].[FFG LIVE$Producer Payment Header]			Where [Order]=@ExistingOrder Order By [Primary Key] DESC)
Set @PrimaryKey=@PrimaryKey+990000000

	IF Cast(Right(@Order,3) As Int) >= 500
		BEGIN
			SET @Order = @Order - 499
		END
	ELSE IF Cast(Right(@Order,3) As Int) < 500
		BEGIN
			SET @Order = @Order + 500
		END

Set @OrderCount= IsNull((Select Count([Order]) FROM [ffgsql01].[FFG-Production].[dbo].[FFG LIVE$Producer Payment Header] Where [Order]=@Order),0)

If @OrderCount = 1
	BEGIN
		RETURN
	END

Insert Into [ffgsql01].[FFG-Production].[dbo].[FFG LIVE$Producer Payment Header]
([Primary Key], [Time Stamp], TransID, TransType, Company, Supplier, Accepted, Payee, Agent, Date,  [Order], Killed, LoadID, Sent, [Date Imported], [Time Imported], Processed, [Errors Exist], [Error Text], 
[Checked For Errors], [Purchase Document No_], Status, [Vendor No_], [Flat Rate], [Checked By], [Date Checked], [Time Checked], Haulier, [Posting Date], [VAT Bus Posting Group], [Copied From Doc_ No_], [County Of Origin], 
[Transport Method], Border, [Gen_ Bus_ Posting Group], [Vendor Posting Group], Haulage, Freight, [Haulage Amount], [Freight Amount], [Exclude from Cube], [Site Dimension], [Vendor Posting Group FCY], 
[VAT Bus Posting Group FCY], [Gen_ Bus_ Posting Group FCY])

SELECT  Top 1      @PrimaryKey As 'PK', [Time Stamp], TransID, TransType, Company, Supplier, 0, Payee, Agent, Date, @Order As 'Order', 0, LoadID, Sent, [Date Imported], [Time Imported], Processed, [Errors Exist], [Error Text], 
                         [Checked For Errors], [Purchase Document No_], 0, [Vendor No_], [Flat Rate], [Checked By], [Date Checked], [Time Checked], Haulier, [Posting Date], [VAT Bus Posting Group], [Copied From Doc_ No_], [County Of Origin], 
                         [Transport Method], Border, [Gen_ Bus_ Posting Group], [Vendor Posting Group], Haulage, Freight, [Haulage Amount], [Freight Amount], [Exclude from Cube], [Site Dimension], [Vendor Posting Group FCY], 
                         [VAT Bus Posting Group FCY], [Gen_ Bus_ Posting Group FCY]
FROM            [ffgsql01].[FFG-Production].[dbo].[FFG LIVE$Producer Payment Header]
Where [Order]=@ExistingOrder
order by [Primary Key] desc

Insert Into [FFGSQL03].[FFGDATA].[DBO].[13748-CreateOrder]
(OriginalOrder, NewOrder, Supplier, KillDate, [User], [EntryTime])
Select
@ExistingOrder, @Order, @Supplier, @KillDate, @User, GetDate()
GO
