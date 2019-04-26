SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe Maguire>
-- Create date: <Create Date,,29/08/2017>
-- Description:	<Description,Packs compare to procpacks innova>
-- =============================================


-- exec [usrrep_Packs_Compare] 'FC' 

CREATE PROCEDURE [dbo].[usrrep_Packs_Compare] 

@Site nvarchar(5)

AS

	--||Compare Foyle Omagh||--
	---------------------------
	IF @Site = 'FO'
	Begin
 
SELECT tp.PackNumber, tp.SSCC, tp.ProductionDate, tp.UseByDate, tp.KillDate, tp.DNOB, tp.[Weight], tp.Pieces, tp.Xacttime, tp.ProductionOrder, tp.InventoryTime,							 tp.RegistrationTime,tp.PackRtype 
		
		into #tmp


FROM	[FFGData].[dbo].[tblPack] tp	
WHERE   tp.Xacttime >= '2017-01-01 00:00:00.000' and tp.OriginalSite = 'Foyle Omagh'



SELECT pp.number, pp.sscc,pp.prday,pp.expire1,pp.expire2, pp.expire3, pp.nominal, pp.pieces, pp.xacttime, pp.porder, pp.invtime, pp.regtime, pp.rtype
		
		INTO #tmpPacks

FROM	[FO_Innova].[dbo].[proc_packs] pp
WHERE	pp.Xacttime >= '2017-01-01 00:00:00.000'  

SELECT tp.SSCC,tp.ProductionDate,tp.UseByDate,tp.KillDate,tp.[Weight],tp.Pieces,tp.Xacttime,
		pp.sscc,pp.prday,pp.expire1,pp.expire2,pp.nominal,pp.pieces,pp.xacttime
 
 
FROM #tmp tp 
				LEFT JOIN #tmpPacks pp with(nolock) on tp.PackNumber = pp.number

WHERE tp.SSCC <> pp.sscc or tp.ProductionDate <> pp.prday or tp.UseByDate <> pp.expire1 or tp.KillDate <> pp.expire2 or tp.[Weight] <> pp.nominal
or tp.Pieces <> pp.pieces or tp.Xacttime <>pp.xacttime


DROP TABLE #tmp,#tmpPacks
END
					-------------------------------------------------------------------------------------------

						--||Compare Foyle Donegal||--
						---------------------------
								ELSE 
							IF @Site = 'FD'
								BEGIN 


SELECT			tp.PackNumber, tp.SSCC, tp.ProductionDate, tp.UseByDate, tp.KillDate, tp.DNOB, tp.[Weight], tp.Pieces, tp.Xacttime, tp.ProductionOrder,					tp.InventoryTime,tp.RegistrationTime,tp.PackRtype 

INTO			#tmpDon
FROM			[FFGData].[dbo].[tblPack] tp	
WHERE			 tp.Xacttime >= '2017-01-01 00:00:00.000' and tp.OriginalSite = 'Foyle Donegal'


SELECT			 pp.number, pp.sscc,pp.prday,pp.expire1,pp.expire2, pp.expire3, pp.nominal, pp.pieces, pp.xacttime, pp.porder, pp.invtime, pp.regtime, pp.rtype
INTO				#tmpPacksDon
FROM			[FD_Innova].[dbo].[proc_packs] pp
WHERE			 pp.Xacttime >= '2017-01-01 00:00:00.000'



SELECT			tp.SSCC,tp.ProductionDate,tp.UseByDate,tp.KillDate,tp.[Weight],tp.Pieces,tp.Xacttime,
				 pp.sscc,pp.prday,pp.expire1,pp.expire2,pp.nominal,pp.pieces,pp.xacttime
FROM			 #tmpDon tp 

LEFT JOIN		#tmpPacksDon pp with(nolock)on tp.PackNumber = pp.number

WHERE			 tp.SSCC <> pp.sscc or tp.ProductionDate <> pp.prday or tp.UseByDate <> pp.expire1 or tp.KillDate <> pp.expire2 or tp.[Weight] <> pp.nominal
or tp.Pieces <> pp.pieces or tp.Xacttime <>pp.xacttime

DROP TABLE #tmpDon,#tmpPacksDon

END

						ELSE
						IF @Site = 'FG'
						 BEGIN
		-------------------------------------------------------------------------------------------

						--||Compare Foyle Gloucester||--
						---------------------------

						SELECT tp.PackNumber, tp.SSCC, tp.ProductionDate, tp.UseByDate, tp.KillDate, tp.DNOB, tp.[Weight], tp.Pieces, tp.Xacttime, tp.ProductionOrder, tp.InventoryTime, tp.RegistrationTime,tp.PackRtype 
	INTO #tmpGlo
	FROM	[FFGData].[dbo].[tblPack] tp	
	WHERE	tp.Xacttime >= '2017-01-01 00:00:00.000' and tp.OriginalSite = 'Foyle Gloucester'


