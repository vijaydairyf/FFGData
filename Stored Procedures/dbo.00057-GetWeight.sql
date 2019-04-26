SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe Maguire>
-- Create date: <Create Date,,2019-03-11>
-- Description:	<Description,get weights for each line for that production day,>
-- =============================================
--exec[dbo].[00057-GetWeight] 36
CREATE PROCEDURE [dbo].[00057-GetWeight]
    -- Add the parameters for the stored procedure here
    @plotID INT
AS
BEGIN


--SELECT @PrevWgt

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
	  --  LEFT JOIN dbo.tbl_FoyleIngredients_Diary d ON pl.plot = d.ProductionLineID
    WHERE CAST(p.prday AS DATE) = CAST(GETDATE() AS DATE)
          AND pl.description2 IN ( 'RETAIL', 'BULK' ) AND p.plot = @plotID
    GROUP BY pl.plot
           , pl.[name]
    ORDER BY pl.plot DESC

	--SELECT * FROM #retail

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
		  AND CASE
		                 WHEN SUBSTRING(po.shname, 1, 1) = 2 THEN
		                     34
		                 WHEN SUBSTRING(po.shname, 1, 1) = 3 THEN
		                     34
		                 WHEN SUBSTRING(po.shname, 1, 1) = 5 THEN
		                     37
		                 ELSE
		                     0000
		             END = @plotID
          AND p.rtype = 1
    GROUP BY po.[shname]
    ORDER BY po.[shname]


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

	SELECT * FROM @t

	DECLARE @EntryNo INT = (SELECT MAX(EntryNo) FROM dbo.tbl_FoyleIngredients_Diary WHERE ProductionLineID = @plotID)
	SELECT @EntryNo

	DECLARE @Archived INT = (SELECT TOP 1 ISNULL(Archived,0) FROM dbo.tbl_FoyleIngredients_Diary WHERE ProductionLineID = @plotID)
	SELECT @Archived


	DECLARE @PrevWgt DECIMAL(10,2)

	SELECT MAX(EntryNo) AS Regtime,ProductionLineID,TotalWgt
	INTO #wgt
	FROM dbo.tbl_FoyleIngredients_Diary WHERE ProductionLineID = @plotID AND EntryNo = @EntryNo
	GROUP BY ProductionLineID,TotalWgt
	--SELECT * FROM #wgt

	SET @PrevWgt = (SELECT TotalWgt FROM #wgt)
	--SELECT @PrevWgt

	IF @EntryNo = 1 AND @Archived = 0
	BEGIN
	DECLARE @FirstWeigh DECIMAL(10,2)= 
	(SELECT DailyWgt FROM @t)
	SELECT @FirstWeigh
	   -- 	 UPDATE l		 
			 --SET l.TotalWgt = t.DailyWgt
			 --FROM dbo.tbl_FoyleIngredients_Diary l
			 ----FROM FFGData.dbo.tbl_FoyleIngredients_Labour l
			 --LEFT JOIN @t t ON l.ProductionLineID = t.Plot
			 --WHERE l.ProductionLineID = @plotID AND l.archived IS NULL
	END

	ELSE
		BEGIN
		    DECLARE @CurrentWeight DECIMAL(10,2) = (SELECT DailyWgt FROM @t)
			DECLARE @NewEntryWeight DECIMAL(10,2)
			SET @NewEntryWeight = 
			(SELECT @CurrentWeight-@PrevWgt)

			SELECT @NewEntryWeight
		
			 --UPDATE l		 
			 --SET l.TotalWgt = t.DailyWgt
			 --FROM dbo.tbl_FoyleIngredients_Diary l
			 ----FROM FFGData.dbo.tbl_FoyleIngredients_Labour l
			 --LEFT JOIN @t t ON l.ProductionLineID = t.Plot
			 --WHERE l.ProductionLineID = @plotID
			
		END

	
	
		
		
		
		DROP TABLE #retail
           DROP TABLE #Bulk
				DROP TABLE #wgt
END;
GO
