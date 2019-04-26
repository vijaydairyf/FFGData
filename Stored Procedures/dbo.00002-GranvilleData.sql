SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--Truncate Table tblHrOrders

--exec [00002-GranvilleData]

CREATE PROCEDURE [dbo].[00002-GranvilleData]

AS 

Update [dbo].[tblLRP] Set NumberIndicator = '1', TimeIndicator=GetDate() Where id=28

Truncate Table [dbo].[tblColdStoreData]

Insert Into FFGData.dbo.[tblColdStoreData]
(SSite, Destination, ProductCode, ProductDescription, LotCode, KillDate, PackDate, DNOB, UseBy, Qty, Wgt, CSReference)

SELECT 'FC', 'Granville CS', pm.code, pm.[name], pl.code, IsNull(pk.expire2,pk.prday) AS KillDate, pk.prday AS PackDate, pk.expire3 AS DNOB,
pk.expire1 AS UseBy, COUNT(pk.id) AS QTY, SUM(pk.nominal) AS Weight, IsNull(pc.extcode,'') As ExtCode
FROM            [FM_Innova].dbo.proc_packs AS pk LEFT OUTER JOIN
                         [FM_Innova].dbo.proc_invlocations AS IL ON pk.invlocation = IL.id LEFT OUTER JOIN
                         [FM_Innova].dbo.proc_materials AS pm WITH (nolock) ON pm.material = pk.material LEFT OUTER JOIN
                         [FM_Innova].dbo.proc_collections AS pc WITH (nolock) ON pk.pallet = pc.id LEFT OUTER JOIN
                         [FM_Innova].dbo.proc_prunits AS pr WITH (nolock) ON pk.inventory = pr.prunit LEFT OUTER JOIN
                         [FM_Innova].dbo.proc_lots AS pl WITH (nolock) ON pk.lot = pl.lot
WHERE      pr.name like 'Granville Coldstore' and pc.extcode LIKE 'FYM%'
GROUP BY pm.code, pc.number, pl.code, pk.expire2, pk.prday, pk.expire1, pk.expire3, pr.name, IL.code, IsNull(pc.extcode,''), pm.[name]

Insert Into FFGData.dbo.[tblColdStoreData]
(SSite, Destination, ProductCode, ProductDescription, LotCode, KillDate, PackDate, DNOB, UseBy, Qty, Wgt, CSReference)

SELECT 'FH', 'Granville CS', pm.code, pm.[name], pl.code, IsNull(pk.expire2,pk.prday) AS KillDate, pk.prday AS PackDate, pk.expire3 AS DNOB,
pk.expire1 AS UseBy, COUNT(pk.id) AS QTY, SUM(pk.nominal) AS Weight, IsNull(pc.extcode,'') As ExtCode
FROM            [FH_innova].dbo.proc_packs AS pk LEFT OUTER JOIN
                         [FH_innova].dbo.proc_invlocations AS IL ON pk.invlocation = IL.id LEFT OUTER JOIN
                         [FH_innova].dbo.proc_materials AS pm WITH (nolock) ON pm.material = pk.material LEFT OUTER JOIN
                         [FH_innova].dbo.proc_collections AS pc WITH (nolock) ON pk.pallet = pc.id LEFT OUTER JOIN
                         [FH_innova].dbo.proc_prunits AS pr WITH (nolock) ON pk.inventory = pr.prunit LEFT OUTER JOIN
                         [FH_innova].dbo.proc_lots AS pl WITH (nolock) ON pk.lot = pl.lot
WHERE      pr.name like 'Granville Coldstore' and pc.extcode LIKE 'HLT%'
GROUP BY pm.code, pc.number, pl.code, pk.expire2, pk.prday, pk.expire1, pk.expire3, pr.name, IL.code, IsNull(pc.extcode,''), pm.[name]
ORDER BY IsNull(pc.extcode,''), PM.code, pk.prday, pl.code

Insert Into FFGData.dbo.[tblColdStoreData]
(SSite, Destination, ProductCode, ProductDescription, LotCode, KillDate, PackDate, DNOB, UseBy, Qty, Wgt, CSReference)

SELECT 'FO', 'Granville CS', pm.code, pm.[name], pl.code, IsNull(pk.expire2,pk.prday) AS KillDate, pk.prday AS PackDate, pk.expire3 AS DNOB,
pk.expire1 AS UseBy, COUNT(pk.id) AS QTY, SUM(pk.nominal) AS Weight, IsNull(pc.extcode,'') As ExtCode
FROM            [FO_innova].dbo.proc_packs AS pk LEFT OUTER JOIN
                         [FO_innova].dbo.proc_invlocations AS IL ON pk.invlocation = IL.id LEFT OUTER JOIN
                         [FO_innova].dbo.proc_materials AS pm WITH (nolock) ON pm.material = pk.material LEFT OUTER JOIN
                         [FO_innova].dbo.proc_collections AS pc WITH (nolock) ON pk.pallet = pc.id LEFT OUTER JOIN
                         [FO_innova].dbo.proc_prunits AS pr WITH (nolock) ON pk.inventory = pr.prunit LEFT OUTER JOIN
                         [FO_innova].dbo.proc_lots AS pl WITH (nolock) ON pk.lot = pl.lot
WHERE      pr.name like 'Granville Coldstore' --and pc.extcode LIKE 'HLT%'
GROUP BY pm.code, pc.number, pl.code, pk.expire2, pk.prday, pk.expire1, pk.expire3, pr.name, IL.code, IsNull(pc.extcode,''), pm.[name]
ORDER BY IsNull(pc.extcode,''), PM.code, pk.prday, pl.code

Update [dbo].[tblLRP] Set NumberIndicator = '0', TimeIndicator=GetDate() Where id=28
GO
