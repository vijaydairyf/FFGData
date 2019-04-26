SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

-- exec [usrrep_complete_dispatch_MASTER] 'FMM','08/07/17','08/14/17'
CREATE PROCEDURE [dbo].[usrrep_complete_dispatch_MASTER]
	-- Add the parameters for the stored procedure here
	
		@site nvarchar(4),

	@begindate datetime, @enddate datetime
	
AS

				IF @site = 'FC' 

begin 
EXEC [camsql01].innova.[dbo].[usrrep_complete_dispatch] @begindate, 
														@enddate
end

				IF @site = 'FD' 

begin 
EXEC [donsql01].Innova.[dbo].[usrrep_complete_dispatch] @begindate, 
														@enddate
end

				IF @site = 'FH' 

begin 
EXEC [cktsql01].innova.[dbo].[usrrep_complete_dispatch] @begindate, 
														@enddate
end

				IF @site = 'FG' 

begin 
EXEC [glosql01].innova.[dbo].[usrrep_complete_dispatch] @begindate, 
														@enddate
end

				IF @site = 'FO' 

begin 
EXEC [omasql01].Innova.[dbo].[usrrep_complete_dispatch] @begindate, 
														@enddate
end

				IF @site = 'FMM' 

begin 
EXEC [melsql01].innova.[dbo].[usrrep_complete_dispatch] @begindate, 
														@enddate
end

				IF @site = 'FI' 

begin 
EXEC [ingsql01].FI_Innova.[dbo].[usrrep_complete_dispatch] @begindate, 
															@enddate
end





GO
