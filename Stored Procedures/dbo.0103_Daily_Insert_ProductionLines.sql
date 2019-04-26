SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[0103_Daily_Insert_ProductionLines]
AS
BEGIN

    SELECT [name]
         , plot
         , description2
    INTO #plots
    FROM FI_Innova.dbo.proc_plots
    WHERE plot IN ( 33, 34, 35, 36, 37, 38, 39, 40, 41 );


    INSERT INTO dbo.tbl_FoyleIngredients_Labour
    (
        ProductionLine
      , ProductionLineID
      , ProductionDate
      , LineType
    )
    SELECT [name]
         , plot
         , CAST(GETDATE() AS DATE)
         , description2
    FROM #plots;




    DROP TABLE #plots;

END;
GO
