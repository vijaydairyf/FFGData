SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,joem>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [dbo].[usrrep_KL_Group_GradeType_Daily] 'FO','2019-03-01'
CREATE PROCEDURE [dbo].[usrrep_KL_Group_GradeType_Daily]
    @Site NVARCHAR(3)

AS
BEGIN

	DECLARE @ManualCount INT
	DECLARE @AutoCount INT 
	DECLARE @KillDate DATE = (CAST(GETDATE() AS DATE))

    SELECT r.KillNo,v.RegTime AS Graded, v.GradeMethod, v.Grade,r.Sex,v.Side1Wgt,v.Side2Wgt, v.Conform,v.FatClass
	INTO #tmp
    FROM [FFGData].[dbo].[grp_Animal_Records] r
        INNER JOIN dbo.grp_AnimalRecordValues v
            ON v.EartagNo = r.EartagNo
               AND v.SiteIdentifier = r.SiteIdentifier
    WHERE r.SiteIdentifier = @Site
          AND r.KillDate = @KillDate
		  
	--SELECT COUNT(KillNo) FROM #tmp WHERE GradeMethod = 'Manual'
		--SET @AutoCount = (SELECT COUNT(KillNo) FROM #tmp WHERE GradeMethod = 'Automatic')  

		SELECT CAST(KillNo AS INT) AS KillNo
             , Graded
             , GradeMethod
             , Grade
             , Sex
             , Side1Wgt
             , Side2Wgt
			 , Conform
			 , FatClass
			 , @KillDate AS KillDate
			 --, @AutoCount AS AutoCount
			 --, @ManualCount AS ManualCount
		FROM #tmp
		ORDER BY KillNo ASC
        

		DROP TABLE #tmp
		  ;


END;
GO
