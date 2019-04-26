SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe Maguire>
-- Create date: <Create Date,,2019-03-11>
-- Description:	<Description,get weights for each line for that production day,>
-- =============================================
--exec [dbo].[0103_Get_DailyWgt] 33
CREATE PROCEDURE [dbo].[0103_Get_DailyWgt]
    -- Add the parameters for the stored procedure here
    @plotID INT
AS
BEGIN

DECLARE @t TABLE (
		DailyWgt DECIMAL(10,2) NOT NULL,
		Plot INT NOT NULL,
		Line NVARCHAR(25) NOT NULL
		
)


    SELECT SUM(p.[weight]) AS DailyWgt
         , pl.plot
         , pl.[name]
    INTO #retail
    FROM FI_Innova.dbo.proc_packs          p
        LEFT JOIN FI_Innova.dbo.proc_plots pl
            ON p.plot = pl.plot
    WHERE CAST(p.prday AS DATE) = CAST(GETDATE() AS DATE)
          AND pl.description2 IN ( 'RETAIL', 'BULK' )
    GROUP BY pl.plot
           , pl.[name]
    ORDER BY pl.plot DESC;

    SELECT SUM(p.[weight]) AS DailyWgt
         , po.[shname]
         , CASE
               WHEN SUBSTRING(po.shname, 1, 1) = 2 THEN
                   34
               WHEN SUBSTRING(po.shname, 1, 1) = 3 THEN
                   34
               WHEN SUBSTRING(po.shname, 1, 1) = 5 THEN
                   37
               ELSE
                   0000
           END             AS plotID
    INTO #Bulk
    FROM FI_Innova.dbo.proc_packs         p
        INNER JOIN FI_Innova.dbo.proc_pos po
            ON po.po = p.po
    WHERE CAST(p.prday AS DATE) = CAST(GETDATE() AS DATE)
          AND p.plot IS NULL
          AND p.rtype = 1
    GROUP BY po.[shname]
    ORDER BY po.[shname];


INSERT INTO @t
(
    DailyWgt
  , Plot
  , Line
)

    SELECT DailyWgt
         , plot
         , name
    FROM #retail

	UNION 

    SELECT CAST(SUM(DailyWgt) AS DECIMAL(10, 2)) AS TotalWgt
         , plotID,pl.[name] 
    FROM #Bulk
	INNER JOIN FI_Innova.dbo.proc_plots pl ON #Bulk.plotID = pl.plot
    GROUP BY plotID,pl.[name]
	;

    DROP TABLE #retail
             , #Bulk
			 
			 --SELECT * from @t
			 
			 UPDATE l		 
			 SET l.TotalWgt = t.DailyWgt
			 FROM FFGData.dbo.tbl_FoyleIngredients_Labour l
			 LEFT JOIN @t t ON l.ProductionLineID = t.Plot
			 WHERE l.ProductionDate = CAST(GETDATE()AS DATE) AND l.ProductionLineID = @plotID
			 
			 ;
END;
GO
