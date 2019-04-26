SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[1118_UpdateIdentigenOnGrpValues_]

AS
BEGIN
--Foyle Melton Mowbray
SELECT 
'FMM' As Site,
ISNULL(Max(i.[usr_Identigen]),0) As IdentigenBarcode,
CAST(t.Factory As NVARCHAR(50)) As CN, 
REPLACE(t.Eartag,' ','') As ET
into #tmpFMM
FROM				[FMM-SQL02].Multiflex_FMM.dbo.DESKill t with (nolock) 
					INNER JOIN [FMM-SQL02].Multiflex_FMM.dbo.[mf_animal] a with (nolock) ON t.Eartag = a.EartagNo Collate Database_Default
					INNER JOIN [FMM-SQL02].Multiflex_FMM.dbo.[mf_BeefCarcass] b with (nolock) on a.animalid=b.animalid
					INNER JOIN [FMM-SQL02].Multiflex_FMM.dbo.[mf_InvObject] i with (nolock) on b.BeefCarcassId=i.BeefCarcassId 
				
WHERE				convert(nvarchar(12),t.[Date],102)  BETWEEN  convert(nvarchar(12),GETDATE()-7,102) and convert(nvarchar(12),GETDATE(),102)
GROUP BY			 t.Factory, t.Eartag


UPDATE	v
SET v.IdentigenNo = t.IdentigenBarcode
FROM grp_AnimalRecordValues v
INNER JOIN #tmpFMM t on v.EartagNo collate database_Default = t.ET and v.SiteIdentifier = t.[Site]
DROP TABLE #tmpFMM
--========================================================================================================================
--Foyle Gloucester
SELECT 
'FG' As SiteID ,
ISNULL(Max(i.[usr_Identigen]),0) As IdentigenBarcode,
CAST(t.Factory As NVARCHAR(50)) As CN, 
replace(t.Eartag,' ','') As ET
INTO #tmpFG
FROM				[FG-SQL01].Multiflex_FG.dbo.DESKill t with (nolock) 
					INNER JOIN [FG-SQL01].Multiflex_fg.dbo.[mf_animal] a with (nolock) ON t.Eartag = a.EartagNo Collate Database_Default
					INNER JOIN [FG-SQL01].Multiflex_fg.dbo.[mf_BeefCarcass] b with (nolock) on a.animalid=b.animalid
					INNER JOIN [FG-SQL01].Multiflex_fg.dbo.[mf_InvObject] i with (nolock) on b.BeefCarcassId=i.BeefCarcassId 					
WHERE				convert(nvarchar(12),t.[Date],102)  BETWEEN  convert(nvarchar(12),GETDATE()-7,102) and convert(nvarchar(12),GETDATE(),102)			
GROUP BY			t.Factory, t.Eartag	


UPDATE	v
SET v.IdentigenNo = t.IdentigenBarcode
FROM grp_AnimalRecordValues v
INNER JOIN #tmpFG t on v.EartagNo collate database_Default = t.ET and v.SiteIdentifier = t.[SiteID]
DROP TABLE #tmpFG
--========================================================================================================================
--Foyle Donegal
Select
'FD' As SiteID,
ISNULL(Max(b.[Identigen]),0) As IdentigenBarcode,
CAST(t.Factory As NVARCHAR(50)) As CN, 
replace(t.Eartag,' ','') As ET
INTO #tmpFD
FROM				DMPSQL1.Multiflex_DMP.dbo.DESKill t with (nolock) 
					INNER JOIN DMPSQL1.Multiflex_DMP.dbo.[mf_animal] a with (nolock) ON t.Eartag = a.EartagNo Collate Database_Default
					INNER JOIN DMPSQL1.Multiflex_DMP.dbo.[mf_BeefCarcass] b with (nolock) on a.animalid=b.animalid
					INNER JOIN DMPSQL1.Multiflex_DMP.dbo.[mf_InvObject] i with (nolock) on b.BeefCarcassId=i.BeefCarcassId 					
WHERE				convert(nvarchar(12),t.[Date],102)  BETWEEN  convert(nvarchar(12),GETDATE()-7,102) and convert(nvarchar(12),GETDATE(),102)
GROUP BY			t.Factory, t.Eartag


