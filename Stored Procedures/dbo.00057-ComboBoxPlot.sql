SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[00057-ComboBoxPlot]

AS
BEGIN
SELECT plot,[Name] FROM FI_Innova.dbo.proc_plots
WHERE [name] LIKE '%FI O%'
END
GO
