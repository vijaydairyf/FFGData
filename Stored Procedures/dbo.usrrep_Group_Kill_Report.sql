SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,joe maguire>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec [dbo].[usrrep_Group_Kill_Report] '2019-03-19','2019-03-19','fc', 0,9999
CREATE PROCEDURE [dbo].[usrrep_Group_Kill_Report]
	-- Add the parameters for the stored procedure here
	@From DATE,
	@To DATE,
	@Site NVARCHAR(3),
	@FromKillNo INT,
	@ToKillNo INT


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT		r.ID,
				   r.SiteIdentifier,
				   r.AphisTblID,
				   r.Sex,
				   r.IndividualID,
				   CAST(r.KillNo AS INT)AS KillNo,
				   r.MoveDate,
				   r.DOB,
				   r.KillDate,
				   r.Regtime,
				   r.FQAS,
				   r.numMoves,
				   r.HerdNo,
				   r.KeeperName,
				   r.DaysOnLastFarm,
				   r.TWA,
				   r.AgeZone,
				   r.OriginalEartagNo,
				   r.EartagNo,
				   r.AgeInMonths,
				   r.Breed,
				   r.brcountry,
				   r.ricountry,
				   r.ArchivedRecord,
				   v.Conform,
				   v.FatClass,
				   v.Grade,
				   v.GradeMethod,
				   v.LocationCode,
				   v.Side1Wgt,
				   v.FQ1Wgt,
				   v.HQ2Wgt,
				   v.Side2Wgt,
				   v.FQ3Wgt,
				   v.HQ4Wgt,
				   v.HotWeight,
				   v.ColdWeight,
				   v.IdentigenNo,
				   v.RegTime

		FROM dbo.grp_Animal_Records r
		LEFT JOIN dbo.grp_AnimalRecordValues v ON v.EartagNo = r.EartagNo AND v.SiteIdentifier = r.SiteIdentifier
		WHERE r.SiteIdentifier = @Site AND CAST(r.KillDate AS DATE) BETWEEN @From AND @To AND r.SiteIdentifier = @Site
				AND CAST(r.KillNo AS INT) BETWEEN @FromKillNo AND @ToKillNo 
				
				--if data is incorrect put this code back in
				--AND (r.SiteIdentifier = @Site AND v.RegTime IS not NULL) 
		ORDER BY KillNo,r.KillDate ASC




END
GO
