SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Joe Maguire>
-- Create date: <Create Date,,2018-12-04>
-- Description:	<Description,,Group pallet movement report>
-- =============================================

--exec [DBO].[usrrep_PalletMovement_Group] 'FI','12/04/18','125 : FI de-canting'
CREATE PROCEDURE [dbo].[usrrep_PalletMovement_Group]
	-- Add the parameters for the stored procedure here
	@Site char(3),
	@Date date,
	@IntoInventory nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF @Site = 'FO'
	BEGIN
	EXEC [FO_Innova].[dbo].[usrrep_FO_PalletMovement] @Date,@IntoInventory
	END

	IF @Site = 'FI'
	BEGIN
	  SELECT 					PM.code, PM.description1, PC.number AS [Pallet No], PP.inventory,
									PR.name AS [Inventory Name],Cast(Sum (PP.[weight]) as decimal (10,2)) As [Weight], COUNT(PP.id) AS Qty
	
	FROM					[FI_Innova].[dbo].proc_packs AS PP 
							INNER JOIN [FI_Innova].[dbo].proc_materials AS PM with(nolock) ON PP.material = PM.material
							INNER JOIN [FI_Innova].[dbo].proc_collections AS PC with(nolock) ON PP.pallet = PC.id
							INNER JOIN [FI_Innova].[dbo].proc_prunits AS PR with(nolock) ON PP.inventory = PR.prunit
	
	CROSS APPLY 
					(SELECT TOP (1)				PX.regtime, PX.subjectid 
					 FROM						[FI_Innova].[dbo].proc_coxacts AS PX 
					 WHERE						PX.[collection] = PC.id and PX.xacttype = 1
					 ORDER BY					Px.regtime DESC) AS CA
	
											 
	
	WHERE					convert(nvarchar(12),CA.regtime,102) =  convert(nvarchar(12),@Date,102) and CA.subjectid = @IntoInventory
							
	
	GROUP BY				PM.code, PM.description1, PC.number, PP.inventory, PR.name
	
	ORDER BY				pc.number
	END

END
GO
