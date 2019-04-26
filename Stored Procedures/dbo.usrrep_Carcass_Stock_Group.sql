SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [dbo].[usrrep_Carcass_Stock_Group] 'FO'
CREATE PROCEDURE [dbo].[usrrep_Carcass_Stock_Group]
	-- Add the parameters for the stored procedure here
	@Site NVARCHAR(3)
AS
BEGIN


IF @Site = 'FC'
BEGIN
    SELECT i.slcode,i.slday,SUM(it.[weight]) AS[Weight],COUNT(it.extnum) QtrCount

	FROM FM_Innova.dbo.proc_items it 
	INNER JOIN FM_Innova.dbo.proc_individuals i ON it.individual = i.id
	LEFT JOIN FM_Innova.dbo.proc_rmareas rm ON it.rmarea = rm.rmarea
	INNER JOIN FM_Innova.dbo.proc_prunits ru ON ru.prunit = it.inventory
	WHERE ru.prunit = 5 AND i.regtime BETWEEN GETDATE()-7 AND GETDATE()
	GROUP BY i.slcode,i.slday
END
IF @Site = 'FO'
BEGIN
    SELECT i.slcode,i.slday,SUM(it.[weight]) AS[Weight],COUNT(it.extnum) QtrCount

	FROM FO_Innova.dbo.proc_items it 
	INNER JOIN FO_Innova.dbo.proc_individuals i ON it.individual = i.id
	LEFT JOIN FO_Innova.dbo.proc_rmareas rm ON it.rmarea = rm.rmarea
	INNER JOIN FO_Innova.dbo.proc_prunits ru ON ru.prunit = it.inventory
	WHERE ru.prunit = 8 AND i.regtime BETWEEN GETDATE()-7 AND GETDATE()
	GROUP BY i.slcode,i.slday
END






END
GO
