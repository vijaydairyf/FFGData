SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe m>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [usrrep_KL_KillMinistry_RPT] '2019-03-21','2019-03-21','FO'
CREATE PROCEDURE [dbo].[usrrep_KL_KillMinistry_RPT]
    -- Add the parameters for the stored procedure here
    @From DATE
  , @To DATE
  , @Site NVARCHAR(3)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT r.Sex
         , CAST(r.KillNo AS INT) AS KillNo
         , r.Regtime AS SLTime
         , r.TWA
         , r.AgeZone
         , r.AgeInMonths
         , v.Grade
         , v.LocationCode
         , v.Side1Wgt
         , v.Side2Wgt
         , v.RegTime AS GradedAt
    FROM dbo.grp_Animal_Records               r
        INNER JOIN dbo.grp_AnimalRecordValues v
            ON r.SiteIdentifier = v.SiteIdentifier
               AND r.IndividualID = v.IndividualID
    WHERE r.SiteIdentifier = @Site
          AND r.KillDate
          BETWEEN @From AND @To
	ORDER BY KillNo ASC;
END;
GO
