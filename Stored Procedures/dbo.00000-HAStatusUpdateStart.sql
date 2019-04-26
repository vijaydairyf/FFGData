SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [00000-HAStatusUpdateStart]

CREATE PROCEDURE [dbo].[00000-HAStatusUpdateStart]

AS 

		Declare @ID int

		Declare @Order NVarChar(50), @SubOrder NVarChar(10), @SiteID NVarChar(10)

		Declare @RowNum int

		Declare FileList Cursor For Select Top 999 GroupOrderNo, SubOrder, SiteID From [dbo].[tblHROrdersHeader] Where Tracker='True' ORDER BY id

		OPEN FileList 

		FETCH NEXT FROM FileList Into @Order, @SubOrder, @SiteID

		Set @RowNum = 0

			WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @RowNum+=1

						IF @SiteID='IRE'
							BEGIN
								Exec  [00000-HAOrderStatusUpdate] @Order, @SubOrder, 'FD'
							END

						IF @SiteID='UK'
							BEGIN
								Exec  [00000-HAOrderStatusUpdate] @Order, @SubOrder, 'FC'

								Exec  [00000-HAOrderStatusUpdate] @Order, @SubOrder, 'FH'

								Exec  [00000-HAOrderStatusUpdate] @Order, @SubOrder, 'FO'
							END


					FETCH NEXT FROM FileList INTO @Order, @SubOrder, @SiteID

				END

		CLOSE FileList
		DEALLOCATE FileList
GO
