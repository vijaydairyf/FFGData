SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Benjamin Aranyi
-- Create date: 2018/07/26
-- Description:	Return records of sent files
-- =============================================
CREATE PROCEDURE [dbo].[00003-GroConReturnSentFiles]
		@Site nvarchar (20),
		@Offset int
AS
BEGIN
	SELECT [ID], [DueDate], [SiteID], [ItemNo], [PalletNo], [Units], [Wgt], [FileSent], [DateSent], [ASN]
    FROM [FFGData].[dbo].[tblGroConPalletList]
    WHERE [FileSent] = 1
	AND [SiteID] = @Site
	AND [DateSent] IS NOT NULL
	AND CAST(DateSent AS DATE) = DATEADD(DAY, -@Offset, CAST(GETDATE() AS DATE))
END
GO
