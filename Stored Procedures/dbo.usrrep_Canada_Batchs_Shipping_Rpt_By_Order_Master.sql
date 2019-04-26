SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <13/06/18>
-- Description:	<usrrep_Carcass_Stock_Report_Master>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_Canada_Batchs_Shipping_Rpt_By_Order_Master]
	-- Add the parameters for the stored procedure here
	@Site nvarchar (5),
	@ordernumber NVARCHAR(20)
AS
BEGIN

-- exec [dbo].[usrrep_Canada_Batchs_Shipping_Rpt_By_Order_Master] 'FO', 'FFGSO356437'

if @site = 'FC'
BEGIN
Exec [dbo].[usrrep_Canada_Batchs_Shipping_Rpt_FC_By_Order] @ordernumber
END

if @site = 'FG'
BEGIN
Exec [dbo].[usrrep_Canada_Batchs_Shipping_Rpt_FG_By_Order] @ordernumber
END

if @site = 'FO'
BEGIN
Exec [dbo].[usrrep_Canada_Batchs_Shipping_Rpt_FO_By_Order] @ordernumber
END

if @site = 'FMM'
BEGIN
Exec [dbo].[usrrep_Canada_Batchs_Shipping_Rpt_FMM_By_Order] @ordernumber
END

if @site = 'FH'
BEGIN
Exec [dbo].[usrrep_Canada_Batchs_Shipping_Rpt_FH_By_Order] @ordernumber
END

END
GO
