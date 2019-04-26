SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <12/09/17>
-- Description:	<Get availible Orders per site per shipment date per transport method>
-- =============================================

--exec [dbo].[SP_GetOrdersForGroupOrderPicklist] '08/08/2018', '08/08/2018','FGL','SAWYERS',''

CREATE PROCEDURE [dbo].[SP_GetOrdersForGroupOrderPicklist]
	-- Add the parameters for the stored procedure here
	@fromshipdate date,
	@toshipdate date,
	@Site nvarchar(5),
	@Shipmethod nvarchar(max)
	,@extcoldstore nvarchar(max)NULL -- added by kh 08/08/18
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	   
	Select distinct (sh.[No_] + ' ' + sh.[Bill-to Name]) as No_ 
	FROM [ffgsql01].[FFG-Production].[dbo].[FFG LIVE$Sales Header] sh 
		--	[ffgsqltest].[Phase2].[dbo].[Phase2$Sales Header] sh
				--[ffgsql01].[LOADTEST].[dbo].[LOADTEST$Sales Header] sh -- added by kh 27/03/18 for test purpose

	where	[Shortcut Dimension 1 Code] = @Site 
			and sh.[Shipment Method Code] = @Shipmethod
			and cast(sh.[Shipment Date] as date) BETWEEN @fromshipdate and @toshipdate
			and sh.[Innova Status] <> 4
			and ISNULL(sh.[Coldstore Reference],'') = ISNULL(@extcoldstore,'')
		

END


GO
