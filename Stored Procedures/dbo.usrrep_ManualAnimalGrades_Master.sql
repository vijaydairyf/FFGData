SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Emma Nugent>
-- Create date: 	<10/08/17>
-- Description:	<Animals Graded Manually Report>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_ManualAnimalGrades_Master]

-- exec [dbo].[usrrep_ManualAnimalGrades_Master] 'FD' 
@site nvarchar (5)


AS


IF @site = 'FO'
begin
EXEC	[FFGSQL1].[DES].[dbo].[usrrep_ManualAnimalGrades]
end

IF @site = 'FC'
begin
EXEC	[FMSQL1].[DES].[dbo].[usrrep_ManualAnimalGrades]
end

IF @site = 'FD'
begin
EXEC	[DMPSQL1].[DES].[dbo].[usrrep_ManualAnimalGrades]
end

IF @site IS NULL 
begin
EXEC	[FFGSQL1].[DES].[dbo].[usrrep_ManualAnimalGrades]
end
GO
