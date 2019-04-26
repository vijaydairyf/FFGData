SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe Maguire>
-- Create date: <Create Date,,2019-03-11>
-- Description:	<Description,get weights for each line for that production day,>
-- =============================================
-- 36 = line 4
--exec[dbo].[00057-GetWeight_Live] 34
CREATE PROCEDURE [dbo].[00057-GetWeight_Live]
    -- Add the parameters for the stored procedure here
    @plotID INT
AS
BEGIN


DECLARE @t TABLE (
		DailyWgt DECIMAL(10,2) NOT NULL,
		Plot INT NOT NULL,
		Line NVARCHAR(25) NOT NULL	
)


    SELECT TOP 1 SUM(p.[weight]) AS DailyWgt
         , pl.plot
         , pl.[name]
		 , d.RegTime
    INTO #retail
    FROM FI_Innova.dbo.proc_packs          p
        LEFT JOIN FI_Innova.dbo.proc_plots pl WITH (NOLOCK)
            ON p.plot = pl.plot
	    LEFT JOIN dbo.tbl_FoyleIngredients_Diary d WITH (NOLOCK) ON pl.plot = d.ProductionLineID
    WHERE CONVERT(NVARCHAR(12), p.regtime, 103) = CONVERT(NVARCHAR(12), GETDATE(), 103)
          AND pl.description2 IN ('RETAIL') AND p.plot = @plotID
		  AND p.regtime > d.RegTime
		  --AND d.Active = 1
    GROUP BY pl.plot
           , pl.[name]
		   , d.RegTime
    ORDER BY pl.plot,d.RegTime DESC

	--SELECT * FROM #retail 


    SELECT TOP 1 SUM(p.[weight]) AS DailyWgt,d.RegTime  
    INTO #Bulk
	FROM FI_Innova.dbo.proc_packs         p
        INNER JOIN FI_Innova.dbo.proc_pos po WITH (NOLOCK) ON po.po = p.po
		LEFT JOIN dbo.tbl_FoyleIngredients_Diary d WITH (NOLOCK) ON 
		(CASE
               WHEN SUBSTRING(po.shname, 1, 1) = 2 THEN
                   34
               WHEN SUBSTRING(po.shname, 1, 1) = 3 THEN
                   34
               WHEN SUBSTRING(po.shname, 1, 1) = 5 THEN
                   37 ELSE 00 END) = d.ProductionLineID
				
    WHERE CONVERT(NVARCHAR(12), p.regtime, 103) = CONVERT(NVARCHAR(12), GETDATE(), 103)
          AND p.plot IS NULL
		  AND p.regtime > d.RegTime
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
	GROUP BY d.RegTime
	ORDER BY d.RegTime DESC
 

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
         , @plotID AS plotID,pl.[name] 
    FROM #Bulk
	INNER JOIN FI_Innova.dbo.proc_plots pl WITH (NOLOCK) ON @plotID = pl.plot
    GROUP BY pl.[name]
	--SELECT * FROM @t WHERE Plot = @plotID
--============================================================================================

--Get most recent entry no for that date and line
DECLARE @Entry INT = (SELECT ISNULL(MAX(entryNo),1) AS EntryNo FROM dbo.tbl_FoyleIngredients_Diary WHERE ProductionLineID = @plotID AND CAST(RegTime AS DATE) = CAST(GETDATE()AS DATE))

--get Wgt x Entry No
DECLARE @Wgt DECIMAL(10,2) = (SELECT DailyWgt FROM @t WHERE Plot = @plotID)

IF @Entry = 1 AND @Wgt = 0.00
		BEGIN
		    SET @Wgt = (SELECT dailywgt FROM @t WHERE Plot = @plotID)
			SELECT @Wgt
		END
		ELSE
        SELECT @Wgt

DROP TABLE #Bulk
DROP TABLE #retail
END
----SELECT @PrevWgt
--	SELECT * FROM @t
--	DECLARE @EntryNo INT = (SELECT MAX(EntryNo) FROM dbo.tbl_FoyleIngredients_Diary WHERE ProductionLineID = @plotID)
--	SELECT @EntryNo
--	DECLARE @Archived INT = (SELECT TOP 1 ISNULL(Archived,0) FROM dbo.tbl_FoyleIngredients_Diary WHERE ProductionLineID = @plotID)
--	SELECT @Archived
--	DECLARE @PrevWgt DECIMAL(10,2)
--	SELECT MAX(EntryNo) AS Regtime,ProductionLineID,TotalWgt
--	INTO #wgt
--	FROM dbo.tbl_FoyleIngredients_Diary WHERE ProductionLineID = @plotID AND EntryNo = @EntryNo
--	GROUP BY ProductionLineID,TotalWgt
--	--SELECT * FROM #wgt
--	SET @PrevWgt = (SELECT TotalWgt FROM #wgt)
--	--SELECT @PrevWgt

--	IF @EntryNo = 1 AND @Archived = 0
--	BEGIN
--	DECLARE @FirstWeigh DECIMAL(10,2)= 
--	(SELECT DailyWgt FROM @t)
--	SELECT @FirstWeigh
--	   -- 	 UPDATE l		 
--			 --SET l.TotalWgt = t.DailyWgt
--			 --FROM dbo.tbl_FoyleIngredients_Diary l
--			 ----FROM FFGData.dbo.tbl_FoyleIngredients_Labour l
--			 --LEFT JOIN @t t ON l.ProductionLineID = t.Plot
--			 --WHERE l.ProductionLineID = @plotID AND l.archived IS NULL
--	END

--	ELSE
--		BEGIN
--		    DECLARE @CurrentWeight DECIMAL(10,2) = (SELECT DailyWgt FROM @t)
--			DECLARE @NewEntryWeight DECIMAL(10,2)
--			SET @NewEntryWeight = 
--			(SELECT @CurrentWeight-@PrevWgt)

--			SELECT @NewEntryWeight
		
--			 --UPDATE l		 
--			 --SET l.TotalWgt = t.DailyWgt
--			 --FROM dbo.tbl_FoyleIngredients_Diary l
--			 ----FROM FFGData.dbo.tbl_FoyleIngredients_Labour l
--			 --LEFT JOIN @t t ON l.ProductionLineID = t.Plot
--			 --WHERE l.ProductionLineID = @plotID
			
--		END

	
	
		
		
		
--		DROP TABLE #retail
--           DROP TABLE #Bulk
--				DROP TABLE #wgt
GO
