SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe Maguire>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [dbo].[usrrep_CarcassDispatchSales_Group] 'FC','FFGSO381935'
CREATE PROCEDURE [dbo].[usrrep_CarcassDispatchSales_Group]
	-- Add the parameters for the stored procedure here
	@Site NVARCHAR(3),
	@OrderNo NVARCHAR(15)
	--,
	--@DateFrom DATE,
	--@DateTo DATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF @Site = 'FC'
	BEGIN
	    SELECT id.slcode AS KillNo,i.prday AS PrDay, i.extnum AS Qtr, id.agezone AS AgeZone, i.[weight],m.code,m.[name] AS ItemDesc, o.[name] AS OrderNo,i.id AS itemID
		FROM FM_Innova.dbo.proc_items i 
		INNER JOIN FM_Innova.dbo.proc_prunits r ON i.inventory = r.prunit
		INNER JOIN FM_Innova.dbo.proc_individuals id ON i.individual = id.id
		INNER JOIN FM_Innova.dbo.proc_orders o ON i.[order] = o.[order]
		INNER JOIN FM_Innova.dbo.proc_materials m ON i.material = m.material
		WHERE r.prunit = 19 AND o.[name] = @OrderNo
	END


END
GO
