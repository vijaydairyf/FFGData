SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,joe maguire>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [dbo].[usrrep_StockTake_GetInventories_BySite] 'FD'
CREATE PROCEDURE [dbo].[usrrep_StockTake_GetInventories_BySite]
	-- Add the parameters for the stored procedure here
	@Site nvarchar(3)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

if @Site = 'FO'
begin
    select s.inventory
         , s.description as Stocktake
         , q.time_stamp
         , i.stmethod
    from FO_Innova.dbo.proc_stocktakes            as s
        inner join
        (
            select inventory
                 , max(starttime) as time_stamp
            from FO_Innova.dbo.proc_stocktakes
            group by inventory
        )                                         as q
            on s.inventory = q.inventory
               and s.starttime = q.time_stamp
        inner join FO_Innova.dbo.proc_inventories as i
            on s.inventory = i.inventory
    where (s.status in ( 2, 0 ));

END

IF @Site = 'FC'
BEGIN 
    select s.inventory
         , s.description as Stocktake
         , q.time_stamp
         , i.stmethod
    from FM_Innova.dbo.proc_stocktakes            as s
        inner join
        (
            select inventory
                 , max(starttime) as time_stamp
            from FM_Innova.dbo.proc_stocktakes
            group by inventory
        )                                         as q
            on s.inventory = q.inventory
               and s.starttime = q.time_stamp
        inner join FM_Innova.dbo.proc_inventories as i
            on s.inventory = i.inventory
    where (s.status in ( 2, 0 ));

END

IF @Site = 'FD'
BEGIN 
    select s.inventory
         , s.description as Stocktake
         , q.time_stamp
         , i.stmethod
    from FD_Innova.dbo.proc_stocktakes            as s
        inner join
        (
            select inventory
                 , max(starttime) as time_stamp
            from FD_Innova.dbo.proc_stocktakes
            group by inventory
        )                                         as q
            on s.inventory = q.inventory
               and s.starttime = q.time_stamp
        inner join FD_Innova.dbo.proc_inventories as i
            on s.inventory = i.inventory
    where (s.status in ( 2, 0 ));

END

IF @Site = 'FG'
BEGIN 
    select s.inventory
         , s.description as Stocktake
         , q.time_stamp
         , i.stmethod
    from FG_Innova.dbo.proc_stocktakes            as s
        inner join
        (
            select inventory
                 , max(starttime) as time_stamp
            from FG_Innova.dbo.proc_stocktakes
            group by inventory
        )                                         as q
            on s.inventory = q.inventory
               and s.starttime = q.time_stamp
        inner join FG_Innova.dbo.proc_inventories as i
            on s.inventory = i.inventory
    where (s.status in ( 2, 0 ));

END

IF @Site = 'FH'
BEGIN 
    select s.inventory
         , s.description as Stocktake
         , q.time_stamp
         , i.stmethod
    from FH_Innova.dbo.proc_stocktakes            as s
        inner join
        (
            select inventory
                 , max(starttime) as time_stamp
            from FH_Innova.dbo.proc_stocktakes
            group by inventory
        )                                         as q
            on s.inventory = q.inventory
               and s.starttime = q.time_stamp
        inner join FH_Innova.dbo.proc_inventories as i
            on s.inventory = i.inventory
    where (s.status in ( 2, 0 ));

END

IF @Site = 'FI'
BEGIN 
    select s.inventory
         , s.description as Stocktake
         , q.time_stamp
         , i.stmethod
    from FI_Innova.dbo.proc_stocktakes            as s
        inner join
        (
            select inventory
                 , max(starttime) as time_stamp
            from FI_Innova.dbo.proc_stocktakes
            group by inventory
        )                                         as q
            on s.inventory = q.inventory
               and s.starttime = q.time_stamp
        inner join FI_Innova.dbo.proc_inventories as i
            on s.inventory = i.inventory
    where (s.status in ( 2, 0 ));

END



END
GO
