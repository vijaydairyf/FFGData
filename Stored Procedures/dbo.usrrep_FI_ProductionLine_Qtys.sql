SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,joe maguire>
-- Create date: <Create Date,,18-02-19>
-- Description:	<Description,,Requested by DT, quantity and weight per line per days production>
-- =============================================
--[dbo].[usrrep_FI_ProductionLine_Qtys]40,'2019/02/18'
CREATE PROCEDURE [dbo].[usrrep_FI_ProductionLine_Qtys]
    -- Add the parameters for the stored procedure here
    @ProductionLine INT
  , @Date DATE
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT 
		   COUNT(p.id)       AS packQty
         , SUM(CAST(p.nominall AS DECIMAL(10,2))) AS labelledwgt
         , p.prday
         --, O.[name]   AS productionOrder
         , pl.[name]  AS ProductionLine
		 , pm.code AS ProductCode
		 , pm.[name] AS ProductDesc
    FROM FI_Innova.dbo.proc_packs            p
        INNER JOIN FI_Innova.dbo.proc_orders O
            ON p.porder = O.[order]
        INNER JOIN FI_Innova.dbo.proc_plots  pl
            ON p.plot = pl.plot
		INNER JOIN FI_Innova.dbo.proc_materials pm
			ON p.material = pm.material
    WHERE CAST(o.validfrom AS DATE) = @Date
          AND pl.plot = @ProductionLine
		  AND p.rtype = 1
		  AND pm.code <> '999999999'
	GROUP BY pm.code,pm.[name],p.prday,pl.[name];
END;
GO
