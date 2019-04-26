SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kelsey Brennan>
-- Create date: <11/03/2019>
-- Description:	<Sp to replicated SSRS Fresh stock report onto Power BI>
-- =============================================
CREATE PROCEDURE [dbo].[Fresh_Stock_Snapshot_BI]
AS
BEGIN
	
SELECT  

 ds.[Date]
      ,DATEPART(wk,[Date]) AS [Week]
	  ,DATEPART(YYYY,[Date]) AS [Year]
	   , CASE WHEN DATENAME(DW,[date])='Monday'
	  THEN '1-Monday'
	  WHEN DATENAME(DW,[date])='Tuesday'
	  THEN '2-Tuesday'
	  WHEN DATENAME(DW,[date])='Wednesday'
	  THEN '3-Wednesday'
	  WHEN DATENAME(DW,[date])='Thursday'
	  THEN '4-Thursday'
	  WHEN DATENAME(DW,[date])='Friday'
	  THEN '5-Friday'
	  WHEN DATENAME(DW,[date])='Saturday'
	  THEN '6-Saturday'
	  WHEN DATENAME(DW,[date])='Sunday'
	  THEN '7-Sunday'
	  END AS [Day]
	  ,ds.SiteID
	  ,CASE WHEN  ds.siteid='Fi'  THEN 'Foyle Ingredients'
	  ELSE s.[name]
	  END AS [name]
	  ,ds.[Product Code]
      ,SUM(ds.Weight) AS [Total Weight]
      ,ROUND(SUM([Value]),2) AS [Total Value GBP]
	
	  --,p.[Conservation_Name]
	  ,ds.[Product Condition]
	  ,ds.Inventory
	  ,CONCAT(ds.[Product Code],' - ',ds.[product description]) AS [Product No & Name]
	 ,CASE WHEN  DATEPART(dd,[Date])=DATEPART(dd,GETDATE()-2) AND DATEPART(YYYY,[Date])=DATEPART(yyyy,GETDATE()) AND DATEPART(M,[Date])=DATEPART(M,GETDATE())
	  THEN  ROUND(SUM([Value]),2)
	  END AS [Previous Day £]

	  ,CASE WHEN  DATEPART(dd,[Date])=DATEPART(dd,GETDATE()-2)   AND DATEPART(YYYY,[Date])=DATEPART(yyyy,GETDATE()) AND DATEPART(M,[Date])=DATEPART(M,GETDATE())
	  THEN  SUM([weight])
	  END AS [Previous Day KG]


	   ,CASE WHEN DATEPART(dd,[Date])=DATEPART(dd,GETDATE()-1)  AND DATEPART(YYYY,[Date])=DATEPART(yyyy,GETDATE()) AND DATEPART(M,[Date])=DATEPART(M,GETDATE())
	  THEN  ROUND(SUM([Value]),2)
	 END AS [Current Day £]


	  ,CASE WHEN DATEPART(dd,[Date])=DATEPART(dd,GETDATE()-1)  AND DATEPART(YYYY,[Date])=DATEPART(yyyy,GETDATE()) AND DATEPART(M,[Date])=DATEPART(M,GETDATE())
	  THEN  SUM([weight])
	  END AS [Current Day KG]

--------------------------------------------------------------------------------------------------------------------
	  ,CASE WHEN DATEDIFF(DAY,date,GETDATE()) BETWEEN 8 AND 14 AND DATENAME(DW,[date])='Sunday'
	  THEN  ROUND(SUM([Value]),2)
	  END AS [Previous Week £]

	  ,CASE WHEN DATEDIFF(DAY,date,GETDATE()) BETWEEN 8 AND 14 AND DATENAME(DW,[date])='Sunday'
	  THEN  SUM([weight])
	  END AS [Previous Week KG]

	  ,CASE WHEN DATEDIFF(DAY,date,GETDATE()) BETWEEN 0 AND 7 AND DATENAME(DW,[date])='Sunday'
	  THEN  ROUND(SUM([Value]),2)
	 END AS [Current Week £]

	 , CASE WHEN DATEDIFF(DAY,date,GETDATE()) BETWEEN 0 AND 7 AND DATENAME(DW,[date])='Sunday'
	  THEN  SUM(ds.[weight])
	  END AS [Current Week KG]
	  

	  
  FROM  [FFGData].[dbo].[Group_Fresh_Snapshot_Daily] ds
  LEFT OUTER JOIN [FFGData].[dbo].[Sites] s ON ds.[siteid] =s.ShName
  
 
 
GROUP BY 
ds.[Date]
,s.[name]
,ds.[Product Code]
,ds.SiteID
,ds.[Product Condition]
,ds.Inventory
,ds.[Product Description]
END
GO
