SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Benjamin Aranyi
-- Create date: 2018/08/29
-- Description:	Return records of sent files Updated
-- =============================================

CREATE PROCEDURE [dbo].[00003-GroConReturnSentFilesNew]
		@Site nvarchar (20),
		@Offset int
		
AS
BEGIN
	IF @Site='FGL'
		BEGIN
			SELECT gpl.[ID], [DueDate], [SiteID], [ItemNo], [PalletNo],gpl.[Units], [Wgt], [FileSent], [DateSent], [ASN], [name] AS [Product], pri.[code]
			FROM [FFGData].[dbo].[tblGroConPalletList] gpl
			LEFT JOIN [FG_innova].dbo.[proc_materials] pm ON gpl.ItemNo = pm.[code]
			LEFT JOIN [FG_innova].[dbo].[proc_collections] pl ON pl.[number] = gpl.[PalletNo]
			LEFT JOIN [FG_innova].[dbo].[proc_invlocations]pri ON  pl.[invlocation] = pri.[id]
			WHERE [FileSent] = 1
			AND [SiteID] = @Site
			AND [DateSent] IS NOT NULL
			AND CAST(DateSent AS DATE) = DATEADD(DAY, -@Offset, CAST(GETDATE() AS DATE))
		END

	IF @Site='FMM'
		BEGIN
			SELECT gpl.[ID], [DueDate], [SiteID], [ItemNo], [PalletNo], gpl.[Units], [Wgt], [FileSent], [DateSent], [ASN], [name] AS [Product], pri.[code]
			FROM [FFGData].[dbo].[tblGroConPalletList] gpl
			LEFT JOIN [FMM_innova].dbo.[proc_materials] pm ON gpl.ItemNo = pm.[code]
			LEFT JOIN [FMM_innova].[dbo].[proc_collections] pl ON pl.[number] = gpl.[PalletNo]
			LEFT JOIN [FMM_innova].[dbo].[proc_invlocations]pri ON  pl.[invlocation] = pri.[id]
			WHERE [FileSent] = 1
			AND [SiteID] = @Site
			AND [DateSent] IS NOT NULL
			AND CAST(DateSent AS DATE) = DATEADD(DAY, -@Offset, CAST(GETDATE() AS DATE))
		END
END
GO
