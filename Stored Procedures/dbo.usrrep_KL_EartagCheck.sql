SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe Maguire>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec  [dbo].[usrrep_KL_EartagCheck] 'FO'
CREATE PROCEDURE [dbo].[usrrep_KL_EartagCheck] 
@Site NVARCHAR(3)
AS
BEGIN

    DECLARE @eartagCheck TABLE
    (
        EartagInnova NVARCHAR(25) NOT NULL
      , KillNo INT NOT NULL
      , DeptAnimalTag NVARCHAR(25) NOT NULL
      , KillNoDard INT NOT NULL
      , Checked CHAR(1) NOT NULL
    );

    --==================================================================================================================================
    SELECT i.EartagNo
         , i.KillNo
    INTO #innova
    FROM dbo.grp_Animal_Records AS i
    WHERE CAST(i.KillDate AS DATE) = CAST(GETDATE() AS DATE)
          AND i.SiteIdentifier = @Site;
    --==================================================================================================================================


    IF @Site = 'FO'
    BEGIN


        SELECT CASE
                   WHEN a.AnimalTagNumber LIKE '%-%' THEN
                       REPLACE(REPLACE(a.AnimalTagNumber, '-', ''), ' ', '')
                   WHEN a.AnimalTagNumber LIKE '% %' THEN
                       REPLACE(a.AnimalTagNumber, ' ', '')
                   ELSE
                       a.AnimalTagNumber
               END AS AnimalTagNo
             , a.KillNumber
        INTO #_anl
        FROM FFGSQL1.Multiflex_Omagh.dbo.Beef_AphisData_ANL a
        WHERE CAST(a.KillDate AS DATE) = CAST(GETDATE() AS DATE)
              AND a.Archived IS NULL;

        --==================================================================================================================================
        INSERT INTO @eartagCheck
        (
            EartagInnova
          , KillNo
          , DeptAnimalTag
          , KillNoDard
          , Checked
        )
        SELECT i.EartagNo
             , i.KillNo
             , a.AnimalTagNo
             , a.KillNumber
             , CASE
                   WHEN i.EartagNo IS NULL THEN
                       'N'
                   WHEN a.AnimalTagNo IS NULL THEN
                       'N'
                   ELSE
                       'Y'
               END AS Checked
        FROM #innova        i
            LEFT JOIN #_anl a
                ON i.EartagNo COLLATE DATABASE_DEFAULT = a.AnimalTagNo
                   AND i.KillNo = a.KillNumber;


        --==================================================================================================================================

        DROP TABLE #innova
                 , #_anl;
        SELECT *
        FROM @eartagCheck;
    END;

--==================================================================================================================================

END;
GO
