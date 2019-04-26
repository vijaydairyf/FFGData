SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,joe maguire>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[1118_merge_AnimalRecordsValues]
@Site NVARCHAR(3)
AS
BEGIN
		WITH ARV AS (
		SELECT * FROM [dbo].[grp_AnimalRecordValues] where convert(nvarchar(12),regtime,102) BETWEEN  convert(nvarchar(12),getdate(),102) AND convert(nvarchar(12),getdate(),102)
		AND SiteIdentifier = @Site
		)

	MERGE  ARV 
	USING  [dbo].[grp_AnimalRecordValues_Stbl] ST
	ON	   (ARV.SiteIdentifier = ST.SiteIdentifier AND ARV.IndividualID = ST.IndividualID)



	WHEN MATCHED AND ARV.IndividualID = ST.IndividualID AND ARV.SiteIdentifier = ST.SiteIdentifier
		THEN
			UPDATE 
				SET 
					ARV.EartagNo  = ST.EartagNo,	
					ARV.Conform = ST.Conform,
					ARV.FatClass = ST.FatClass,
					ARV.Grade = ST.Grade,
					ARV.GradeMethod = ST.GradeMethod,
					ARV.LocationCode = ST.LocationCode,
					ARV.Side1Wgt = ST.Side1Wgt,
					ARV.FQ1Wgt = ST.FQ1Wgt,
					ARV.HQ2Wgt = ST.HQ2Wgt,
					ARV.Side2Wgt = ST.Side2Wgt,
					ARV.FQ3Wgt = ST.FQ3Wgt,
					ARV.HQ4Wgt = ST.HQ4Wgt,
					ARV.HotWeight = ST.HotWeight,
					ARV.ColdWeight = ST.ColdWeight,
					ARV.IdentigenNo = st.IdentigenNo
				
					--,ARV.IdentigenNo = ST.IdentigenNo -- taken out until new system in place

	WHEN NOT MATCHED 
		THEN
			INSERT(  SiteIdentifier
				    ,IndividualID
					,AphisANLID
					,EartagNo
					,Conform
					,FatClass
					,Grade
					,GradeMethod
					,LocationCode
					,Side1Wgt
					,FQ1Wgt
					,HQ2Wgt
					,Side2Wgt
					,FQ3Wgt
					,HQ4Wgt
					,HotWeight
					,ColdWeight
					,RegTime
					,IdentigenNo
					)
			VALUES
					(ST.SiteIdentifier
					,ST.IndividualID
					,ST.AphisANLID
					,ST.EartagNo
					,ST.Conform
					,ST.FatClass
					,ST.Grade
					,ST.GradeMethod
					,ST.LocationCode
					,ST.Side1Wgt
					,ST.FQ1Wgt
					,ST.HQ2Wgt
					,ST.Side2Wgt
					,ST.FQ3Wgt
					,ST.HQ4Wgt
					,ST.HotWeight
					,ST.ColdWeight
					,ST.Regtime
					,ST.IdentigenNo
					);



END
GO
