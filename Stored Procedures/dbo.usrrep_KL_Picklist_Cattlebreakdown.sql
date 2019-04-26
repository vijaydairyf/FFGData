SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,joe>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [dbo].[usrrep_KL_Picklist_Cattlebreakdown] 'FC','2019-01-29','2019-01-29'
CREATE PROCEDURE [dbo].[usrrep_KL_Picklist_Cattlebreakdown]
 @site nvarchar(3),
 @fromDate date,
 @toDate date
AS
BEGIN

DECLARE @OTMCount DECIMAL(10,2)
DECLARE @UTMCount DECIMAL(10,2)
DECLARE @OTMPerc DECIMAL(10,2)
DECLARE @UTMPerc DECIMAL(10,2)
DECLARE @Count DECIMAL(10,2)

SELECT r.SiteIdentifier
     , r.Sex
     , r.KillNo
     , r.MoveDate
     , r.DOB
     , r.KillDate
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
     , r.HideColour
     , r.ControlRisk
     , r.RecordStatus
     , v.Conform
     , v.FatClass
     , v.Grade
     , v.GradeMethod

     , CASE WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%A1%' OR SUBSTRING(v.LocationCode,2,3) LIKE '%A2%' THEN 'A1_TESCO_UTM'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%B1%' OR SUBSTRING(v.LocationCode,2,3) LIKE '%B2%' THEN 'B2_TESCO_COW'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%B3%' THEN 'B3_TESCOSPEC_COW_O120M'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%C1%' THEN 'C1_UK_UTM N/FQA'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%C2%' THEN 'C2_UK_OTM N/FQA'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%CQ1%' THEN 'CQ1_UK_UTM FQA'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%CQ2%' THEN 'CQ2_UK_OTM FQA'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%D1%' OR SUBSTRING(v.LocationCode,2,3) LIKE '%D2%' THEN 'D_UK_COWS N/FQA'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%DQ1%' OR SUBSTRING(v.LocationCode,2,3) LIKE '%DQ2%' THEN 'DQ_UK_COWS FQA'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%E1%' OR SUBSTRING(v.LocationCode,2,3) LIKE '%N1%' THEN 'E1_IRISH UTM FQA'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%E2%' OR SUBSTRING(v.LocationCode,2,3) LIKE '%N2%' THEN 'E2_IRISH OTM FQA'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%F1%' OR SUBSTRING(v.LocationCode,2,3) LIKE '%F2%' THEN 'F_IRISH COW FQA (UTM & OTM)'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%G1%' THEN 'G1_IRISH CLEAN UTM N/FQA'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%G2%' THEN 'G2_IRISH CLEAN OTM N/FQA'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%H1%' OR SUBSTRING(v.LocationCode,2,3) LIKE '%H2%' THEN 'H_IRISH COW N/FQA'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%I1%' OR SUBSTRING(v.LocationCode,2,3) LIKE '%O1%' THEN 'I1_NOMAD FQA UTM'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%I2%' OR SUBSTRING(v.LocationCode,2,3) LIKE '%O2%' THEN 'I2_NOMAD FQA OTM'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%J1%' OR SUBSTRING(v.LocationCode,2,3) LIKE '%J2%' THEN 'J_NOMAD FQA COW'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%K1%' THEN 'K1_NOMAD CLEAN UTM N/FQA'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%K2%' THEN 'K2_NOMAD CLEAN OTM N/FQA'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%L1%' OR SUBSTRING(v.LocationCode,2,3) LIKE '%L2%' THEN 'L_NOMAD COW N/FQA'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%M1%' OR SUBSTRING(v.LocationCode,2,3) LIKE '%M2%' THEN 'M_OVERAGE BULL UK(16-30M)'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%P1%' THEN 'P1_NOMAD UTM'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%P2%' THEN 'P2_NOMAD UTM'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%Z1%' THEN 'Z1_NOT_BORN_UK_IE UTM'
			WHEN SUBSTRING(v.LocationCode,2,3) LIKE '%Z2%' THEN 'Z2_NOT_BORN_UK_IE OTM'
			ELSE 'X_OTHER'
			END AS RowTitle
     , v.Side1Wgt
     , v.Side2Wgt
     , v.HotWeight
     , v.ColdWeight
     , v.IdentigenNo
     , v.RegTime

INTO #tmp

FROM dbo.grp_Animal_Records               r
    INNER JOIN dbo.grp_AnimalRecordValues v
        ON v.EartagNo = r.EartagNo
           AND v.SiteIdentifier = r.SiteIdentifier
WHERE r.SiteIdentifier = @site
      AND r.KillDate BETWEEN @fromDate AND @toDate
      AND v.RegTime IS NOT NULL
ORDER BY r.KillNo ASC



SET @OTMCount = (SELECT COUNT(agezone) FROM #tmp WHERE AgeZone = 'OTM')
SET @UTMCount = (SELECT COUNT(agezone) FROM #tmp WHERE AgeZone = 'UTM')
SET @Count = @OTMCount + @UTMCount


SELECT rowtitle,AgeZone,COUNT(eartagno)AS CountE,CASE WHEN AgeZone = 'otm' THEN @OTMCount ELSE @UTMCount END AS AgeZoneCount
INTO #tmpFinal
 FROM #tmp GROUP BY RowTitle,AgeZone

 SELECT RowTitle
      , AgeZone
      , CountE
      , AgeZoneCount
	  , CASE WHEN AgeZone = 'OTM' THEN CountE /(AgeZoneCount / 100)
			 WHEN AgeZone = 'UTM' THEN CountE /(AgeZoneCount / 100) ELSE 0.00 
			 END AS Perc
		, (countE/(@count/100))AS PercByTotal
	   FROM #tmpFinal

 --SELECT RowTitle
 --     , AgeZone
 --     , CountE

	--  ,CASE WHEN AgeZone = 'OTM' THEN CountE /(@OTMCount / 100) ELSE 0.00 END AS percPerGroupOTM
	  
	--  ,CASE WHEN AgeZone = 'UTM' THEN CountE /(@UTMCount / 100) ELSE 0.00 END AS percPerGroupUTM
	--  , @OTMCount AS OTMCount
	--  , @UTMCount AS UTMCount
	
 --FROM #tmpFinal
 --ORDER BY AgeZone ASC
 



DROP TABLE #tmp,#tmpFinal




END
GO
