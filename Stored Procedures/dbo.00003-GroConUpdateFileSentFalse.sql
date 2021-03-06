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

CREATE PROCEDURE [dbo].[00003-GroConUpdateFileSentFalse]

@Site As NVarChar(20),
@DateOffSet As Int

AS 

		DECLARE @Date DATE 

		SET @Date = CAST(GETDATE()-@DateOffSet AS smalldatetime)

		Update tblGroConPalletList
		Set FileSent='False' 
		Where CONVERT(VARCHAR(10), DueDate, 103)=CONVERT(VARCHAR(10), @Date, 103) AND SiteID=@Site And FileSent='True' 
		And DateSent Is Null 
GO
