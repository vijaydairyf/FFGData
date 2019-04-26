SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 24th October 2018
-- Description:	Open Order on relevant Innova 
-- =============================================

--exec [000006-OSOpenOrder] 'ffgso343985', 'FO'

CREATE PROCEDURE [dbo].[000006-OSOpenOrder]

@FFGSO NVarChar(25),
@Site NVarChar(15)

AS

--1=Closed, 2=Cancelled, 3=OnHold, 4=Open, 5=Complete, 6=Complete&Closed, 7=Dispatched.

	IF @Site='FD'
		BEGIN
			Update po
			Set accepttype=3 --1 = ByList, 3=All
			FROM   [donsql01].[Innova].[dbo].[vw_OrderswithNoXML] AS po
			WHERE po.[name] = @FFGSO
		END

	IF @Site='FO'
		BEGIN
			Update po
			Set accepttype=3 --1 = ByList, 3=All
			FROM   [omasql01].[Innova].[dbo].[vw_OrderswithNoXML] AS po
			WHERE po.[name] = @FFGSO
		END

	IF @Site='FH'
		BEGIN
			Update po
			Set accepttype=3 --1 = ByList, 3=All
			From [cktsql01].[Innova].[dbo].[vw_OrderswithNoXML] AS po
			WHERE po.[name] = @FFGSO
		END

	IF @Site='FC'
		BEGIN
			Update po
			Set accepttype=3 --1 = ByList, 3=All
			FROM   [camsql01].[Innova].[dbo].[vw_OrderswithNoXML] AS po
			WHERE po.[name] = @FFGSO
		END

	IF @Site='FGL'
		BEGIN
			Update po
			Set accepttype=3 --1 = ByList, 3=All
			FROM   [glosql01].[Innova].[dbo].[vw_OrderswithNoXML] AS po
			WHERE po.[name] = @FFGSO
		END

	IF @Site='FI'
		BEGIN
			Update po
			Set accepttype=3 --1 = ByList, 3=All
			FROM   [ingsql01].[FI_Innova].[dbo].[vw_OrderswithNoXML] AS po
			WHERE po.[name] = @FFGSO
		END

	IF @Site='FMM'
		BEGIN
			Update po
			Set accepttype=3 --1 = ByList, 3=All
			FROM [melsql01].[Innova].[dbo].[vw_OrderswithNoXML] AS po
			WHERE po.[name] = @FFGSO
		END

	Update [dbo].[000006-OSBase] Set UpdatedTime=GetDate() Where FFGSO=@FFGSO
GO