UPDATE	v
SET v.IdentigenNo = t.IdentigenBarcode
FROM grp_AnimalRecordValues v
INNER JOIN #tmpFD t on v.EartagNo collate database_Default = t.ET and v.SiteIdentifier = t.[SiteID]
DROP TABLE #tmpFD
--========================================================================================================================
-- FOYLE CAMPSIE
--SELECT 
--	'FC' As Site, 
--	CAST(Replace(Replace(Convert(varchar(10), t.Date, 126),'/',''),'-','/') As NVARCHAR(50)) As KillDate, 
--	ISNULL(Max(i.[usr_Identigen]),0) As IdentigenBarcode,
--	CAST(t.Factory As NVARCHAR(50)) As CN, 
--	t.Eartag As ET, 
--	t.Breed As DeclaredBreed, 
--	--'NA' As Sire, t.DamBreed As Dam, 
--	Replace(Min(s.Name),',','') As FarmerName,  
--	Replace(S.Supplier,' ','') As FarmerCode,
--	CAST(DatePart(d,t.Date) As NVARCHAR(50)) As Batch, 
--	t.Grade As GradeEU,
--	'NO' As Organic, 
--	Case When 
--	(
--		 DATENAME(dw,t.[Date])='Tuesday' And t.Location Like '%-AAF%' 
--	) 
--	Then 
--		'TAA' 
--	Else 
--		'NA' 
--	End As Programme,
--	t.Location As [Eligibility],

--	CAST(Round(((MIN(t.a_weight)+MIN(t.b_weight))),1) As NVARCHAR(50)) As HotWgt,

--	CAST(Round(((MIN(t.a_weight)+MIN(t.b_weight))*0.98),1) As NVARCHAR(50)) As ColdWgt,

--	--t.Sex As Sex, 
--	Case When @carne=1 --, t.confirm, t.fat	
--		Then Case When t.sex='A' And Not(t.confirm Like 'P%') And Not (t.fat Like '1%') And Not (t.fat Like '5%') Then 'C' Else t.sex End
--	Else t.Sex End As Sex,

--	'NA' As RFID,

--CAST(t.lps_ageinmonths As NVARCHAR(50)) As Age,
--Replace(Replace(Convert(varchar(10), t.dob , 126),'/',''),'-','/') AS DOB,
--Case When t.FQA = 'True' Then 'YES' Else 'NO' End As QAScheme

--FROM				fmsql1.multiflex_foyle.dbo.DESKill t with (nolock) 
--					INNER JOIN fmsql1.multiflex_foyle.dbo.[mf_animal] a with (nolock) ON t.Eartag = a.EartagNo Collate Database_Default
--					INNER JOIN fmsql1.multiflex_foyle.dbo.[mf_BeefCarcass] b with (nolock) on a.animalid=b.animalid
--					INNER JOIN fmsql1.multiflex_foyle.dbo.[mf_InvObject] i with (nolock) on b.BeefCarcassId=i.BeefCarcassId 
--					INNER JOIN fmsql1.multiflex_foyle.dbo.[DesSupplier] s with (nolock) 
--						on 

--						-- DBogues 2017-01-31
--						-- adding any 'smart' logic in here makes an already bloated query even worse. I have queried Identigen to the frequencey of what we send them.
--						-- it would be great to make Nav (or even deskill) the driver for this data.
--						-- even looking into adding left joins could improve this but I dont have the time to investigate data at the minute
--						-- for now
--						case 
--							when t.Supplier = '69/202/009' then '69/202/0092' 
--							when t.Supplier = '75/319/002' then '75/319/0028' 
--							when t.Supplier = '69/202/800' then '69/202/8001'
--							when t.Supplier = '08/153/006' then '08/153/0063'
--							when t.Supplier = '82/513/700' then '82/513/7006' 
						
--							else t.Supplier end =s.Supplier

--WHERE				t.[Date] BETWEEN @StartDate AND @EndDate
					
--GROUP BY			s.Supplier, t.Date, t.Factory, t.Eartag, t.Grade, t.Sex, t.Breed, t.FQA, t.lps_ageinmonths, t.dob, t.location, t.dambreed, t.confirm, t.fat	


END
GO
