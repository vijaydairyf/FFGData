SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- 118446
--exec [usr_GetCanadaShipmentDetails_FO] '3656'
CREATE PROCEDURE [dbo].[usr_GetCanadaShipmentDetails_FO]

	@ponumber NVARCHAR(15)


AS
BEGIN
	

	declare @shipmark nvarchar(15)

	set @shipmark = (Select MAX(pl.description5) 
					from [FO_Innova].[dbo].proc_orders as po 
					left join [FO_Innova].[dbo].proc_orderl as pl with (nolock) on pl.[order] = po.[order] 
					left join [FFGSQL02].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] as sh with (nolock) on sh.[Order No_] collate database_default = PO.[name]
					where sh.[External Document No_] = @ponumber)

		SELECT 
		PM.description1 AS [Description],
		CONCAT(BC1.code, ' , ', BC1.name) AS SlaughteredAddress, 
		CONCAT(BC2.code, ' , ', BC2.name) AS ManufacturedAddress,
		SUM(PP.nominal) AS [Weight],
		@shipmark as [Shipment_Mark],
		po.[name] as FFGSONumber, 
		'N/A' AS [ColdStore],
		'VACUM PACKED BOX SHRINK WRAPPED AND PALLETISED' as [TypeOfPackage],
		BS.[name] AS [Site]
		,count(1) as QTY
		
	FROM [FFGSQL03].FO_Innova.[dbo].[vw_OrderswithNoXML] PO (nolock) 
	left join [FFGSQL02].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] as sh with (nolock) on sh.[Order No_] collate database_default = PO.[name]

	left JOIN 
		[FFGSQL03].FO_Innova.dbo.proc_packs PP (nolock) ON  PP.[order] = PO.[order]
	left JOIN
		[FFGSQL03].FO_Innova.[dbo].[vw_matswithNoXML] PM(nolock)  ON PM.material = PP.material
	left JOIN
		[FFGSQL03].FO_Innova.[dbo].[vw_LotswithNoXML] PL(nolock)  ON PP.lot = PL.lot
	left JOIN 
		[FFGSQL03].FO_Innova.dbo.base_companies BC1(nolock)  ON PL.slhouse = BC1.company
	left JOIN
		[FFGSQL03].FO_Innova.dbo.base_companies BC2 (nolock) ON PL.processor = BC2.company
	left JOIN
		[FFGSQL03].FO_Innova.[dbo].[base_sites] BS (nolock) ON BC1.[name] = BS.[name]

	WHERE 
		sh.[External Document No_] = @ponumber AND sh.No_ <> 'FFGDES252573'
		
		group by pm.description1,bc1.code,bc1.[name],bc2.code,bc2.[name],po.[name],bs.[name]
		
	
		
END









GO
