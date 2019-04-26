SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [000006-OSGetOrderDetails] 'FFGSO352912'

CREATE PROCEDURE [dbo].[000006-OSGetOrderDetails]

@FFGSO NVarChar(Max)

AS

Declare @Override NVarChar(10)

Set @Override = ''

	IF Right(@FFGSO,3)='QWE'
		Begin
			Set @Override = Right(@FFGSO,3)
		End

Set @FFGSO = Substring(@FFGSO,1,11)

--->
	Declare @Site NVarChar(30)
	Declare @InnovaOrder NVarChar(30), @accepttype int, @orderstatus int
	Declare @Time Time

	Set @Time=GetDate()

	Select h.[No_] AS 'FFGSO', h.[Location Code]  As FFGSite, h.[innova status], --1=Sent to Innova, 9=Unallocated
	[Bill-to Name], [posting date], 'FFGS0999999' AS 'InnovaFFGSO', 0 As 'accepttype', 0 as 'orderstatus', @Time As 'RequestTime',
	'abcdef123456789' As 'NavInnovaStat',
	'abcdef123456789' As 'InnovaStat',
	'abcdef123456789' As 'TimeStat',
	'abcdef123456789' As 'AcceptsStat',
	'abcdef123456789' As 'ProcessStat'
	Into #nav 
	From [ffgsql01].[FFG-Production].dbo.[FFG LIVE$Sales Header] h Where h.[No_]=@FFGSO

	Select @Site=h.[Location Code]
	From [ffgsql01].[FFG-Production].dbo.[FFG LIVE$Sales Header] h Where h.[No_]=@FFGSO

--->

	IF @Site='FD'
		BEGIN
			SELECT	@InnovaOrder=po.[name], 
			@accepttype=accepttype, --1 = ByList, 3=All
			@orderstatus=orderstatus --1=Closed, 2=Cancelled, 3=OnHold, 4=Open, 5=Complete, 6=Complete&Closed, 7=Dispatched.
			FROM   [FD_Innova].dbo.proc_orders AS po WITH (nolock)
			WHERE po.[name] = @FFGSO
		END

	IF @Site='FO'
		BEGIN
			SELECT	@InnovaOrder=po.[name], 
			@accepttype=accepttype, --1 = ByList, 3=All
			@orderstatus=orderstatus --1=Closed, 2=Cancelled, 3=OnHold, 4=Open, 5=Complete, 6=Complete&Closed, 7=Dispatched.
			FROM   [FO_Innova].dbo.proc_orders AS po WITH (nolock)
			WHERE po.[name] = @FFGSO
		END

	IF @Site='FH'
		BEGIN
			SELECT	@InnovaOrder=po.[name], 
			@accepttype=accepttype, --1 = ByList, 3=All
			@orderstatus=orderstatus --1=Closed, 2=Cancelled, 3=OnHold, 4=Open, 5=Complete, 6=Complete&Closed, 7=Dispatched.
			FROM   [FH_Innova].dbo.proc_orders AS po WITH (nolock)
			WHERE po.[name] = @FFGSO
		END

	IF @Site='FC'
		BEGIN
			SELECT	@InnovaOrder=po.[name], 
			@accepttype=accepttype, --1 = ByList, 3=All
			@orderstatus=orderstatus --1=Closed, 2=Cancelled, 3=OnHold, 4=Open, 5=Complete, 6=Complete&Closed, 7=Dispatched.
			FROM   [FM_Innova].dbo.proc_orders AS po WITH (nolock)
			WHERE po.[name] = @FFGSO
		END

	IF @Site='FGL'
		BEGIN
			SELECT	@InnovaOrder=po.[name], 
			@accepttype=accepttype, --1 = ByList, 3=All
			@orderstatus=orderstatus --1=Closed, 2=Cancelled, 3=OnHold, 4=Open, 5=Complete, 6=Complete&Closed, 7=Dispatched.
			FROM   [FG_Innova].dbo.proc_orders AS po WITH (nolock)
			WHERE po.[name] = @FFGSO
			SELECT @InnovaOrder
		END

	IF @Site='FI'
		BEGIN
			SELECT	@InnovaOrder=po.[name], 
			@accepttype=accepttype, --1 = ByList, 3=All
			@orderstatus=orderstatus --1=Closed, 2=Cancelled, 3=OnHold, 4=Open, 5=Complete, 6=Complete&Closed, 7=Dispatched.
			FROM   [FI_Innova].dbo.proc_orders AS po WITH (nolock)
			WHERE po.[name] = @FFGSO
		END

	IF @Site='FMM'
		BEGIN
			SELECT	@InnovaOrder=po.[name], 
			@accepttype=accepttype, --1 = ByList, 3=All
			@orderstatus=orderstatus --1=Closed, 2=Cancelled, 3=OnHold, 4=Open, 5=Complete, 6=Complete&Closed, 7=Dispatched.
			FROM   [FMM_Innova].dbo.proc_orders AS po WITH (nolock)
			WHERE po.[name] = @FFGSO
		END

Update #nav
Set InnovaFFGSO=@InnovaOrder, accepttype=@accepttype, orderstatus=@orderstatus
Where ffgso=@InnovaOrder

Update #nav Set TimeStat=CASE WHEN RequestTime <'16:30:00' THEN 'RED' ELSE 'GREEN' END
Update #nav Set NavInnovaStat=CASE WHEN [innova status] IN('1','9') THEN 'GREEN' ELSE 'RED' END
Update #nav Set InnovaStat=CASE WHEN orderstatus IN('4') THEN 'GREEN' ELSE 'RED' END
Update #nav Set AcceptsStat=CASE WHEN accepttype IN('1') THEN 'GREEN' ELSE 'RED' END
Update #nav Set ProcessStat=CASE WHEN TimeStat='GREEN' AND NavInnovaStat='GREEN' AND InnovaStat='GREEN' AND AcceptsStat='GREEN' THEN 'GREEN' ELSE 'RED' END

Update [000006-OSBase] 
Set FFGSO=FFGSO+' '+Cast(Convert(NVarChar(12),GetDate(),103) As NVarChar(150))
Where FFGSO=@FFGSO

Insert Into  [000006-OSBase]
(FFGSO, FFGSite, InnovaStatus, Customer, PostingDate, accepttype, orderstatus, RequestTime, NavInnovaStat, InnovaStat, TimeStat, AcceptsStat, ProcessStat, 
IPAddress, Username, DateAndTime, SalesAdminContacted, PdaError, OrField)
Select FFGSO, FFGSite, [Innova status] As 'InnovaStatus', [Bill-to Name] As 'Customer', [posting date] As 'PostingDate', 
accepttype, orderstatus, RequestTime, NavInnovaStat, InnovaStat, TimeStat, AcceptsStat, ProcessStat,
'','',GetDate(),'','',@Override
from #nav
	
	IF @Override='QWE'
		BEGIN
			Update [000006-OSBase] SET ProcessStat='GREEN' WHERE FFGSO=@FFGSO
		END

Drop Table #nav

--exec [000006-OSGetOrderDetails] 'FFGSO345659'
GO
