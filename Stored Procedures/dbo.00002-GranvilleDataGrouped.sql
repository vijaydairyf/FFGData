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

--exec [00002-GranvilleDataGrouped]

CREATE PROCEDURE [dbo].[00002-GranvilleDataGrouped]

AS 

SELECT  SSite, Destination, ProductCode, ProductDescription,  CSReference, Sum(Qty) As 'Qty', Sum(Wgt) As 'Wgt'
FROM            tblColdStoreData
Group By SSite, Destination, ProductCode, ProductDescription,  CSReference
Order by CSReference
GO
