SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,joe maguire	>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--[dbo].[usrrep_KL_TraceRpt_ByAnimal_Site] 'FO','2019-02-25','2019-02-25','1669'
CREATE PROCEDURE [dbo].[usrrep_KL_TraceRpt_ByAnimal_Site]
	-- Add the parameters for the stored procedure here
	@Site nvarchar(40),
	@KillDateFrom date,
	@KillDateTo DATE,
	@Killno int	

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select 
	      r.Sex
	     , r.KillNo
		 , r.KillDate
	     , r.MoveDate
	     , r.DOB
	     , r.FQAS
	     , r.numMoves
	     , r.HerdNo
	     , r.KeeperName
	     , r.DaysOnLastFarm 
	     , r.AgeZone
	     , r.EartagNo
	     , r.AgeInMonths
	     , r.Breed
	     , r.brcountry
	     , r.ricountry	 
		 , r.hidecolour 
		 , flv.[Address]
		 , flv.[Address 2]
		 , flv.[Post Code]
		 , r.certificateno
		 , r.[FQA_InspectionDate] AS InspecDate
		 , s.FeedName
		 , f.[Description]
		 , f.Ingredient1
		 , f.Ingredient2
		 , f.Ingredient3
		 , f.Ingredient4
		 , f.Ingredient5
		 , f.Ingredient6
		 , f.Ingredient7
		 , f.Ingredient8
		 , f.Ingredient9
		 , f.Ingredient10
		 , f.Ingredient11
		 , f.Ingredient12
		 , f.Ingredient13
		 , f.Ingredient14
		 , f.Ingredient15
		 , f.Ingredient16
		 , f.Ingredient17
		 , f.Ingredient18
		 , f.Ingredient19
		 , f.Ingredient20
		 , f.Ingredient21
		 , f.Ingredient22
		 , f.Ingredient23
		 , f.Ingredient24


	from dbo.grp_Animal_Records r 
	inner join ffgsql01.[FFG-Production].dbo.[FFG LIVE$Vendor] as FLV on r.HerdNo collate database_default = FLV.[Supplier ID]
	LEFT JOIN  ffgsql1.Multiflex_Omagh.dbo.DESSupplier s ON r.HerdNo collate database_default = s.Supplier 
	LEFT JOIN ffgsql1.Multiflex_Omagh.dbo.usr_FeedDetails f ON s.FeedName = f.FeedCode

	where r.SiteIdentifier = @Site and r.KillDate between @KillDateFrom AND @KillDateTo and r.KillNo = @Killno


	--SELECT * FROM ffgsql1.Multiflex_Omagh.dbo.usr_FeedDetails WHERE FeedCode = 'PC - TAYLORS BM'
END
GO
