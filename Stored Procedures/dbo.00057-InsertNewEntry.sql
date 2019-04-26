SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC [dbo].[00057-InsertNewEntry] '36','FI Order Line 4', '1', '12','8','15','11','30','10000.49'
CREATE PROCEDURE [dbo].[00057-InsertNewEntry]
    -- Add the parameters for the stored procedure here
    @plotid INT
  , @Line NVARCHAR(MAX)
  , @Supervisor INT
  , @Operators INT
  , @StartHr NVARCHAR(2)
  , @StartMin NVARCHAR(2)
  , @EndHr NVARCHAR(2)
  , @EndMin NVARCHAR(2)
  , @TotalWgt DECIMAL(10, 2)
AS
BEGIN

    DECLARE @Regtime DATETIME;
    SET @Regtime = GETDATE();

	DECLARE @LineType NVARCHAR(MAX) = (SELECT description2 FROM FI_Innova.dbo.proc_plots WHERE plot = @plotid)

    DECLARE @entry INT;
    SET @entry =
    (
        SELECT MAX(EntryNo)
        FROM dbo.tbl_FoyleIngredients_Diary
        WHERE ProductionLineID = @plotid
              AND ISNULL(CAST(regtime AS DATE),ProductionDate) = CAST(GETDATE() AS DATE)
    );

	

    DECLARE @archived INT;
    SET @archived =
    (
        SELECT TOP 1 ISNULL(Archived, 0)
        FROM dbo.tbl_FoyleIngredients_Diary
        WHERE ProductionLineID = @plotid
              AND ISNULL(CAST(regtime AS DATE),ProductionDate) = CAST(GETDATE() AS DATE)
    );

    IF @entry = 1
       AND @archived = 0
    BEGIN
        DECLARE @Flag INT;
        SET @Flag = @entry;
    END;
    ELSE IF @entry >= 1
            AND @archived = 1
    BEGIN
        SET @Flag = @entry + 1;
    END;
	SELECT @Flag

    IF @Flag = 1 AND @archived = 0
    BEGIN
	--SELECT 'test'
        UPDATE i
        SET i.ProductionLine = @Line
          , i.ProductionLineID = @plotid
          , i.Supervisor = @Supervisor
          , i.Operators = @Operators
          , i.StartTimeHr = @StartHr
          , i.StartTimeMin = @StartMin
          , i.EndTimeHr = @EndHr
          , i.EndTimeMin = @EndMin
          , i.TotalWgt = @TotalWgt
          , i.RegTime = @Regtime
          , i.Archived = 1
		  , i.Active = 0
        FROM dbo.tbl_FoyleIngredients_Diary i
        WHERE i.ProductionLineID = @plotid
              AND i.EntryNo = 1
			  AND i.Active = 1;
    END;

    IF @Flag > 1
		BEGIN
        INSERT INTO dbo.tbl_FoyleIngredients_Diary
        (
            ProductionLine
          , ProductionLineID
          , Supervisor
          , Operators
          , StartTimeHr
          , StartTimeMin
          , EndTimeHr
          , EndTimeMin
          , TotalWgt
          , RegTime
		  , LineType
          , EntryNo
          , Archived
		  , Active 
        )
        SELECT @Line
             , @plotid
             , @Supervisor
             , @Operators
             , @StartHr
             , @StartMin
             , @EndHr
             , @EndMin
             , @TotalWgt
             , @Regtime
			 , @LineType
             , @Flag
             , 1
			 , 1;
		 END;

		 UPDATE dbo.tbl_FoyleIngredients_Diary
		 SET Active = 0 
		 WHERE ProductionLineID = @plotid AND EntryNo = @entry
END;
GO
