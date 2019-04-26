SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 15th December 2017
-- Description:	Check if Innova Interface Table is locked 
-- =============================================

--exec [0000-NavCheckInnovaLock]

CREATE PROCEDURE [dbo].[0000-NavCheckInnovaLock]

AS

SELECT Top 1 'Innova Lock' As JobName, [Order Export Locked DateTime] As JobDateTime, [Order Export Locked] As OrderExportLocked
INTO #tmp FROM [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Innova Interface Setup] 

Declare @LastTimeLocked DateTime

;WITH CTELastLock AS ( SELECT TOP 1 * FROM [tblJobLog] ORDER BY ID Desc )
SELECT @LastTimeLocked=JobDateTime From CTELastLock

Insert Into [tblJobLog]
(JobName, JobDateTime, OrderExportedLocked)
Select JobName, JobDateTime, OrderExportLocked From #tmp

SELECT id, JobName, JobDateTime, OrderExportedLocked, @LastTimeLocked As LastTimeLocked, DateDiff(minute,@LastTimeLocked,GetDate()) As TimeDifference 
Into #tmp2 From [tblJobLog]

Declare @id Int, @Locked Int, @Diff Int

SELECT Top 1 @id=id, @Locked=OrderExportedLocked, @Diff=TimeDifference From #tmp2 Order By ID Desc

If @Locked=1
	Begin
		Update [tblJobLog] Set JobName = '[ Locked for ' + Cast(@Diff as NVarChar(Max)) + ' minutes ]' Where id=@id
		--Update [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Innova Interface Setup] Set [Order Export Locked] = 0 Where [Order Export Locked] = 1
	End
If @Locked=0
	Begin
		Update [tblJobLog] Set JobName = 'Not Locked' Where id=@id
	End

Drop Table #tmp, #tmp2
GO
