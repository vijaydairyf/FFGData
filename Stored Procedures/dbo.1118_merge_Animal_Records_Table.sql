SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,joe m>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec  [dbo].[1118_merge_Animal_Records_Table] 'FO'
CREATE PROCEDURE [dbo].[1118_merge_Animal_Records_Table]
	-- Add the parameters for the stored procedure here
	@Site NVARCHAR(3)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	WITH AR AS (
	SELECT * FROM dbo.grp_Animal_Records (NOLOCK) where 
	CONVERT(nvarchar(12),KillDate,102) BETWEEN CONVERT(nvarchar(12),GETDATE(),102) AND CONVERT(nvarchar(12),GETDATE(),102) AND SiteIdentifier = @Site
	)
	MERGE AR
	USING [dbo].[grp_Animal_Records_stbl] ST
	ON	(AR.SiteIdentifier  = ST.SiteIdentifier and ar.EartagNo = st.EartagNo and AR.AphisTblID = ST.AphisTblID)

	
	
	
	WHEN MATCHED AND AR.SiteIdentifier  = ST.SiteIdentifier and ar.EartagNo = st.EartagNo and AR.AphisTblID = ST.AphisTblID
	  THEN
		UPDATE 
			SET  
				 
				 AR.[Sex] = ST.Sex,
			     AR.[ricountry]= ST.Ricountry,
				 AR.[brcountry]= ST.Brcountry,
				 AR.[IndividualID]= ST.IndividualID,
				 AR.[KillNo]= ST.KillNo,
				 --AR.[MoveDate]= ST.MoveDate,
				 --AR.[DOB]= ST.DOB,
				 --AR.[KillDate]= ST.KillDate,
				 AR.[FQAS]= ST.FQAS,
				 --AR.[numMoves]= ST.numMoves,
				 AR.[HerdNo]= ST.HerdNo,
				 --AR.[DaysOnLastFarm]= ST.DaysOnLastFarm,
				 AR.[TWA]= ST.TWA,
				 AR.[AgeZone]= ST.AgeZone,
				 AR.OriginalEartagNo = ST.OriginalEartagNo,
				 AR.[EartagNo]= ST.EartagNo,
				 --AR.[AgeInMonths]= ST.AgeInMonths,
				 AR.[Breed]= ST.Breed,
				 AR.[HideColour] = ST.HideColour,
				 AR.[ArchivedRecord] = ST.[ArchivedRecord],
				 AR.KeeperName = ST.KeeperName,
				 AR.CertificateNo = ST.CertificateNo,
				 AR.FQA_InspectionDate = ST.FQA_InspectionDate,
				 AR.ControlRisk = ST.ControlRisk,
				 AR.RecordStatus = ST.RecordStatus,
				 AR.HighPH = ST.HighPH


	--police data ... can clean data repos here with constraints.
	WHEN NOT MATCHED by source THEN DELETE 
				 

	 WHEN NOT MATCHED 
	  THEN
		INSERT (
				 [SiteIdentifier]
				,[AphisTblID]
				,Sex
				,Ricountry
				,Brcountry
				,IndividualID
				,KillNo
				,MoveDate
				,DOB
				,KillDate
				,Regtime
				,FQAS
				,numMoves
				,HerdNo
				,KeeperName
				,DaysOnLastFarm
				,TWA
				,AgeZone
				,EartagNo
				,OriginalEartagNo
				,AgeInMonths
				,Breed
				,ArchivedRecord
				,HideColour
				,CertificateNo
				,FQA_InspectionDate
				,ControlRisk
				,RecordStatus
				,HighPH)
			VALUES
				(
				SiteIdentifier
				,ST.AphisTblID
				,ST.Sex
				,ST.Ricountry
				,ST.Brcountry
				,ST.IndividualID
				,ST.KillNo
				,ST.MoveDate
				,ST.DOB
				,ST.KillDate
				,ST.Regtime
				,ST.FQAS
				,ST.numMoves
				,ST.HerdNo
				,ST.KeeperName
				,ST.DaysOnLastFarm
				,ST.TWA
				,ST.AgeZone
				,ST.EartagNo
				,ST.OriginalEartagNo
				,ST.AgeInMonths
				,ST.Breed
				,ST.ArchivedRecord
				,ST.HideColour
				,ST.CertificateNo
				,ST.FQA_InspectionDate
				,ST.ControlRisk
				,ST.RecordStatus
				,ST.HighPH)
				
				

				;

		--DELETE FROM dbo.grp_Animal_Records WHERE ArchivedRecord =1 

END
GO
