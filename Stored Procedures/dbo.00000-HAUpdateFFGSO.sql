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

--exec [00000-HAUpdateFFGSO] '127583','1'

CREATE PROCEDURE [dbo].[00000-HAUpdateFFGSO]

@OrderNo NVarChar(Max),  
@SubOrderNo NVarChar(Max) 

AS 
	BEGIN TRY

		EXEC [00000-HAPopulateTblHrOrdersNavSalesOrder] @OrderNo, @SubOrderNo, 'FD'

	END TRY

	BEGIN CATCH

		Insert Into tblSpLog
		(DateAndTime,TransNumber,Sp,SpMessage)
		Select
		GetDate(), '0001', '[00000-HAPopulateTblHrOrdersNavSalesOrder]','[00000-HAPopulateTblHrOrdersNavSalesOrder] FD ' + @OrderNo + ' ' + @SubOrderNo 

	END CATCH

	BEGIN TRY

		EXEC [00000-HAPopulateTblHrOrdersNavSalesOrder] @OrderNo, @SubOrderNo, 'FC'

	END TRY

	BEGIN CATCH

		Insert Into tblSpLog
		(DateAndTime,TransNumber,Sp,SpMessage)
		Select
		GetDate(), '0002', '[00000-HAPopulateTblHrOrdersNavSalesOrder]','[00000-HAPopulateTblHrOrdersNavSalesOrder] FC ' + @OrderNo + ' ' + @SubOrderNo

	END CATCH

	BEGIN TRY

		EXEC [00000-HAPopulateTblHrOrdersNavSalesOrder] @OrderNo, @SubOrderNo, 'FGL'

	END TRY

	BEGIN CATCH

		Insert Into tblSpLog
		(DateAndTime,TransNumber,Sp,SpMessage)
		Select
		GetDate(), '0003', '[00000-HAPopulateTblHrOrdersNavSalesOrder]','[00000-HAPopulateTblHrOrdersNavSalesOrder] FGL ' + @OrderNo + ' ' + @SubOrderNo

	END CATCH

	BEGIN TRY

		EXEC [00000-HAPopulateTblHrOrdersNavSalesOrder] @OrderNo, @SubOrderNo, 'FH'

	END TRY

	BEGIN CATCH

		Insert Into tblSpLog
		(DateAndTime,TransNumber,Sp,SpMessage)
		Select
		GetDate(), '0004', '[00000-HAPopulateTblHrOrdersNavSalesOrder]','[00000-HAPopulateTblHrOrdersNavSalesOrder] FH ' + @OrderNo + ' ' + @SubOrderNo

	END CATCH

	BEGIN TRY

		EXEC [00000-HAPopulateTblHrOrdersNavSalesOrder] @OrderNo, @SubOrderNo, 'FO'

	END TRY

	BEGIN CATCH

		Insert Into tblSpLog
		(DateAndTime,TransNumber,Sp,SpMessage)
		Select
		GetDate(), '0005', '[00000-HAPopulateTblHrOrdersNavSalesOrder]','[00000-HAPopulateTblHrOrdersNavSalesOrder] FO ' + @OrderNo + ' ' + @SubOrderNo

	END CATCH
GO
