SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: 11/10/18
-- Description:	<Charges for Other Sites Selling Product to FO for Storage>
-- =============================================
Create PROCEDURE [dbo].[usrrep_FO_Storage_Charges]

--exec [dbo].[usrrep_FO_Storage_Charges] '2018/01/08', '2018/01/15'

	-- Add the parameters for the stored procedure here
	@BeginDate datetime
	--,@EndDate datetime
	
AS
BEGIN

Create Table Charges ( [Site] nvarchar (30), PalletNumber nvarchar(10), ProductCode nvarchar(10) , 
						Product nvarchar(100), Pieces int, PalletWeight decimal (18,3), FeeType nvarchar(100), Cost decimal(18,2), [Date] date)

Declare @EndDate datetime

Set @EndDate = DATEADD(wk,+1, @BeginDate)

Declare	@SundayDate DateTime,
		@LastDayStock Decimal(10,2),
		@Storage Decimal(10,2)

Set @Storage=2.70
Set @SundayDate=DATEADD(wk, DATEDIFF(wk,0,@BeginDate), -1)
Set @LastDayStock = (	SELECT Sum(Wgt) AS TotWgt 
						FROM usr_StockSnapShot_KH as sss (nolock) 
						left join proc_prunits as pr with (nolock) on pr.prunit = sss.Inventory
						Where pr.description2 = 'STOCK' and
							sss.SnapShotDate=@SundayDate)



-- Handling Fee
INSERT INTO Charges
Select case when pc.[site] = '2' then 'Foyle Campsie'
			when pc.[site] = '3' then 'Foyle Hilton'
			when pc.[site] = '4' then 'Foyle Donegal'
			when pc.[site] = '8' then 'Foyle Melton Mowbray'
			when pc.[site] = '9' then 'Foyle Ingredients'
			when pc.[site] = '10' then 'Foyle Gloucester'
			end as [site]
			
			, pc.number, pm.code as ProductCode, pm.description1 as Product,pc.pieces,pc.nominal as PallWeight,'Handling' as FeeType, 
			7.50 as HandlingFee, convert(date,pcx.regtime,103) as [Date]

from proc_coxacts pcx 
left join proc_collections as pc with (nolock) on pc.id = pcx.[collection]
left join proc_materials as pm with (nolock) on pm.material = pc.material
where 
	convert(date,pcx.regtime,103) between  Convert(date,@BeginDate,103) and Convert(date,@EndDate,103)
	and 
	pcx.xacttype = 2
	and pcx.subjectid IN (69,70,71,88,96,109) --69 Donegal --70 Campsie -- 71 Hilton -- 88 Melton --96 Gloucester -- 109 FI


----Blast 
INSERT INTO Charges
Select distinct case when pc.[site] = '2' then 'Foyle Campsie'
			when pc.[site] = '3' then 'Foyle Hilton'
			when pc.[site] = '4' then 'Foyle Donegal'
			when pc.[site] = '8' then 'Foyle Melton Mowbray'
			when pc.[site] = '9' then 'Foyle Ingredients'
			when pc.[site] = '10' then 'Foyle Gloucester'
			end as [site]
			,pc.number,pm.code as ProductCode, pm.description1 as Product,pc.pieces,pc.nominal as PallWeight, 'Blast' as FeeType, 19.50 as BlastFee, convert(date,pp.xacttime,103) as [Date]
from proc_packs as pp (nolock)
left join proc_collections as pc with (nolock) on pc.id = pp.pallet
left join proc_materials as pm with (nolock) on pm.material = pc.material
left join proc_matxacts as pmx with (nolock) on pmx.pack = pp.id
left join proc_xactpaths as xp with (nolock) on xp.xactpath = pmx.xactpath
left join proc_prunits as pr with (nolock) on pr.prunit = xp.dstprunit

where	pr.[name] like '%Blast%' 
		and convert( date, pp.xacttime,103) between  Convert(date,@BeginDate,103) and Convert(date,@EndDate,103)
		and pc.[site] <> 1




----Storage

SELECT Sum(sss.Wgt) AS TotWgt, sss.PalletId, sss.SnapShotDate
into #tmp
FROM usr_StockSnapShot_KH as sss (nolock) 
left join proc_prunits as pr with (nolock) on pr.prunit = sss.Inventory

Where	pr.description2 = 'STOCK' and
		sss.SnapShotDate=@SundayDate

group by sss.PalletId,sss.SnapShotDate


INSERT INTO Charges
Select  case when pc.[site] = '2' then 'Foyle Campsie'
			when pc.[site] = '3' then 'Foyle Hilton'
			when pc.[site] = '4' then 'Foyle Donegal'
			when pc.[site] = '8' then 'Foyle Melton Mowbray'
			when pc.[site] = '9' then 'Foyle Ingredients'
			when pc.[site] = '10' then 'Foyle Gloucester'
			end as [site]
			, pc.number, pm.code as ProductCode, pm.description1 as Product, pc.pieces, t.TotWgt, 'Storage' as FeeType, ((IsNull(t.TotWgt,0)/1000) * @Storage) as TSC, Convert(date,t.SnapShotDate,103) as [Date]
from #tmp as t
left join proc_collections as pc with (nolock) on pc.id = t.PalletId
left join proc_materials as pm with (nolock) on pm.material = pc.material



Select * from Charges

drop table Charges
END
GO
