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
--exec [00003-GroConReadyToSendList] 'FGL', 5

CREATE PROCEDURE [dbo].[00003-GroConReadyToSendList]

@Site As NVarChar(20),
@DateOffSet As Int

AS 

		DECLARE @Date DATE 

		SET @Date = CAST(GETDATE()-@DateOffSet AS smalldatetime)

		Select ID, SiteID, CONVERT(VARCHAR(10), DueDate, 103) As DueDate, ItemNo As 'MainItem', PalletNo, Units, Wgt
		From tblGroConPalletList
		Where FileSent='True' And DateSent Is Null AND SiteID=@Site
GO
