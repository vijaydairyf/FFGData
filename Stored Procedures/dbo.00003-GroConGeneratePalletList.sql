SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 24th July 2018
-- Description:	Generate GroCon Pallet List
-- =============================================

--Truncate Table tblGroConPalletList
--exec [00003-GroConGeneratePalletList] 'FGL', 0
--exec [00003-GroConGeneratePalletList] 'FMM', 5

CREATE PROCEDURE [dbo].[00003-GroConGeneratePalletList]

@Site As NVarChar(20),
@DateOffSet As Int

AS 

		DECLARE @Date DATE 
		DECLARE @InventoryNo INT

		SET @Date = CAST(GETDATE()-@DateOffSet AS Date)	

		Delete
		FROM            tblGroConPalletList
		WHERE        (FileSent = 'False') AND (DateSent IS NULL) AND (ASN IS NULL) AND (RECADV IS NULL) And SiteID=@Site

		IF @Site='FGL'
			BEGIN	
				Select Top 1 @InventoryNo=PrUnit From [FG_innova].dbo.[proc_prunits] Where [Name]='Grocontinental In-Transit'

				Insert Into tblGroConPalletList
				(DueDate, SiteID, ItemNo, PalletNo, Units, Wgt)
		
				SELECT --@Date AS [DueDate], 
				CAST(pc.invtime AS Date) InvTime, @Site AS [Site], 
				Min(pm.[code]) AS [ItemNo], pc.[number] AS [PalletNo], COUNT(pc.[units]) AS [Units], SUM(ROUND(pp.[nominal],2)) AS [Weight]
				FROM [FG_innova].dbo.[proc_collections] pc
				LEFT JOIN [FG_innova].dbo.[proc_packs] pp ON pc.[id] = pp.[pallet]
				INNER JOIN [FG_innova].dbo.[proc_materials] pm ON pp.[material] = pm.[material]
				LEFT JOIN [FFGDATA].DBO.[tblGroConPalletList] g On pc.number=g.PalletNo And g.[SiteID]=@Site  
					And
					(SELECT COUNT(pc.[units]) AS [Units] FROM [FG_innova].dbo.[proc_collections] pc
						LEFT JOIN [FG_innova].dbo.[proc_packs] pp ON pc.[id] = pp.[pallet]
						INNER JOIN [FG_innova].dbo.[proc_materials] pm ON pp.[material] = pm.[material]
						WHERE pc.inventory = @InventoryNo AND CAST(pc.invtime AS Date) = @Date And pc.number=g.PalletNo And g.[SiteID]=@Site 
						GROUP BY  pc.[number])=g.Units
				WHERE pc.inventory = @InventoryNo 
				AND CAST(pc.invtime AS Date) = @Date --AND pp.rstat != -2
				And g.PalletNo Is Null 
				--And g.FileSent Is Null Or g.FileSent=''
				GROUP BY  pc.[number],CAST(pc.invtime AS Date)
				ORDER BY pc.[number];

			END

		IF @Site='FMM'
			BEGIN	
				Select Top 1 @InventoryNo=PrUnit From [FMM_innova].dbo.[proc_prunits] Where [Name]='Grocontinental In-Transit'

				Insert Into tblGroConPalletList
				(DueDate, SiteID, ItemNo, PalletNo, Units, Wgt)
		
				SELECT --@Date AS [DueDate], 
				CAST(pc.invtime AS Date) InvTime, @Site AS [Site], 
				Min(pm.[code]) AS [ItemNo], pc.[number] AS [PalletNo], COUNT(pc.[units]) AS [Units], SUM(ROUND(pp.[nominal],2)) AS [Weight]
				FROM [FMM_innova].dbo.[proc_collections] pc
				LEFT JOIN [FMM_innova].dbo.[proc_packs] pp ON pc.[id] = pp.[pallet]
				INNER JOIN [FMM_innova].dbo.[proc_materials] pm ON pp.[material] = pm.[material]
				LEFT JOIN [FFGDATA].DBO.[tblGroConPalletList] g On pc.number=g.PalletNo And g.[SiteID]=@Site  
					And
					(SELECT COUNT(pc.[units]) AS [Units] FROM [FMM_innova].dbo.[proc_collections] pc
						LEFT JOIN [FMM_innova].dbo.[proc_packs] pp ON pc.[id] = pp.[pallet]
						INNER JOIN [FMM_innova].dbo.[proc_materials] pm ON pp.[material] = pm.[material]
						WHERE pc.inventory = @InventoryNo AND CAST(pc.invtime AS Date) = @Date And pc.number=g.PalletNo And g.[SiteID]=@Site 
						GROUP BY  pc.[number])=g.Units
				WHERE pc.inventory = @InventoryNo 
				AND CAST(pc.invtime AS Date) = @Date --AND pp.rstat != -2
				And g.PalletNo Is Null 
				--And g.FileSent Is Null Or g.FileSent=''
				GROUP BY  pc.[number],CAST(pc.invtime AS Date)
				ORDER BY pc.[number];
			END


		;With CTE As
			(Select a.ID From tblGroConPalletList a  Where a.id <(Select Top (1) b.ID From tblGroConPalletList b Where b.PalletNo=a.PalletNo AND SiteID=@Site Order By b.id desc)) 
		Delete From CTE;


		Select ID, SiteID, CONVERT(VARCHAR(10), DueDate, 103) As DueDate, ItemNo As 'MainItem', PalletNo, Units, Wgt
		From tblGroConPalletList
		Where FileSent='False' AND SiteID=@Site And CONVERT(VARCHAR(10), DueDate, 103)=CONVERT(VARCHAR(10), @Date, 103)
GO
