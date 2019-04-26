SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <21/04/2017>
-- Description:	<Group Report for Yield>
-- =============================================

--exec [RPT_GroupYieldReport] '05/25/2017','05/25/2017','Foyle Omagh'

CREATE PROCEDURE [dbo].[RPT_GroupYieldReport] 
			--Input Variables
		@BeginDate datetime,
		@EndDate datetime,
		@Site nvarchar(100)
		--,@_Lots nvarchar(max)
		
AS

BEGIN
/* into boning for yeild */

Select	ProductCode as [Into Boning Code], ProductDescription as [Into Boning Description], LotName as [Into Boning Name], Count(ProductCode) as [Into Boning QTY],
		CAST(SUM(xactweight) as decimal (10,2)) as [Into Boning Weight], LotCode as [Into Boning Lots]--, XactPathDescription, XactRtype, StockSite,  XactProductionDate

from	tblItems

where	CAST(XactProductionDate as date) BETWEEN @BeginDate and @EndDate
		and ProductCode IS NOT NULL
		and XactPathDescription = 'BoneIn'
		and XactRtype = '1'
		and StockSite = @Site
		--and LotName = @_Lots
	

group by	ProductCode, ProductDescription, LotName, LotCode--, XactPathDescription, XactRtype, StockSite, XactProductionDate

order by ProductCode, LotCode asc

END
GO
