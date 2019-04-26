SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[1118_Populate_AnimalRecordValues_Stbl_FD]

AS
BEGIN

--===========================================================================================================================================
	SELECT 
	'FD' as SiteID,
		replace(d.Eartag,' ','')as Eartag,
		d.Confirm as Conform,
		d.fat as Fat,
		d.confirm + d.Fat as Grade,
		case when inspectorid =1 then 'Automatic' else 'Manual' end as GradeType,
		d.[Location] as LocationCode,
		cast(d.a_weight as decimal(10,1)) as Side1,
		cast(d.a_weight * 0.505 as decimal(10,1)) as FQ1Wgt,
		cast(d.a_Weight * 0.495 as decimal(10,1)) as HQ2Wgt,
		cast(d.b_weight as decimal(10,1))as Side2,
		cast(d.b_weight * 0.505 as decimal(10,1)) as FQ3Wgt,
		cast(d.b_Weight * 0.495 as decimal(10,1)) as HQ4Wgt,
		cast(d.a_weight + d.b_weight as decimal(10,1)) as HotWgt,
		cast((d.a_weight + d.b_weight) * 0.98 as decimal(10,1)) as ColdWgt

		into #DES

	 FROM  [DMPSQL1].[Multiflex_DMP].[dbo].[DESKill] d

    WHERE convert(nvarchar(12),d.[Date],102) between convert(nvarchar(12),getdate()-7,102) and convert(nvarchar(12),getdate(),102)
	 --SELECT * FROM #DES
--===========================================================================================================================================
	 SELECT a.Beef_AphisData_ANL_Id as AphisID,a.AnimalTagNumber as EartagNo
	 INTO #ANL
	 FROM		[DMPSQL1].[Multiflex_DMP].[dbo].[Beef_AphisData_ANL] a
	 WHERE		 convert(nvarchar(12),a.[KillDate],102) between convert(nvarchar(12),getdate()-7,102) and convert(nvarchar(12),getdate(),102)
	 ----SELECT * FROM #ANL
	 

	 SELECT d.SiteID,a.AphisID,a.EartagNo,d.Conform,d.Fat,d.Grade,d.GradeType,d.LocationCode,d.Side1,d.FQ1Wgt,d.HQ2Wgt,d.Side2,d.FQ3Wgt,d.HQ4Wgt,d.HotWgt,d.ColdWgt
	 INTO #TMP
	 FROM #ANL a
	 INNER JOIN #DES d on a.EartagNo = d.Eartag
	
	--SELECT * FROM #TMP

--===========================================================================================================================================

	insert into FFGSQL03.FFGDATA.[dbo].[grp_AnimalRecordValues_Stbl] 

							  (	
								SiteIdentifier,
								AphisANLID,
								EartagNo,
								Conform,
								FatClass,
							    Grade,
								GradeMethod,
								LocationCode,
								Side1Wgt, 
								FQ1Wgt, 
								HQ2Wgt,
								Side2Wgt,
								FQ3Wgt,
								HQ4Wgt,
								HotWeight,
								ColdWeight							
							  )
	 Select * from #tmp


	 DROP TABLE #ANL,#DES,#TMP
END
GO
