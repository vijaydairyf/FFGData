SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [00000-HAInProduction] '127663','1','FGL'

CREATE PROCEDURE [dbo].[00000-HAInProduction]

@OrderNo NVarChar(Max), 
@SubOrderNo NVarChar(Max), 
@FFGSite NVarChar(Max)

AS

SELECT   ProductCode, 

Count(InProductionStock) As QtyInProduction
FROM            [ffgbi-serv].[ffg_dw].dbo.HR_Order_Allocation
WHERE   OrderNo=@OrderNo And SubOrderNo=@SubOrderNo  And InProductionStock='1' 
And Case When SiteID=1 Then 'FC'	When SiteID=2 Then 'FO'	When SiteID=3 Then 'FH'
When SiteID=4 Then 'FD'	When SiteID=5 Then 'FGL'	When SiteID=6 Then 'FMM' END =@FFGSite

Group By OrderNo, SubOrderNo, ProductCode, SiteID
Order by ProductCode
GO
