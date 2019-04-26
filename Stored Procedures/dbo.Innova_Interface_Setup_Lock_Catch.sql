SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <03/01/18>
-- Description:	<To catch and record locks on the Innova Interface Table from Navision>
-- =============================================
CREATE PROCEDURE  [dbo].[Innova_Interface_Setup_Lock_Catch]

--exec  [dbo].[Innova_Interface_Setup_Lock_Catch]

AS
BEGIN

	INSERT INTO [dbo].[tblInnovaInterfaceSetup]
Select [Order Export Locked By], [Order Export Locked DateTime]
FROM [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Innova Interface Setup]
where  dateadd(minute,+2,[Order Export Locked DateTime]) < GETDATE()


END
GO
