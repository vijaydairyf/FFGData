SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,joe maguire>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--	
CREATE PROCEDURE [dbo].[00067-GetAnimals_Site]
	@Site NVARCHAR(3),
	@DateFrom NVARCHAR(12),
	@DateTo NVARCHAR(12)
AS
BEGIN
		SELECT r.KillDate,CAST(r.KillNo AS INT) AS [Kill No], r.OriginalEartagNo AS EartagNo, ISNULL(r.HighPH,0) AS HighPH
		FROM [FFGData].[dbo].[grp_Animal_Records] r
	    WHERE r.SiteIdentifier = @Site AND CONVERT(NVARCHAR(12),r.KillDate,102) BETWEEN CONVERT(NVARCHAR(12),@DateFrom,102) AND CONVERT(NVARCHAR(12),@DateFrom,102)
		AND (r.HighPH IS NULL OR r.HighPH = 0)
		ORDER BY r.KillDate,r.KillNo ASC  
END
GO
