SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [00001-P2ListOrderLinesNotDeleted]

CREATE PROCEDURE [dbo].[00001-P2ListOrderLinesNotDeleted]

AS

Declare @FOLrp Int
Declare @FCLrp Int
Declare @FDLrp Int
Declare @FHLrp Int
Declare @FMMLrp Int
Declare @FGLrp Int
Declare @FILrp Int

SET @FOLrp = (Select Top 1 NumberIndicator From [FFGSQL03].[FFGData].dbo.tblLRP Where TableName='StockJob' And [Site]='FO')
SET @FCLrp = (Select Top 1 NumberIndicator From [FFGSQL03].[FFGData].dbo.tblLRP Where TableName='StockJob' And [Site]='FC')
SET @FDLrp = (Select Top 1 NumberIndicator From [FFGSQL03].[FFGData].dbo.tblLRP Where TableName='StockJob' And [Site]='FD')
SET @FHLrp = (Select Top 1 NumberIndicator From [FFGSQL03].[FFGData].dbo.tblLRP Where TableName='StockJob' And [Site]='FH')
SET @FMMLrp = (Select Top 1 NumberIndicator From [FFGSQL03].[FFGData].dbo.tblLRP Where TableName='StockJob' And [Site]='FMM')
SET @FGLrp = (Select Top 1 NumberIndicator From [FFGSQL03].[FFGData].dbo.tblLRP Where TableName='StockJob' And [Site]='FGL')
SET @FILrp = (Select Top 1 NumberIndicator From [FFGSQL03].[FFGData].dbo.tblLRP Where TableName='StockJob' And [Site]='FI')

Select 
[timestamp], [Primary Key], [Posting Date],	[Transaction Type],	[Order No_], [Location Code],
[Customer No_], [Customer Name], [Item No_], [Line No_], [Unit Of Measure Code], [Qty_ Ordered],
[Weight Qty_ Ordered], [No_ Of Pallets], [Delivery Date], [Delivery Time], [No_ Of Times Already Exported],[Shipment Mark],
[Innova Lot No_],[Lot No_],[Kill Date],[Pack Date],[Use By Date],[DNOB],[Quantity],[Weight],[Innova Inventory],[Innova Inventory Location],[Message Type],[Pallet No_],0 as [RetryCount], 
Case When Substring([Item No_],1,4)='1014' Then '6' Else '1' End AS UnitTypeXfer,

CASE 
WHEN [Constraint]='0' THEN
	Cast([Constraint] As nvarchar(1))+
	CAST(ISNULL(YEAR([Kill Date])*1000+DATEPART(y,[Kill Date]),'9999999') AS NVARCHAR(20))+
	CAST(ISNULL(YEAR([Pack Date])*1000+DATEPART(y,[Pack Date]),'9999999') AS NVARCHAR(20))+
	CAST(ISNULL(YEAR([Use By Date])*1000+DATEPART(y,[Use By Date]),'9999999') AS NVARCHAR(20))+
	CAST(ISNULL(YEAR([DNOB])*1000+DATEPART(y,[DNOB]),'9999999') AS NVARCHAR(20)) 
	+IsNull([Item No_],'123456789')
	+IsNull([Innova Lot No_],'123456789012')
WHEN [Constraint]='1' THEN
	Cast([Constraint] As nvarchar(1))+
	CAST(ISNULL(YEAR([Kill Date])*1000+DATEPART(y,[Kill Date]),'9999999') AS NVARCHAR(20))+
	CAST(ISNULL(YEAR([Pack Date])*1000+DATEPART(y,[Pack Date]),'9999999') AS NVARCHAR(20))+
	CAST(ISNULL(YEAR([Use By Date])*1000+DATEPART(y,[Use By Date]),'9999999') AS NVARCHAR(20))+
	CAST(ISNULL(YEAR([DNOB])*1000+DATEPART(y,[DNOB]),'9999999') AS NVARCHAR(20)) 
	+IsNull([Item No_],'123456789')
WHEN [Constraint]='2' THEN
	Cast([Constraint] As nvarchar(1))+
	IsNull([Item No_],'123456789')
	+IsNull([Innova Lot No_],'123456789012')
WHEN [Constraint]='3' THEN
	Cast([Constraint] As nvarchar(1))+
	IsNull([Item No_],'123456789')
END AS MasterID,

[Weight Qty_ Ordered]*(1+([Max Weight]/100)) As WgtTol

From	[FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Order - Export] WITH (NOLOCK)
Where
([Location Code]='FO' And [Primary Key] <= @FOLrp) OR
([Location Code]='FC' And [Primary Key] <= @FCLrp) OR
([Location Code]='FD' And [Primary Key] <= @FDLrp) OR
([Location Code]='FH' And [Primary Key] <= @FHLrp) OR
([Location Code]='FMM' And [Primary Key] <= @FMMLrp) OR
([Location Code]='FG' And [Primary Key] <= @FGLrp) OR
([Location Code]='FI' And [Primary Key] <= @FILrp)
GO
