SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,MMcGinn, JM >
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC [dbo].[FFGL-Picklist-GROUP] 'FC','2019-04-01', '2019-04-05', 'Picklist', 'HIGH PH'
CREATE PROCEDURE [dbo].[FFGL-Picklist-GROUP]
	-- Add the parameters for the stored procedure here
	@Site NVARCHAR(3),
	@StartDate DATE,
	@EndDate DATE,
	@Request NVARCHAR(MAX),
	@Picklist NVARCHAR(MAX)
AS
BEGIN
	DECLARE @detail TABLE (
	SiteIdentifier NVARCHAR(50) NOT NULL,
	KillNo NVARCHAR(10)  NULL,
	AnimalTagNo NVARCHAR(25) NULL,
	HerdNumber NVARCHAR(20) NULL,
	Sex VARCHAR(5) NULL,
	Age NVARCHAR(10)  NULL,
	FQAS VARCHAR(5) NULL,
	Grade NVARCHAR(4) NULL,
	CR VARCHAR(20) NULL,
	DaysOLF NVARCHAR(10)  NULL,
	Moves NVARCHAR(10)  NULL,
	Breed VARCHAR(20) NULL,
	ColourHide VARCHAR(20) NULL,
	DOB DATE  NULL,
	O30M NVARCHAR(20)  NULL,
	Locn NVARCHAR(20)  NULL,
	ColdWgt DECIMAL(10,2)  NULL,
	OAYB VARCHAR(20)  NULL,
	HighPH NVARCHAR(1) NULL
	)

--SELECT fs.RegistrationNo AS 'herdnumber'
--     , fs.FarmerStableId
--     , fs.[Name]         AS 'Farmer'
--     , an.AnimalGroupId  AS 'LoadID'
--Into #t1
--FROM [FFGSQL1].[Multiflex_Omagh].dbo.[Beef_AphisData_ANL]       an
--    LEFT JOIN [FFGSQL1].[Multiflex_Omagh].dbo.[mf_AnimalGroup]  ag
--        ON an.AnimalGroupId = ag.AnimalGroupId
--    LEFT JOIN [FFGSQL1].[Multiflex_Omagh].dbo.[mf_FarmerStable] fs
--        ON ag.FarmerStableId = fs.FarmerStableId
--WHERE CONVERT(NVARCHAR(MAX), an.[KillDate], 102)
--      BETWEEN CONVERT(NVARCHAR(MAX), @StartDate, 102) AND CONVERT(NVARCHAR(MAX), @EndDate, 102)
--      AND an.Archived IS NULL
--GROUP BY fs.RegistrationNo
--       , fs.FarmerStableId
--       , fs.[Name]
--       , an.AnimalGroupId
	
SELECT r.ID
     , r.SiteIdentifier
     , r.AphisTblID
     , r.Sex
     , r.IndividualID
     , r.KillNo
     , r.MoveDate
     , r.DOB
     , r.KillDate
     , r.Regtime AS Sequenced
     , r.FQAS
     , r.numMoves
     , r.HerdNo
     , r.KeeperName
     , r.DaysOnLastFarm
     , r.TWA
     , r.AgeZone
     , r.OriginalEartagNo
     , r.EartagNo
     , r.AgeInMonths
     , r.Breed
     , r.brcountry
     , r.ricountry
     , r.ArchivedRecord
     , r.HideColour
     , r.CertificateNo
     , r.FQA_InspectionDate
     , r.ControlRisk
     , r.RecordStatus
     , v.AnlValID
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
	 , r.HighPH
	 --, t.herdnumber
  --  , t.FarmerStableId
  --  , t.Farmer
  --  , t.LoadID
	, CASE WHEN r.AgeInMonths >=16 AND r.Sex = 'A' THEN 'Y' ELSE 'N' END AS 'OAYB'
	, CASE WHEN r.AgeInMonths >=30 AND r.AgeZone = 'OTM' THEN 'Y' ELSE 'N' END AS 'O30M'
	 INTO #Source
FROM [FFGData].[dbo].[grp_Animal_Records] r
    LEFT JOIN dbo.grp_AnimalRecordValues v ON v.EartagNo = r.EartagNo AND v.SiteIdentifier = r.SiteIdentifier
	--LEFT JOIN #t1 t ON r.HerdNo COLLATE DATABASE_DEFAULT = t.herdnumber
WHERE r.SiteIdentifier = @Site
      AND r.KillDate
      BETWEEN @StartDate AND @EndDate

	  IF @Request = 'Picklist'
		BEGIN 
		DECLARE @SQL NVARCHAR(MAX)
		DECLARE @Param NVARCHAR(MAX)
		DECLARE @SiteExists INT

		SET @SiteExists = (SELECT CHARINDEX(@Site,SiteIdentifier) FROM dbo.[FFGL-PicklistSpecs-Group] WHERE Spec = @Picklist)
		--SELECT @SiteExists
		IF @SiteExists > 0 
		BEGIN
		 SET @Param = (SELECT SpecCriteria FROM dbo.[FFGL-PicklistSpecs-Group] WHERE Spec = @Picklist)
		END

		--SELECT FROM #Source WHERE 

		SET @SQL = N'SELECT SiteIdentifier, KillNo AS ''KillNo'',   OriginalEartagNo as ''AnimalTagNumber'', HerdNo as ''HerdNumber'', Sex, AgeInMonths, FQAS, Grade, ControlRisk as ''CR'',
					DaysOnLastFarm as ''Days'', numMoves as ''Moves'', Breed, HideColour as ''Colour'', DOB as ''DateOfBirth'', O30M, LocationCode, ColdWeight , OAYB, HighPH From #Source'

			IF @Param IS NOT NULL
				BEGIN
					SET @SQL = @SQL + @Param + 'ORDER BY KillNo;'
				END

			INSERT INTO @detail
			EXEC sp_executesql @SQL

			SELECT 
				   SiteIdentifier
				 , CAST(KillNo AS INT) AS KillNo
                 , AnimalTagNo
                 , HerdNumber
                 , Sex
                 , Age
                 , FQAS
                 , Grade
                 , CR
                 , DaysOLF
                 , Moves
                 , Breed
                 , ColourHide
                 , DOB
                 , O30M
                 , Locn
                 , ColdWgt
                 , OAYB
				 , HighPH
				  FROM @detail
				
				 ORDER BY 
				 KillNo ASC
			END
                

	--DROP TABLE #t1
	  DROP TABLE #Source





END
GO
