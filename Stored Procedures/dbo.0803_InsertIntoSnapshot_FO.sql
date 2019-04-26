SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[0803_InsertIntoSnapshot_FO]
-- Add the parameters for the stored procedure here

AS
BEGIN

    --DECLARE @From DATETIME;
    --DECLARE @To DATETIME;

    --SET @From = GETDATE() - -6;
    --SET @To = GETDATE() - 1;

    SELECT 'Foyle Omagh'                                          AS [Site]
         , i.id                                                   AS itemid
         , i.prday
         , i.[weight]                                             AS Wgt
         , i.[weight] * m.[value]                                 AS ItemVal
         , GETDATE()                                              AS SnapshotDate
         , m.code                                                 AS ProductCode
         , r.[name] + ' | ' + CAST(r.prunit AS VARCHAR(3)) + ' |' AS Inventory
		 , dc.WeekOfYear
		 --, 'Opening' AS BalanceType

		 INTO #tmp

    FROM FO_Innova.dbo.proc_items               i
        INNER JOIN FO_Innova.dbo.proc_materials m
            ON m.material = i.material
        INNER JOIN FO_Innova.dbo.proc_prunits   r
            ON i.inventory = r.prunit
		inner JOIN dbo.Date_Calendar dc ON [dc].[Date] = CAST(i.prday AS DATE)
    WHERE r.prunit IN ( 8,47 )
          AND i.rtype NOT IN ( 4, 12 )
          AND NOT m.code LIKE '%9999%'
    ORDER BY r.prunit

	INSERT INTO [dbo].[Tbl_Group_Item_Reconciliation_SS]
	
	SELECT t.[Site]
         , t.itemid
         , t.Wgt
		 , t.prday
         , t.ItemVal
         , t.SnapshotDate
		 , t.Inventory
         , t.ProductCode
		 , t.WeekOfYear

         
	FROM #tmp t

	ORDER BY t.WeekOfYear

	
	
	

DROP TABLE #tmp
	
END 

GO
