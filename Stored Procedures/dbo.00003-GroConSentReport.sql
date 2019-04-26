SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 24th July 2018
-- Description:	Generate GroCon Pallet List
-- =============================================


--exec [00003-GroConSentReport]

CREATE PROCEDURE [dbo].[00003-GroConSentReport]

AS 

		Select  SiteID, DueDate, Count(PalletNo) As FGLPalletCount,
		Case	When FileSent In('True','False') And DateSent Is Null Then 'ASN Not Sent'
				When FileSent='True' And Not DateSent Is Null Then 'ASN Sent'
				Else 'Unknown' End As AsnStatus
		From tblGroConPalletList
		Where DueDate>=GetDate()-7
		Group By [SiteID], DueDate,
		Case	When FileSent In('True','False') And DateSent Is Null Then 'ASN Not Sent'
				When FileSent='True' And Not DateSent Is Null Then 'ASN Sent'
				Else 'Unknown' End
		Order By SiteID, DueDate Desc
GO
