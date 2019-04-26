SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- EXEC [dbo].[usrrep_KL_Group_IdentigenPicklist] 'FC','2019-03-29','2019-03-29'
CREATE PROCEDURE [dbo].[usrrep_KL_Group_IdentigenPicklist]
	-- Add the parameters for the stored procedure here
		@Site NVARCHAR(3),
		@From DATE,
		@To DATE
AS
BEGIN

	SELECT r.KillNo,r.EartagNo,r.OriginalEartagNo,v.LocationCode,v.IdentigenNo
    FROM [FFGData].[dbo].[grp_Animal_Records] r
    INNER JOIN dbo.grp_AnimalRecordValues v ON v.EartagNo = r.EartagNo AND v.SiteIdentifier = r.SiteIdentifier
    WHERE r.SiteIdentifier = @Site  AND r.KillDate BETWEEN @From AND @To
	ORDER BY r.KillNo ASC
	
END
GO
