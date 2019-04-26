SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <18/06/18>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_PalletvsOrderline_Check_Master]

--exec [dbo].[usrrep_PalletvsOrderline_Check_Master] 'FD','342750','316821'

@site nvarchar(5),
@palletnum nvarchar(15),
@orderno nvarchar(15)
AS
BEGIN

IF @site = 'FD' 
				exec [usrrep_PalletvsOrderline_Check_FD] @palletnum, @orderno

IF @site = 'FH' 
				exec [usrrep_PalletvsOrderline_Check_FH]  @palletnum, @orderno

IF @site = 'FC' 
				exec [usrrep_PalletvsOrderline_Check_FC]  @palletnum, @orderno

IF @site = 'FO' 
				exec [usrrep_PalletvsOrderline_Check_FO]  @palletnum, @orderno
END
GO
