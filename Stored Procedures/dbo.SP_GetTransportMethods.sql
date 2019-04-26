SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <12/09/17>
-- Description:	<Get availible transport options per site per shipment date>
-- =============================================

--exec [dbo].[SP_GetTransportMethods] '08/08/2018', '08/08/2018', 'FGL'

CREATE PROCEDURE [dbo].[SP_GetTransportMethods]
	-- Add the parameters for the stored procedure here
	@fromshipdate date,
	@toshipdate date,
	@Site nvarchar(5)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Select distinct sh.[Shipment Method Code]
	FROM [ffgsql01].[FFG-Production].[dbo].[FFG LIVE$Sales Header] sh --removed by KH 30/01/18 for to test FT site & Phase 2 test
		--	[ffgsqltest].[Phase2].[dbo].[Phase2$Sales Header] sh removed by KH 27/03/18
		--[ffgsql01].[LOADTEST].[dbo].[LOADTEST$Sales Header] sh
	where	[Shortcut Dimension 1 Code] = @Site and 

			cast(sh.[Shipment Date] as date) BETWEEN @fromshipdate and @toshipdate

	
END
GO