SELECT	 pp.number, pp.sscc,pp.prday,pp.expire1,pp.expire2, pp.expire3, pp.nominal, pp.pieces, pp.xacttime, pp.porder, pp.invtime, pp.regtime, pp.rtype
INTO		#tmpPacksGlo
FROM	 [FG_Innova].[dbo].[proc_packs] pp
WHERE	 pp.Xacttime >= '2017-01-01 00:00:00.000'


SELECT			tp.SSCC,tp.ProductionDate,tp.UseByDate,tp.KillDate,tp.[Weight],tp.Pieces,tp.Xacttime,pp.sscc,pp.prday,pp.expire1,pp.expire2,pp.nominal,pp.pieces,pp.xacttime
FROM			#tmpGlo tp 
LEFT JOIN		 #tmpPacksGlo pp with(nolock)on tp.PackNumber = pp.number

WHERE	 tp.SSCC <> pp.sscc or tp.ProductionDate <> pp.prday or tp.UseByDate <> pp.expire1 or tp.KillDate <> pp.expire2 or tp.KillDate is null or 
		tp.[Weight] <> Cast(pp.nominal as decimal(10,2))
		or tp.Pieces <> pp.pieces or tp.Xacttime <>pp.xacttime


drop table #tmpGlo,#tmpPacksGlo

END

	-------------------------------------------------------------------------------------------

						--||Compare Foyle Ingredients||--
						---------------------------
						
						ELSE
						IF @Site = 'FI'
						 BEGIN


SELECT			tp.PackNumber, tp.SSCC, tp.ProductionDate, tp.UseByDate, tp.KillDate, tp.DNOB, tp.[Weight], tp.Pieces, tp.Xacttime, tp.ProductionOrder, tp.InventoryTime,		tp.RegistrationTime,tp.PackRtype 
	INTO #tmpING
	FROM	[FFGData].[dbo].[tblPack] tp	
	WHERE	tp.Xacttime >= '2017-01-01 00:00:00.000' and tp.OriginalSite = 'Foyle Ingredients'


SELECT	 pp.number, pp.sscc,pp.prday,pp.expire1,pp.expire2, pp.expire3, pp.nominal, pp.pieces, pp.xacttime, pp.porder, pp.invtime, pp.regtime, pp.rtype
INTO		#tmpPacksING
FROM	 [FI_Innova].[dbo].[proc_packs] pp
WHERE	 pp.Xacttime >= '2017-01-01 00:00:00.000'


SELECT			tp.SSCC,tp.ProductionDate,tp.UseByDate,tp.KillDate,tp.[Weight],tp.Pieces,tp.Xacttime,pp.sscc,pp.prday,pp.expire1,pp.expire2,pp.nominal,pp.pieces,pp.xacttime
FROM			#tmpING tp 
LEFT JOIN		 #tmpPacksING pp with(nolock)on tp.PackNumber = pp.number

WHERE	 tp.SSCC <> pp.sscc or tp.ProductionDate <> pp.prday or tp.UseByDate <> pp.expire1 or tp.KillDate <> pp.expire2 or tp.KillDate is null or 
		tp.[Weight] <> Cast(pp.nominal as decimal(10,2))
		or tp.Pieces <> pp.pieces or tp.Xacttime <>pp.xacttime


drop table #tmpING,#tmpPacksING

END


	-------------------------------------------------------------------------------------------

						--||Compare Foyle Hilton||--
						---------------------------
						
						ELSE
						IF @Site = 'FH'
						 BEGIN


SELECT			tp.PackNumber, tp.SSCC, tp.ProductionDate, tp.UseByDate, tp.KillDate, tp.DNOB, tp.[Weight], tp.Pieces, tp.Xacttime, tp.ProductionOrder, tp.InventoryTime,		tp.RegistrationTime,tp.PackRtype 
	INTO #tmpHIL
	FROM	[FFGData].[dbo].[tblPack] tp	
	WHERE	tp.Xacttime >= '2017-01-01 00:00:00.000' and tp.OriginalSite = 'Foyle Hilton'


SELECT	 pp.number, pp.sscc,pp.prday,pp.expire1,pp.expire2, pp.expire3, pp.nominal, pp.pieces, pp.xacttime, pp.porder, pp.invtime, pp.regtime, pp.rtype
INTO		#tmpPacksHIL
FROM	 [FH_innova].[dbo].[proc_packs] pp
WHERE	 pp.Xacttime >= '2017-01-01 00:00:00.000'


