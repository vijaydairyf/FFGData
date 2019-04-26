SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [00000-HACheckOrderStatusVer2] 'FFGSO353334'

--1=Closed, 2=Cancelled, 3=OnHold, 4=Open, 5=Complete, 6=Complete&Closed, 7=Dispatched.

CREATE PROCEDURE [dbo].[00000-HACheckOrderStatusVer2]

@FFGSO NVarChar(Max)

AS

Declare @Override NVarChar(10)

Set @FFGSO = Substring(@FFGSO,1,11)

--->
	Declare @Site NVarChar(30)
	Declare @InnovaOrder NVarChar(30), @accepttype int, @orderstatus int

	Select @Site=h.[Location Code]
	From [ffgsql01].[FFG-Production].dbo.[FFG LIVE$Sales Header] h Where h.[No_]=@FFGSO

--->

	IF @Site='FD'
		BEGIN
			SELECT
			@orderstatus=orderstatus --1=Closed, 2=Cancelled, 3=OnHold, 4=Open, 5=Complete, 6=Complete&Closed, 7=Dispatched.
			FROM   [FD_Innova].dbo.proc_orders AS po WITH (nolock)
			WHERE po.[name] = @FFGSO
		END

	IF @Site='FO'
		BEGIN
			SELECT @orderstatus=orderstatus --1=Closed, 2=Cancelled, 3=OnHold, 4=Open, 5=Complete, 6=Complete&Closed, 7=Dispatched.
			FROM   [FO_Innova].dbo.proc_orders AS po WITH (nolock)
			WHERE po.[name] = @FFGSO
		END

	IF @Site='FH'
		BEGIN
			SELECT	@orderstatus=orderstatus --1=Closed, 2=Cancelled, 3=OnHold, 4=Open, 5=Complete, 6=Complete&Closed, 7=Dispatched.
			FROM   [FH_Innova].dbo.proc_orders AS po WITH (nolock)
			WHERE po.[name] = @FFGSO
		END

	IF @Site='FC'
		BEGIN
			SELECT	@orderstatus=orderstatus --1=Closed, 2=Cancelled, 3=OnHold, 4=Open, 5=Complete, 6=Complete&Closed, 7=Dispatched.
			FROM   [FM_Innova].dbo.proc_orders AS po WITH (nolock)
			WHERE po.[name] = @FFGSO
		END

	IF @Site='FGL'
		BEGIN
			SELECT	@orderstatus=orderstatus --1=Closed, 2=Cancelled, 3=OnHold, 4=Open, 5=Complete, 6=Complete&Closed, 7=Dispatched.
			FROM   [FG_Innova].dbo.proc_orders AS po WITH (nolock)
			WHERE po.[name] = @FFGSO
		END

	IF @Site='FI'
		BEGIN
			SELECT	@orderstatus=orderstatus --1=Closed, 2=Cancelled, 3=OnHold, 4=Open, 5=Complete, 6=Complete&Closed, 7=Dispatched.
			FROM   [FI_Innova].dbo.proc_orders AS po WITH (nolock)
			WHERE po.[name] = @FFGSO
		END

	IF @Site='FMM'
		BEGIN
			SELECT	@orderstatus=orderstatus --1=Closed, 2=Cancelled, 3=OnHold, 4=Open, 5=Complete, 6=Complete&Closed, 7=Dispatched.
			FROM   [FMM_Innova].dbo.proc_orders AS po WITH (nolock)
			WHERE po.[name] = @FFGSO
		END

	RETURN IsNull(@orderstatus,99)


GO
