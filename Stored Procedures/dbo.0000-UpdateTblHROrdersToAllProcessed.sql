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

CREATE PROCEDURE [dbo].[0000-UpdateTblHROrdersToAllProcessed]

@OrderNo NVarChar(Max),  -- Have this passing through before going live.
@SubOrderNo NVarChar(Max) -- Have this passing through before going live.

AS

Update tblHROrders set processed='True'
--Select * From tblHROrders
WHERE (OrderNo = @OrderNo) And Right(OrderSubNo,1)=@SubOrderNo
GO
