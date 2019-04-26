SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 19th May 2017
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [0000-UpdateTblHROrdersToAllProcessed] '122387','1','FD'

CREATE PROCEDURE [dbo].[0000-UpdateTblHROrdersProductToUnProcessed]

@OrderNo NVarChar(Max),  -- Have this passing through before going live.
@SubOrderNo NVarChar(Max), -- Have this passing through before going live.
@ProductCode NVarChar(Max)

AS

Update tblHROrders set processed='False' WHERE (OrderNo = @OrderNo) And Right(OrderSubNo,1)=@SubOrderNo And ProductCode=@ProductCode

Update tblHROrders Set Processed='True' Where (InventoryName Like 'DISPATCH%' OR InventoryName Like 'DESPATCH%')
GO
