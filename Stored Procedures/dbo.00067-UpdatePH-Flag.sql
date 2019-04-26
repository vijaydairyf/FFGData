SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
	--exec [dbo].[00067-UpdatePH-Flag] 'FC','117','12/04/2019 00:00:00',1
CREATE PROCEDURE [dbo].[00067-UpdatePH-Flag]
	@Site NVARCHAR(3),
	@KillNo NVARCHAR(4),
	@KillDate NVARCHAR(12),
	@Chk NVARCHAR(10)
    
AS
BEGIN

DECLARE @Flag NVARCHAR(1)

	--IF @Chk = 'True'
	--BEGIN
	--    SET @Flag = '1'
	--END
	--	ELSE IF @Chk = 'FALSE'
	--	BEGIN
	--	  SET @Flag = '0'  
	--	END
		
	--SELECT @chk
	
	--SELECT r.HighPH,@Flag,CONVERT(NVARCHAR(12),r.KillDate,103),@KillDate,r.KillNo,@Chk
	UPDATE r 
	SET r.HighPH = @Chk
	FROM dbo.grp_Animal_Records r 
	WHERE r.SiteIdentifier = @Site 
	AND CONVERT(NVARCHAR(12),r.KillDate,103) = CONVERT(NVARCHAR(12),@KillDate,103)
	AND r.KillNo =@KillNo


END
GO
