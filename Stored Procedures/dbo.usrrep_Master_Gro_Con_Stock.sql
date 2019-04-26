SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Kevin Hargan
-- Create date: 24/08/18
-- Description:	Master sp for Gro Con Stock
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_Master_Gro_Con_Stock]
	-- Add the parameters for the stored procedure here
	--exec [dbo].[usrrep_Master_Gro_Con_Stock] 'FMM'

@Site nvarchar (5)

AS


IF @site = 'FMM'
begin
EXEC					[FFGSQL03].[FMM_Innova].[dbo].[usrrep_Gro_Con_Stock]
end

IF @site = 'FG'
begin
EXEC					[FFGSQL03].[FG_Innova].[dbo].[usrrep_Gro_Con_Stock]
end


GO
