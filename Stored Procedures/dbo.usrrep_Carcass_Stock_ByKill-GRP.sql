SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [dbo].[usrrep_Carcass_Stock_ByKill-GRP] 'FC'
CREATE PROCEDURE [dbo].[usrrep_Carcass_Stock_ByKill-GRP]
    -- Add the parameters for the stored procedure here
    @Site NVARCHAR(3)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @Start DATE = DATEADD(dd, -(DATEPART(dw, GETDATE())-1), GETDATE())
    DECLARE @End DATE = DATEADD(dd, 7-(DATEPART(dw, GETDATE())), GETDATE()) 


    IF @Site = 'FC'
    BEGIN
        SELECT id.slcode
             , COUNT(i.extnum) AS QtrCount
             , i.slday               AS KillDate
             , q.code + ' ' + f.code AS [Grade]
             , l.code                AS [Lot]
             , rm.code               AS Destination
             , SUM(i.[weight])            AS QtrWgt
             , inv.[name]            AS inventory
        FROM FM_Innova.dbo.proc_items                i
            LEFT JOIN FM_Innova.dbo.proc_individuals id
                ON i.individual = id.id
            LEFT JOIN FM_Innova.dbo.bkl_clregs       c
                ON id.id = c.individual
            LEFT JOIN FM_Innova.dbo.proc_qualities   q
                ON c.quality = q.quality
            LEFT JOIN FM_Innova.dbo.proc_fatclasses  f
                ON c.fatclass = f.fatclass
            LEFT JOIN FM_Innova.dbo.proc_lots        l
                ON i.lot = l.lot
            LEFT JOIN FM_Innova.dbo.proc_rmareas     rm
                ON i.rmarea = rm.rmarea
            LEFT JOIN FM_Innova.dbo.proc_materials   m
                ON i.material = m.material
            LEFT JOIN FM_Innova.dbo.proc_prunits     inv
                ON i.inventory = inv.prunit
        WHERE i.rtype NOT IN ( 4, 12 )
              AND i.inventory IN ( 5, 124, 125, 126, 127, 128, 129, 130 )
              AND i.extnum IS NOT NULL
			  AND i.rtype = 1
			 --AND i.device IS NULL
		GROUP BY q.code + ' ' + f.code
               , id.slcode
               , i.slday
               , l.code
               , rm.code
               , inv.name
		ORDER BY i.slday,id.slcode



       


    --SELECT * FROM FM_Innova.dbo.proc_prunits WHERE prunit IN(5, 124, 125, 126, 127, 128, 129, 130)
    END;




END;
GO
