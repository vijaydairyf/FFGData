SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 27 06 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [00000-HAStatusTotalsColor]

CREATE PROCEDURE [dbo].[00000-HAStatusTotalsColor]

As 

Declare @HAProgress Table
(
OrderNo NVarChar(25),
SubOrder NVarChar(25),
SSite NVarChar(10),
NavSalesOrder NVarChar(100),
ProductCode NVarChar(100),
ProductDescription NVarChar(100),
AllocatedQty Int,
InnovaOrderedQty Int,
InnovaScannedQty Int,
A2SDifference Int
)

		Declare @ID int

		Declare @OrderNo NVarChar(50), @SubOrderNo NVarChar(50)

		Declare @RowNum int

		Declare FileList Cursor For Select Top 999 GroupOrderNo, SubOrder From [dbo].[tblHROrdersHeader] Where Tracker='True' ORDER BY id

		OPEN FileList 

		FETCH NEXT FROM FileList Into @OrderNo, @SubOrderNo

		Set @RowNum = 0

			WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @RowNum=@RowNum+1

					Insert into @HAProgress
						exec [00000-HAStatusFC] @OrderNo,@SubOrderNo,'FC'

					Insert into @HAProgress
						exec [00000-HAStatusFO] @OrderNo,@SubOrderNo,'FO'

					Insert into @HAProgress
						exec [00000-HAStatusFH] @OrderNo,@SubOrderNo,'FH'

					Insert into @HAProgress
						exec [00000-HAStatusFGL] @OrderNo,@SubOrderNo,'FGL'

					Insert into @HAProgress
						exec [00000-HAStatusFD] @OrderNo,@SubOrderNo,'FD'

					FETCH NEXT FROM FileList INTO @OrderNo, @SubOrderNo

				END

		CLOSE FileList
		DEALLOCATE FileList

select OrderNo, SubOrder, SSite, NavSalesOrder, Sum(AllocatedQty) 'Allocated', Sum(InnovaScannedQty) 'Scanned', Sum(A2SDifference) 'Difference',
Cast(Round(Cast(Cast(Sum(InnovaScannedQty) As Decimal(18,4))*1 As Decimal(18,4)) / Cast(Cast(Sum(AllocatedQty) As Decimal(18,4))/100 As Decimal(18,4)),0) As Int) As 'PerComplete',
Case 
When Sum(A2SDifference) = 0 Then 'GREEN' 
When (Sum(InnovaScannedQty) > 0 And Sum(A2SDifference) <> 0) Then 'AMBER' 
When (Sum(InnovaScannedQty) = 0 And Sum(A2SDifference) = Sum(AllocatedQty) ) Then 'RED' 
When (Sum(InnovaOrderedQty) = 0 And Sum(AllocatedQty) > 0 ) Then 'BLACK' 
End As ColorStatus

From @HAProgress
Group By OrderNo, SubOrder, SSite, NavSalesOrder
order by PerComplete
--exec [00000-HAStatusTotalsColor]
GO
