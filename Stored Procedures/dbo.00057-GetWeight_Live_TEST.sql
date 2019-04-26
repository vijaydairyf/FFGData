SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec [dbo].[00057-GetWeight_Live_TEST] 33
CREATE PROCEDURE [dbo].[00057-GetWeight_Live_TEST]
    -- Add the parameters for the stored procedure here
    @plotID INT
AS
BEGIN

	

    DECLARE @LineType NVARCHAR(25);
	DECLARE @Wgt DECIMAL(10,2);

    IF @plotID IN ( 34, 35, 37 )
    BEGIN
        SET @LineType = N'BULK';
    END;
    ELSE
        SET @LineType = N'RETAIL';

	--	SELECT @LineType

	--Get most recent entry no for that date and line
	DECLARE @Entry INT = (SELECT ISNULL(MAX(entryNo),1) AS EntryNo FROM dbo.tbl_FoyleIngredients_Diary WHERE ProductionLineID = @plotID AND 
							CONVERT(NVARCHAR(12), regtime, 103) = CONVERT(NVARCHAR(12), GETDATE(), 103))
	--SELECT @Entry


    IF @LineType = 'BULK'
    BEGIN
        SET @Wgt = (SELECT TOP (1)
               SUM(weight)
        FROM FI_Innova.dbo.proc_packs                p
            INNER JOIN FI_Innova.dbo.proc_pos        s WITH (NOLOCK)
                ON p.po = s.po
            LEFT JOIN dbo.tbl_FoyleIngredients_Diary d WITH (NOLOCK)
                ON (CASE
                        WHEN SUBSTRING(s.shname, 1, 1) = 2 THEN
                            34
                        WHEN SUBSTRING(s.shname, 1, 1) = 3 THEN
                            34
                        WHEN SUBSTRING(s.shname, 1, 1) = 5 THEN
                            37
                        ELSE
                            00
                    END
                   ) = d.ProductionLineID
        WHERE CONVERT(NVARCHAR(12), p.regtime, 103) = CONVERT(NVARCHAR(12), GETDATE(), 103)
              AND p.plot IS NULL
              AND p.rtype = 1
              AND CASE
                      WHEN SUBSTRING(s.shname, 1, 1) = 2 THEN
                          34
                      WHEN SUBSTRING(s.shname, 1, 1) = 3 THEN
                          34
                      WHEN SUBSTRING(s.shname, 1, 1) = 5 THEN
                          37
                      ELSE
                          0000
                  END = @plotID);
    END;

    IF @LineType = 'RETAIL'
    BEGIN
        SET @Wgt = (SELECT TOP (1) SUM(p.[weight]) AS DailyWgt  
        FROM FI_Innova.dbo.proc_packs                p
            LEFT JOIN FI_Innova.dbo.proc_plots       pl
                ON p.plot = pl.plot
            LEFT JOIN dbo.tbl_FoyleIngredients_Diary d
                ON pl.plot = d.ProductionLineID
        WHERE CAST(p.regtime AS DATE) = CAST(GETDATE() AS DATE)
              AND pl.description2 IN ( 'RETAIL' )
              AND p.plot = @plotID
              AND p.regtime > d.RegTime
        --AND d.Active = 1
        GROUP BY pl.plot
               , pl.[name]
               , d.RegTime
        ORDER BY pl.plot
               , d.RegTime DESC);
    END;

	IF @LineType = 'BULK' --AND @Entry = 1 --AND @Wgt = 0.00

	BEGIN
	    SELECT @Wgt
	END

	IF @LineType = 'RETAIL' AND @Entry = 1 --AND @Wgt = 0.00

	BEGIN
	    SELECT @Wgt
	END

	 



END;
GO
