SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <03/05/2017>
-- Description:	<Select All from EDI_RECADV table>
-- =============================================
CREATE PROCEDURE [dbo].[EDI_RecAdv_All]
	@Customer nvarchar(20),
	@Date date
	
AS
BEGIN

Select cast([ReceiptDate] as date) as ReceiptDate
      ,[ExternalDocNo]
      ,CASE when QTY LIKE '%.%' then CONVERT(decimal(18,2),CAST(QTY as float))
	   ELSE CONVERT(bigint,CAST(QTY as float))
	   END as Quantity
	  ,[Customer]
      ,[ProductCode]
	  ,UnitOfMeasure

into #tmp
from [dbo].[EDIRecAdv]

where Customer = @Customer and ReceiptDate = @Date

Select ReceiptDate, ExternalDocNo, SUM(Quantity) as [Product Quantity],UnitOfMeasure,
	   Customer, ProductCode
from #tmp

group by ReceiptDate, ExternalDocNo, Customer, ProductCode, UnitOfMeasure

END

--exec [dbo].[EDI_RecAdv_All] '8716725999995', '20170502'
GO
