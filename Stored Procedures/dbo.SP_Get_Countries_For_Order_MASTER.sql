SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <20/07/17>
-- Description:	<Site Identifier For Yield Reports>
-- =============================================


--EXEC [dbo].[SP_Get_Countries_For_Order_MASTER] 238301 , 'FO'

CREATE PROCEDURE [dbo].[SP_Get_Countries_For_Order_MASTER]

@OrderNo nvarchar (max),
@site nvarchar(3)



AS


IF @site = 'FO'
begin

EXEC					[FFGSQL03].FO_Innova.[dbo].[SP_Get_Countries_For_Order] @OrderNo 
end

IF @site = 'FC'
begin

EXEC					[FFGSQL03].FM_Innova.[dbo].[SP_Get_Countries_For_Order] @OrderNo 
end

IF @site = 'FG'
begin

EXEC					[FFGSQL03].FG_Innova.[dbo].[SP_Get_Countries_For_Order] @OrderNo 
end

IF @site = 'FD'
begin

EXEC					[FFGSQL03].FD_Innova.[dbo].[SP_Get_Countries_For_Order] @OrderNo 
end

IF @site = 'FH'
begin

EXEC					[FFGSQL03].FH_Innova.[dbo].[SP_Get_Countries_For_Order] @OrderNo 
end

IF @site = 'FI'
begin

EXEC					[FFGSQL03].FI_Innova.[dbo].[SP_Get_Countries_For_Order] @OrderNo 
end

IF @site = 'FMM'
begin

EXEC					[FFGSQL03].FMM_Innova.[dbo].[SP_Get_Countries_For_Order] @OrderNo 
end

GO
