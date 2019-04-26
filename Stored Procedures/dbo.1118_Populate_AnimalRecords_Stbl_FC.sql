SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[1118_Populate_AnimalRecords_Stbl_FC]

AS
BEGIN
	SELECT 

			'FC' as SiteIdentifier,
			a.[Beef_AphisData_ANL_Id],
			a.Sex,
			a.KillNumber, 
			a.MoveInDateToPriviousHerd,
			a.dateofbirth,
			a.[KillDate],
			a.modified as regtime,
			a.FQAS as FQAS_ANL,
			a.[NumberOfFarmMove],
			a.herdnumber,
			case when  a.MoveInDateToPriviousHerd ='1990-01-01 00:00:00.000' then 0 
				else datediff(day, a.MoveInDateToPriviousHerd,a.[KillDate])+1 end as DaysOnLastFarm,
			case when a.Over24Months = 'Y' and a.over30months = 'Y' then 'OTM'
				when a.over24months = 'Y' and a.Over30Months = 'N' then 'UTM'
				when a.over24months = 'N' then 'UTM'
				end as AgeZone,
			replace(a.animaltagnumber,' ','')as Eartag,
			a.Breed,
			Case when a.archived is null then 0 else 1 end as Archived

	INTO	#anl

	FROM   [FMSQL1].[Multiflex_Foyle].[dbo].[Beef_AphisData_ANL] a
	WHERE  convert(nvarchar(12),a.KillDate,102) between convert(nvarchar(12),getdate()-2,102) and convert(nvarchar(12),getdate(),102)
	--cast(a.killdate as date) between cast(getdate()-2 as date) and cast(getdate() as date)
	
	--  --and a.archived is null
	
	--Select * from #anl order by Archived desc
	

--=====================================================================================================================================
	SELECT replace(d.Eartag,' ','')as Eartag, d.LPS_AgeInMonths as AgeMonths,d.LPS_Origin as Origin,d.Reared as Reared, d.factory,
			case when d.FQA = 1 then 'Y' else 'N' end as FQAS_DES
	INTO  #des
	FROM  [FMSQL1].[Multiflex_Foyle].[dbo].[DESKill] d
	WHERE convert(nvarchar(12),d.[Date],102) between convert(nvarchar(12),getdate()-2,102) and convert(nvarchar(12),getdate(),102)  --and a.archived is null
	--Select * from #des where Eartag = 'UK939265616974'


	SELECT a.SiteIdentifier,a.[Beef_AphisData_ANL_Id] as AphisID,A.Sex as Sex, A.KillNumber as KillNO,a.MoveInDateToPriviousHerd as MoveDate,a.dateofbirth as DOB,
			a.[KillDate]as KillDate,a.regtime,d.FQAS_DES as FQAS,a.[NumberOfFarmMove] as numMoves,a.herdnumber as herdno,a.DaysOnLastFarm,a.AgeZone,a.Eartag,a.Breed as breed,
			d.AgeMonths,d.Origin,d.Reared,

			case when  d.AgeMonths <30 and a.DaysOnLastFarm >=20 and a.[NumberOfFarmMove] <=4 and d.FQAS_DES  = 'Y' and a.Sex in ('C','D','E')
			--or (a.Sex = 'A' and d.AgeMonths between 1 and 24))))
					then 'TWA'	

				 When (d.AgeMonths BETWEEN 30 and 120) and a.DaysOnLastFarm >=30 and a.[NumberOfFarmMove] <=4 and d.FQAS_DES = 'Y' and a.Sex in ('C','D','E')
				 -- or (a.Sex = 'A' and d.AgeMonths between 1 and 24))))
					then 'TWA'

				 When d.AgeMonths between 1 and 24 and a.Sex = 'A' and a.[NumberOfFarmMove] <=4 and a.DaysOnLastFarm >=20 and d.FQAS_DES = 'Y'
					then 'TWA'

					--(( and a.FQAS = 1 and a.Sex in ('C','D','E')) or 		
				else ' ' end as TWA,
		case when d.Origin in ('N IRELAND','GB') then 'UK'
				when d.Origin = 'IRELAND' then 'IE'
				  when d.Origin = 'SWEDEN' then 'SE'
					when d.Origin = 'Germany' then 'DE'
						when d.Origin = 'France' then 'FR'
							when d.Origin = 'Denmark' then 'DK'
								when d.Origin = 'Holland' then 'NL'
									when d.Origin = 'Romania' then 'RO'
									   when d.Origin = 'Norway' then 'NY'
									 Else 'OTR' End as Bornin,

					a.Archived

			INTO #Record
		 FROM #anl a
		 LEFT JOIN #des d on a.Eartag = d.Eartag

		--Select * from #Record where cast(#Record.KillDate as date) = '2018-11-15' and #Record.Archived = 0

	 INSERT INTO FFGSQL03.FFGDATA.[dbo].[grp_Animal_Records_Stbl](
					[SiteIdentifier],	
					[AphisTblID],
					[Sex],
					[KillNo],
					[MoveDate],
					[DOB],
					[KillDate],
					[Regtime],
					[FQAS],
					[numMoves],
					[HerdNo],
					[DaysOnLastFarm],
					[TWA],
					[AgeZone],
					[EartagNo],
					[AgeInMonths],
					[Breed],
					[brcountry],
					[ricountry],
					[ArchivedRecord]
	 )
	 Select r.SiteIdentifier,
			r.AphisID,
			r.Sex,
			r.KillNO,
			r.MoveDate,
			r.DOB,
			r.KillDate,
			r.regtime,
			r.FQAS,
			r.numMoves,
			r.herdno,
			r.DaysOnLastFarm,
			r.TWA,
			r.AgeZone,
			r.Eartag,
			r.AgeMonths,
			r.breed,
			r.Bornin,
			r.Reared,
			r.Archived
	 from #Record r

	 order by Archived

	 drop table #anl,#des,#Record
END
GO
