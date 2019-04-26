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
--exec [00003-GroConUpdateFileSentFalse] 'FGL', 0

CREATE PROCEDURE [dbo].[00003-GroConUpdateFileSentFalseSingle]

@Site As NVarChar(20),
@ID As Int

AS 

		Update tblGroConPalletList
		Set FileSent='False' 
		Where ID=@ID And FileSent='True'
GO
