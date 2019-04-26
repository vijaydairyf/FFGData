SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <18/04/19>
-- Description:	<HMZ Pallet Sheet>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_HMZ_PalletSheet]

--exec [dbo].[usrrep_HMZ_PalletSheet] '384598'
	
@Palletnumber NVARCHAR(15)

AS
BEGIN


SELECT DISTINCT pp.expire2 AS Killdate, pp.prday AS packdate, pp.expire1 AS useby, pc.number AS palletnumber, pm.description1 AS product, CAST(pc.gross AS DECIMAL(18,2)) AS GROSS
, CAST(pc.nominal AS DECIMAL(18,2)) AS Nominal, pco.[name] AS [bornin/rearedin] , bco.code AS slaughteredin, (bco2.[name]+ ' '+ bco2.code) AS Producer, bco3.code AS BonedIn

FROM [FO_Innova].[dbo].proc_packs AS pp
LEFT JOIN [FO_Innova].[dbo].proc_collections AS pc WITH (NOLOCK) ON pc.id = pp.pallet
LEFT JOIN [FO_Innova].[dbo].proc_materials AS pm WITH (NOLOCK) ON pm.material = pp.material
LEFT JOIN [FO_Innova].[dbo].proc_lots AS pl WITH (NOLOCK) ON pl.lot = pp.lot
LEFT JOIN [FO_Innova].[dbo].proc_countries AS pco WITH (NOLOCK) ON pco.country = pl.brcountry
LEFT JOIN [FO_Innova].[dbo].base_companies AS bco WITH (NOLOCK) ON bco.company = pl.slhouse
LEFT JOIN [FO_Innova].[dbo].base_companies AS bco2 WITH (NOLOCK) ON bco2.company = pl.processor
LEFT JOIN [FO_Innova].[dbo].base_companies AS bco3 WITH (NOLOCK) ON bco3.company = pl.customer


WHERE pc.number = @Palletnumber


END
GO
