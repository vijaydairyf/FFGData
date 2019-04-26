SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec  [dbo].[usrrep_Group_Kill_By_Supplier] 'FO','2019-02-25','2019-02-25','636607'
CREATE PROCEDURE [dbo].[usrrep_Group_Kill_By_Supplier]
    -- Add the parameters for the stored procedure here
    @Site NVARCHAR(3)
  , @From DATE
  , @To DATE
  , @SupplierNo NVARCHAR(15)
AS
BEGIN

    SELECT r.SiteIdentifier
         , r.Sex
         , r.IndividualID
         , CAST(r.KillNo AS INT) AS KillNo
         , r.MoveDate
         , r.DOB
         , r.KillDate
         , r.Regtime
         , r.FQAS
         , r.HerdNo
         , r.KeeperName
         , r.TWA
         , r.AgeZone
         , r.EartagNo
         , r.AgeInMonths
         , r.Breed
         , r.brcountry
         , r.ricountry
         , r.HideColour
         , r.CertificateNo
         , r.FQA_InspectionDate
		 , r.OriginalEartagNo
         , v.Conform
         , v.FatClass
         , v.Grade
         , v.GradeMethod
         , v.LocationCode
         , v.Side1Wgt
         , v.FQ1Wgt
         , v.HQ2Wgt
         , v.Side2Wgt
         , v.FQ3Wgt
         , v.HQ4Wgt
         , v.HotWeight
         , v.ColdWeight
         , v.IdentigenNo
         , v.RegTime AS Classified
    FROM dbo.grp_Animal_Records              r
        LEFT JOIN dbo.grp_AnimalRecordValues v
            ON r.SiteIdentifier = v.SiteIdentifier
               AND r.EartagNo = v.EartagNo
    WHERE r.SiteIdentifier = @Site
          AND r.KillDate
          BETWEEN @From AND @To
          AND r.HerdNo = @SupplierNo
		  ORDER BY KillNo asc
		  ;

		



END;
GO
