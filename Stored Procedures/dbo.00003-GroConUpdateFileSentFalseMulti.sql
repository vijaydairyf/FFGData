SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		Benjamin Aranyi
-- Create date: 8th August 2018
-- Description:	Generate GroCon Pallet List
-- =============================================

Create PROCEDURE [dbo].[00003-GroConUpdateFileSentFalseMulti]

@Site As NVarChar(20),
@PalletNo As NVarChar(30)

AS 

		Update tblGroConPalletList
		Set FileSent='False' 
		Where PalletNo=@PalletNo And FileSent='True'
GO
