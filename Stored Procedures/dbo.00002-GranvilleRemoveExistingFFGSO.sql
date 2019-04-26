SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [00002-GranvilleRemoveExistingFFGSO] ' FFGSO309275'

CREATE PROCEDURE [dbo].[00002-GranvilleRemoveExistingFFGSO]

@FFGSO NVarChar(Max)

AS 

DELETE FROM tblExternalData Where RTrim(Ltrim(FFGReference)) = RTrim(Ltrim(@FFGSO))
GO
