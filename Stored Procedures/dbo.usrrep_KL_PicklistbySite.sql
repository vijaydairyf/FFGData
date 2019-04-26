SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe Maguire>
-- Create date: <Create Date,,22/02/2019>
-- Description:	<Description,,picklist by site calling sps at each site>
-- =============================================
--exec [dbo].[usrrep_KL_PicklistbySite] 'FO','2019-01-29','2019-01-29','Picklist','Total'
CREATE PROCEDURE [dbo].[usrrep_KL_PicklistbySite]

@Site nvarchar(3),
@StartDate datetime,
@EndDate datetime,
@Request nvarchar(25),
@Picklist NVARCHAR(150)

AS
BEGIN

DECLARE @detail TABLE (
KillNo INT NOT NULL,
AnimalTagNo NVARCHAR(25)NOT NULL,
HerdNumber NVARCHAR(20)NOT NULL,
Sex VARCHAR(1)NOT NULL,
Age INT NOT NULL,
FQAS VARCHAR(1)NOT NULL,
Grade NVARCHAR(4)NOT NULL,
CR VARCHAR(1)NOT NULL,
DaysOLF INT NOT NULL,
Moves INT NOT NULL,
Breed VARCHAR(5)NOT NULL,
ColourHide VARCHAR(4)NOT NULL,
DOB DATE NOT NULL,
O30M INT NOT NULL,
Locn NVARCHAR(10) NOT NULL,
ColdWgt DECIMAL(10,2) NOT NULL,
OAYB VARCHAR(1) NOT NULL
)

	IF @Site = 'FO'
	BEGIN
	INSERT INTO @detail
	(
	    KillNo
	  , AnimalTagNo
	  , HerdNumber
	  , Sex
	  , Age
	  , FQAS
	  , Grade
	  , CR
	  , DaysOLF
	  , Moves
	  , Breed
	  , ColourHide
	  , DOB
	  , O30M
	  , Locn
	  , ColdWgt
	  , OAYB
	)
	EXEC OMASQL01.Utilities.dbo.[FFGL-PickList] @StartDate 
	                                          , @EndDate 
	                                          , @Request 
	                                          , @Picklist
	SELECT CAST(KillNo AS INT)AS Killno
         , AnimalTagNo
         , HerdNumber
         , Sex
         , Age
         , FQAS
         , Grade
         , CR
         , DaysOLF
         , Moves
         , Breed
         , ColourHide
         , DOB
         , O30M
         , Locn
         , ColdWgt
         , OAYB FROM @detail
    END


END
GO
