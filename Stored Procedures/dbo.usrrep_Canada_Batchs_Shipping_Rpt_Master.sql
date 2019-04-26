SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <13/06/18>
-- Description:	<usrrep_Carcass_Stock_Report_Master>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_Canada_Batchs_Shipping_Rpt_Master]
	-- Add the parameters for the stored procedure here
	@Site nvarchar (5),
	@FromProdDate date,
	@ToProdDate date
AS
BEGIN

-- exec [dbo].[usrrep_Canada_Batchs_Shipping_Rpt_Master] 'FO', 01/12/18, 20/12/18

if @site = 'FC'
BEGIN
Exec [dbo].[usrrep_Canada_Batchs_Shipping_Rpt_FC] @FromProdDate, @ToProdDate
END

if @site = 'FG'
BEGIN
Exec [dbo].[usrrep_Canada_Batchs_Shipping_Rpt_FG] @FromProdDate, @ToProdDate
END

if @site = 'FO'
BEGIN
Exec [dbo].[usrrep_Canada_Batchs_Shipping_Rpt_FO] @FromProdDate, @ToProdDate
END

END
GO
