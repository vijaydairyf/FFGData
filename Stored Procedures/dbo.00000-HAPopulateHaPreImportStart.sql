SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [00000-HAPopulateHaPreImportStart] '127683','1','FGL'

CREATE PROCEDURE [dbo].[00000-HAPopulateHaPreImportStart]

@OrderNo NVarChar(Max),  -- Have this passing through before going live.
@SubOrderNo NVarChar(Max), -- Have this passing through before going live.
@FFGSite NVarChar(Max)

AS 

		Exec [00000-HAPopulateHaPreImportHeaders] @OrderNo, @SubOrderNo, @FFGSite

		Declare @ID int

		Declare @Nav NVarChar(50)

		Declare @RowNum int

		Declare FileList Cursor For Select Top 999 FFGSO From [dbo].[HaPreImportHeader] Where OrderNo=@OrderNo And SubOrderNo=@SubOrderNo And SiteID=@FFGSite And Not OrderStatus='Shipped' ORDER BY id

		OPEN FileList 

		FETCH NEXT FROM FileList Into @Nav

		Set @RowNum = 0

			WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @RowNum=@RowNum+1

						Delete From HaPreImport Where [Order No_] = @Nav 

						Exec  [00000-HAPopulateHaPreImport] @Nav

						Update [dbo].[HaPreImportHeader] Set OrderStatus='Sent To Innova' Where FFGSO=@Nav

						Update [dbo].[tblHROrders] Set NavLocation='Sent To Innova' Where NavSalesOrder=@Nav

					FETCH NEXT FROM FileList INTO @Nav

				END

		CLOSE FileList
		DEALLOCATE FileList
GO
