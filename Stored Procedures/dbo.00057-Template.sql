SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[00057-Template]
AS
BEGIN

    SELECT [name]
         , plot
         , description2
    INTO #plots
    FROM FI_Innova.dbo.proc_plots
    WHERE plot IN ( 33, 34, 35, 36, 37, 38, 39, 40, 41 );

	--mark previous as inactive 
	UPDATE dbo.tbl_FoyleIngredients_Diary
	SET Active = 0
	WHERE ProductionDate <> CAST(GETDATE()AS DATE) OR CAST(RegTime AS DATE) <> CAST(GETDATE()AS DATE)


    INSERT INTO [dbo].[tbl_FoyleIngredients_Diary]
    (
        ProductionLine
      , ProductionLineID
      , ProductionDate
	  , RegTime
      , LineType
	  , EntryNo
	  , Active 
    )
    SELECT [name]
         , plot
		 , GETDATE()
         , '2019-04-18 05:45:00.513' --
         , description2
		 , 1
		 , 1
    FROM #plots;

    DROP TABLE #plots;

	--TRUNCATE TABLE dbo.tbl_FoyleIngredients_Diary

END;
GO