SELECT			tp.SSCC,tp.ProductionDate,tp.UseByDate,tp.KillDate,tp.[Weight],tp.Pieces,tp.Xacttime,pp.sscc,pp.prday,pp.expire1,pp.expire2,pp.nominal,pp.pieces,pp.xacttime
FROM			#tmpHIL tp 
LEFT JOIN		 #tmpPacksHIL pp with(nolock)on tp.PackNumber = pp.number

WHERE	 tp.SSCC <> pp.sscc or tp.ProductionDate <> pp.prday or tp.UseByDate <> pp.expire1 or tp.KillDate <> pp.expire2 or tp.KillDate is null or 
		tp.[Weight] <> Cast(pp.nominal as decimal(10,2))
		or tp.Pieces <> pp.pieces or tp.Xacttime <>pp.xacttime


drop table #tmpHIL,#tmpPacksHIL

END

--	-------------------------------------------------------------------------------------------

--						--||Compare Foyle Campsie||--
--						---------------------------
						
--						ELSE
--						IF @Site = 'FC'
--						 BEGIN


--SELECT			tp.PackNumber, tp.SSCC, tp.ProductionDate, tp.UseByDate, tp.KillDate, tp.DNOB, tp.[Weight], tp.Pieces, tp.Xacttime, tp.ProductionOrder, tp.InventoryTime,		tp.RegistrationTime,tp.PackRtype 
--	INTO #tmpCam
--	FROM	[FFGData].[dbo].[tblPack] tp	
--	WHERE	tp.Xacttime >= '2017-01-01 00:00:00.000' and tp.OriginalSite = 'Foyle Campsie'


--SELECT	 pp.number, pp.sscc,pp.prday,pp.expire1,pp.expire2, pp.expire3, pp.nominal, pp.pieces, pp.xacttime, pp.porder, pp.invtime, pp.regtime, pp.rtype
--INTO		#tmpPacksCam
--FROM	 [FM_Innova].[dbo].[proc_packs] pp
--WHERE	 pp.Xacttime >= '2017-01-01 00:00:00.000'


--SELECT			tp.SSCC,tp.ProductionDate,tp.UseByDate,tp.KillDate,tp.[Weight],tp.Pieces,tp.Xacttime,pp.sscc,pp.prday,pp.expire1,pp.expire2,pp.nominal,pp.pieces,pp.xacttime
--FROM			#tmpCam tp 
--LEFT JOIN		 #tmpPacksCam pp with(nolock)on tp.PackNumber = pp.number

--WHERE	 tp.SSCC <> pp.sscc or tp.ProductionDate <> pp.prday or tp.UseByDate <> pp.expire1 or tp.KillDate <> pp.expire2 or tp.KillDate is null or 
--		tp.[Weight] <> Cast(pp.nominal as decimal(10,2))
--		or tp.Pieces <> pp.pieces or tp.Xacttime <>pp.xacttime


--drop table #tmpCam,#tmpPacksCam



	-------------------------------------------------------------------------------------------

						--||Compare Foyle Hilton||--
						---------------------------
						
						ELSE
						IF @Site = 'FMM'
						 BEGIN


SELECT			tp.PackNumber, tp.SSCC, tp.ProductionDate, tp.UseByDate, tp.KillDate, tp.DNOB, tp.[Weight], tp.Pieces, tp.Xacttime, tp.ProductionOrder, tp.InventoryTime,		tp.RegistrationTime,tp.PackRtype 
	INTO #tmpMM
	FROM	[FFGData].[dbo].[tblPack] tp	
	WHERE	tp.Xacttime >= '2017-01-01 00:00:00.000' and tp.OriginalSite = 'Foyle Melton Mowbray'


SELECT	 pp.number, pp.sscc,pp.prday,pp.expire1,pp.expire2, pp.expire3, pp.nominal, pp.pieces, pp.xacttime, pp.porder, pp.invtime, pp.regtime, pp.rtype
INTO		#tmpPacksMM
FROM	 [FMM_innova].[dbo].[proc_packs] pp
WHERE	 pp.Xacttime >= '2017-01-01 00:00:00.000'


SELECT			tp.SSCC,tp.ProductionDate,tp.UseByDate,tp.KillDate,tp.[Weight],tp.Pieces,tp.Xacttime,pp.sscc,pp.prday,pp.expire1,pp.expire2,pp.nominal,pp.pieces,pp.xacttime
FROM			#tmpMM tp 
LEFT JOIN		 #tmpPacksMM pp with(nolock)on tp.PackNumber = pp.number

WHERE	 tp.SSCC <> pp.sscc or tp.ProductionDate <> pp.prday or tp.UseByDate <> pp.expire1 or tp.KillDate <> pp.expire2 or tp.KillDate is null or 
		tp.[Weight] <> Cast(pp.nominal as decimal(10,2))
		or tp.Pieces <> pp.pieces or tp.Xacttime <>pp.xacttime


drop table #tmpMM,#tmpPacksMM

END
GO
