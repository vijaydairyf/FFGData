SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe Maguire>
-- Create date: <Create Date,,30/01/2019>
-- Description:	<Description,,>
-- =============================================
-- exec [dbo].[usrrep_FO_Kill_Line_Rpt] '2019-01-29','2019-01-29'
CREATE PROCEDURE [dbo].[usrrep_FO_Kill_Line_Rpt]
	-- Add the parameters for the stored procedure here
	@From DATE,
	@To DATE
AS
BEGIN

--to get keeper name for herd no
SELECT a.Beef_AphisData_ANL_Id,
CASE WHEN a.AnimalTagNumber LIKE '%-%' THEN REPLACE(REPLACE(a.AnimalTagNumber,'-',''),' ','')
	 WHEN a.AnimalTagNumber LIKE '% %' THEN REPLACE(a.AnimalTagNumber,' ','')
	 ELSE a.AnimalTagNumber END AS AnimalTagNo,a.KeeperForname + ' ' + a.KeeperSurname AS [Keeper]
INTO #Aphis
FROM [FFGSQL1].[Multiflex_Omagh].[dbo].[Beef_AphisData_ANL] a
WHERE CONVERT(NVARCHAR(12),a.KillDate,102)BETWEEN CONVERT(NVARCHAR(12),@From,102) and  CONVERT(NVARCHAR(12),@To,102)
AND a.Archived IS NULL


SELECT		'FO' as [SiteId],		
			cat.code as Sex,
			i.id as IndividualID,
			i.slcode as KillNo,
			CAST(i.moveindatetopreviousherd as date) as MoveDate,
			CAST(i.birthday as date) as DOB,
			i.slday as KillDate,
			i.regtime as Regtime,
			i.fqas as FQAS,
			i.numberoffarmMove as numMoves,
			i.herdnumber as HerdNo,
			a.Keeper AS Keeper,
			i.daysonlastfarm as DaysOnLastFarm,
			i.twa as TWA, i.agezone as AgeZone,
			i.originaleartag,
			i.idcode as EartagNo,
			i.ageindicator as AgeInMonths,
			b.code AS Breed,
			i.brcountry,
			i.ricountry,
			i.rtype AS indivrtype,
			 c.rtype
			,c.value3 AS [Side 1]
			,c.value3 * 0.4950 AS FQ1 
			,c.value3 * 0.5050 AS HQ2
			,c.value4 AS [Side 2]
			,c.value4 * 0.4950 AS FQ3
			,c.value4 * 0.5050 AS HQ4
			,c.[weight] AS HotWgt
			,c.[weight]*0.98 AS ColdWgt
			,q.code as Conform
			,f.code as Fat
			,CONCAT(q.code,f.code) as Grade
			,case when c.manualdata = 1 then 'Automatic' else 'Manual' end as [GradedMethod]
			,rm.code AS [Location]


			INTO #tmp

FROM					[ffgsql03].[FO_INNOVA].[DBO].[PROC_INDIVIDUALS] i
			INNER JOIN	#Aphis a ON i.idcode COLLATE DATABASE_DEFAULT = a.AnimalTagNo
			INNER JOIN	[ffgsql03].[FO_INNOVA].[DBO].[proc_categories] cat WITH(NOLOCK) on i.category = cat.category
			INNER JOIN	[ffgsql03].[FO_INNOVA].[DBO].[proc_breeds] b ON i.breed = b.breed
			INNER JOIN	[ffgsql03].[FO_INNOVA].[dbo].[bkl_clregs] c ON i.id = c.individual
			INNER JOIN	[ffgsql03].FO_Innova.dbo.proc_qualities q on c.quality = q.quality
			INNER JOIN	[ffgsql03].FO_Innova.dbo.proc_fatclasses f on c.fatclass = f.fatclass
			INNER JOIN	[ffgsql03].FO_Innova.dbo.proc_rmareas rm ON i.rmarea = rm.rmarea

		
WHERE		CONVERT(NVARCHAR(12),i.slday,102)BETWEEN CONVERT(NVARCHAR(12),@From,102) and  CONVERT(NVARCHAR(12),@To,102)
		
			and i.rtype <> 4 AND c.rtype NOT IN (4,6)


			SELECT SiteId,
                   Sex,
                   IndividualID,
                   KillNo,
                   MoveDate,
                   DOB,
                   KillDate,
                   Regtime,
                   FQAS,
                   numMoves,
                   HerdNo,
                   Keeper,
                   DaysOnLastFarm,
                   TWA,
                   AgeZone,
                   originaleartag,
                   EartagNo,
                   AgeInMonths,
                   Breed,
                   brcountry,
                   ricountry,
                   indivrtype,
                   rtype,
                   [Side 1],
                   FQ1,
                   HQ2,
                   [Side 2],
                   FQ3,
                   HQ4,
                   HotWgt,
                   ColdWgt,
                   Conform,
                   Fat,
                   Grade,
                   GradedMethod,
                   [Location]
			FROM #tmp

		


END
GO
