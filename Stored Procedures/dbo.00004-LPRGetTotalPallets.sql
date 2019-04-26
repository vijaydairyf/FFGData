SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Get Total Pallets
-- =============================================


--exec [00004-LPRGetTotalPallets]

CREATE PROCEDURE [dbo].[00004-LPRGetTotalPallets]

AS 

Select Sum(Cast(Quantity As int)) As TotalPalletQty From tblLPRPallets Where Ignore='False'
GO
