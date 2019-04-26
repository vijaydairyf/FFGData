SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 24th October 2018
-- Description:	Open Order on relevant Innova 
-- =============================================

--exec [13748-GetNewOrderDetails]  '1190129576'

CREATE PROCEDURE [dbo].[13748-GetNewOrderDetails]

	@ExistingOrder BigInt

AS

	Select Top 1 ID, OriginalOrder, NewOrder, Supplier, KillDate
 
	From [FFGSQL03].[FFGDATA].[DBO].[13748-CreateOrder]

	Where OriginalOrder=@ExistingOrder
	
	Order By ID Desc
GO
