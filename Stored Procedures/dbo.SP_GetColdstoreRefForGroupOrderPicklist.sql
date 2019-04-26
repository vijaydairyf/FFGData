SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <12/09/17>
-- Description:	<Get coldstore reference for availible orders>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetColdstoreRefForGroupOrderPicklist]
	
--exec [dbo].[SP_GetColdstoreRefForGroupOrderPicklist] '08/08/2018', '08/08/2018','FGL'

	@fromshipdate date,
	@toshipdate date,
	@Site nvarchar(5),
	@Shipmethod nvarchar(max)

AS
BEGIN
	   
	Select distinct [Coldstore Reference]
	FROM [ffgsql01].[FFG-Production].[dbo].[FFG LIVE$Sales Header] sh 
		--	[ffgsqltest].[Phase2].[dbo].[Phase2$Sales Header] sh
				--[ffgsql01].[LOADTEST].[dbo].[LOADTEST$Sales Header] sh -- added by kh 27/03/18 for test purpose

	where	[Shortcut Dimension 1 Code] = @Site and 
			cast(sh.[Shipment Date] as date) BETWEEN @fromshipdate and @toshipdate
			and sh.[Shipment Method Code] = @Shipmethod
			
			
		
END
GO
