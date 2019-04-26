SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--Truncate Table tblHrOrders

--exec [00000-HAGenerateOrderLines] '127583','1','UK'

CREATE PROCEDURE [dbo].[00000-HAGenerateOrderLines]

@OrderNo NVarChar(Max),  
@SubOrderNo NVarChar(Max),
@Country NVarChar(50) 

AS 

IF @Country='IRE'
	BEGIN TRY

		EXEC [00000-HAPopulateTblHrOrders] @OrderNo, @SubOrderNo, 'FD'

	END TRY

	BEGIN CATCH

		Insert Into tblSpLog
		(DateAndTime,TransNumber,Sp,SpMessage)
		Select
		GetDate(), '0001', '[00000-HAPopulateTblHrOrders]','[00000-HAPopulateTblHrOrders] FD ' + @OrderNo + ' ' + @SubOrderNo + ' ' + @Country

	END CATCH

IF @Country='UK'
	BEGIN TRY

		EXEC [00000-HAPopulateTblHrOrders] @OrderNo, @SubOrderNo, 'FC'

	END TRY

	BEGIN CATCH

		Insert Into tblSpLog
		(DateAndTime,TransNumber,Sp,SpMessage)
		Select
		GetDate(), '0002', '[00000-HAPopulateTblHrOrders]','[00000-HAPopulateTblHrOrders] FC ' + @OrderNo + ' ' + @SubOrderNo + ' ' + @Country

	END CATCH

	BEGIN TRY

		EXEC [00000-HAPopulateTblHrOrders] @OrderNo, @SubOrderNo, 'FGL'

	END TRY

	BEGIN CATCH

		Insert Into tblSpLog
		(DateAndTime,TransNumber,Sp,SpMessage)
		Select
		GetDate(), '0003', '[00000-HAPopulateTblHrOrders]','[00000-HAPopulateTblHrOrders] FGL ' + @OrderNo + ' ' + @SubOrderNo + ' ' + @Country

	END CATCH

	BEGIN TRY

		EXEC [00000-HAPopulateTblHrOrders] @OrderNo, @SubOrderNo, 'FH'

	END TRY

	BEGIN CATCH

		Insert Into tblSpLog
		(DateAndTime,TransNumber,Sp,SpMessage)
		Select
		GetDate(), '0004', '[00000-HAPopulateTblHrOrders]','[00000-HAPopulateTblHrOrders] FH ' + @OrderNo + ' ' + @SubOrderNo + ' ' + @Country

	END CATCH

	BEGIN TRY

		EXEC [00000-HAPopulateTblHrOrders] @OrderNo, @SubOrderNo, 'FO'

	END TRY

	BEGIN CATCH

		Insert Into tblSpLog
		(DateAndTime,TransNumber,Sp,SpMessage)
		Select
		GetDate(), '0005', '[00000-HAPopulateTblHrOrders]','[00000-HAPopulateTblHrOrders] FO ' + @OrderNo + ' ' + @SubOrderNo + ' ' + @Country

	END CATCH
GO
