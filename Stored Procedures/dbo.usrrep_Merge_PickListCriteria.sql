SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Glen Duncan>
-- Create date: <Create Date,,25/05/2018>
-- Description:	<Description,Merge the Packinglist criteria from Staging table>
-- =============================================

CREATE PROCEDURE [dbo].[usrrep_Merge_PickListCriteria] 


AS
	Begin
	MERGE
		dbo.tblPickListCriteria AS TARGET
	USING
		(
			SELECT 
				STAG_PL.PaymentLineId,
				STAG_PL.SpecName,
				STAG_PL.SiteID,
				STAG_PL.KillDate,
				STAG_PL.KillNo,
				STAG_PL.Eartag,
				STAG_PL.Sex,
				STAG_PL.AgeInMonths,
				STAG_PL.ColdWeight,
				STAG_PL.Conformation,
				STAG_PL.Fat,
				STAG_PL.FQAS,
				STAG_PL.DaysOnLastFarm,
				STAG_PL.BornIn,
				STAG_PL.RearedIn,
				STAG_PL.SlaughteredIn,
				STAG_PL.Location
			FROM 
				dbo.Staging_tblPickListCriteria STAG_PL
		) AS SOURCE
		
		ON(
			TARGET.[PaymentLineId] = SOURCE.[PaymentLineId])
			
			--update if matched
			WHEN MATCHED THEN
			UPDATE SET
				TARGET.PaymentLineId = SOURCE.PaymentLineId,
				TARGET.SpecName = SOURCE.SpecName,
				TARGET.SiteID = SOURCE.SiteID,
				TARGET.KillDate = SOURCE.KillDate,
				TARGET.KillNo = SOURCE.KillNo,
				TARGET.Eartag = SOURCE.Eartag,
				TARGET.Sex = SOURCE.Sex,
				TARGET.AgeInMonths = SOURCE.AgeInMonths,
				TARGET.ColdWeight = SOURCE.ColdWeight,
				TARGET.Conformation = SOURCE.Conformation,
				TARGET.Fat = SOURCE.Fat,
				TARGET.FQAS = SOURCE.FQAS,
				TARGET.DaysOnLastFarm = SOURCE.DaysOnLastFarm,
				TARGET.BornIn = SOURCE.BornIn,
				TARGET.RearedIn = SOURCE.RearedIn,
				TARGET.SlaughteredIn = SOURCE.SlaughteredIn,
				TARGET.Location = SOURCE.Location
			
			--if no row in target then Insert
			WHEN NOT MATCHED BY TARGET THEN
			INSERT 
			(	
				PaymentLineId,
				SpecName,
				SiteID,
				KillDate,
				KillNo,
				Eartag,
				Sex,
				AgeInMonths,
				ColdWeight,
				Conformation,
				Fat,
				FQAS,
				DaysOnLastFarm,
				BornIn,
				RearedIn,
				SlaughteredIn,
				Location
			)
			VALUES
			(	
				PaymentLineId,
				SpecName,
				SiteID,
				KillDate,
				KillNo,
				Eartag,
				Sex,
				AgeInMonths,
				ColdWeight,
				Conformation,
				Fat,
				FQAS,
				DaysOnLastFarm,
				BornIn,
				RearedIn,
				SlaughteredIn,
				Location
			)
			
			--remove any rows in the Target that ddoesn't exist in the Source
			WHEN NOT MATCHED BY SOURCE THEN 
			DELETE;
			
			--OUTPUT $action, 
			--INSERTED.[PaymentLineId] [PaymentLineId];
			--SELECT @@ROWCOUNT;;
	END
GO
