SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[0803_Group_ItemRecon_Detail_FO]
AS
BEGIN

DECLARE @Start DATE
DECLARE @End DATE

SET @Start = GETDATE()
--DATEADD(dd, -(DATEPART(dw, GETDATE())), CAST(GETDATE() AS DATE)) 
--SELECT @Start
-- GETDATE()-6
SET @End = GETDATE()
--DATEADD(dd, 7-(DATEPART(dw, GETDATE())), CAST(GETDATE() AS DATE))
--SELECT @End
-- GETDATE()-1

DECLARE @t TABLE(
groupingname NVARCHAR(250),
SiteName NVARCHAR(50),
itemid INT,
itemwgt DECIMAL(10,2),
itemval DECIMAL(10,2),
regtime DATETIME
)

INSERT INTO @t
(
    groupingname
  , SiteName
  , itemid
  , itemwgt
  , itemval
  ,regtime
)

    --produced
    SELECT '01-Produced'                                       AS [Grouping]
         , s.[name]                                            AS [Site]
         , i.number                                   AS itemid
         , i.[weight]            AS itemwgt
         , i.[weight] * m.[value] AS itemval
		 ,i.regtime AS Regtime
    FROM FO_Innova.dbo.proc_items                 i
        INNER JOIN FO_Innova.dbo.proc_materials   m
            ON m.material = i.material
        INNER JOIN FO_Innova.dbo.proc_individuals id
            ON id.id = i.individual
        INNER JOIN FO_Innova.dbo.base_sites       s
            ON i.site = s.site
    WHERE id.slday
          BETWEEN CONVERT(NVARCHAR(12), @Start, 102) AND CONVERT(NVARCHAR(12), @End, 102)
          AND m.[name] NOT IN ( 'Side 1', 'Side 2' )
          AND SUBSTRING(m.code, 1, 4) = '1014'
          AND NOT i.extnum IS NULL

	UNION 
   ----purchased
    SELECT '02-Purchased'                                      AS [Grouping]
         , s.[name]                                            AS [Site]
         , i.number                                    AS QtrQty
         , i.[weight]              AS QtrWgtTotal
         , i.[weight] * m.[value]  AS QtrValTotal
		 ,i.regtime AS Regtime
    FROM FO_Innova.dbo.proc_items                i
        INNER JOIN FO_Innova.dbo.proc_materials  m
            ON m.material = i.material
        LEFT JOIN FO_Innova.dbo.proc_individuals id
            ON id.id = i.individual
        INNER JOIN FO_Innova.dbo.base_sites      s
            ON i.site = s.site
    WHERE CONVERT(NVARCHAR(12),i.regtime,102)
          BETWEEN CONVERT(NVARCHAR(12), @Start, 102) AND CONVERT(NVARCHAR(12), @End, 102)
          AND m.[name] NOT IN ( 'Side 1', 'Side 2' )
          AND SUBSTRING(i.extcode, 1, 1) <> 3
		  AND s.name <> 'Foyle Omagh' --AND SUBSTRING(m.code,1,4)='1014' AND NOT i.extnum IS NULL
   

	UNION
    
    --into boning
    SELECT '03-Into Boning'                                        AS [Grouping]
         , s.[name]                                             AS [Site]
         , ix.item                                      AS QtrsIntoBoningQty
         , ix.[weight]             AS QtrWgtIntoBoning
         , ix.[weight] * m.[value] AS QtrValIntoBoning
		 , ix.regtime AS regtime
    FROM FO_Innova.dbo.proc_matxacts            ix
        INNER JOIN FO_Innova.dbo.proc_xactpaths xp
            ON ix.xactpath = xp.xactpath
        INNER JOIN FO_Innova.dbo.proc_materials m
            ON m.material = ix.material
        INNER JOIN FO_Innova.dbo.proc_items     i
            ON ix.item = i.id
        INNER JOIN FO_Innova.dbo.base_sites     s
            ON i.site = s.site
    WHERE CONVERT(NVARCHAR(12),ix.regtime,102)
          BETWEEN CONVERT(NVARCHAR(12), @Start, 102) AND CONVERT(NVARCHAR(12), @End, 102)
          AND ix.xactpath IN ( 1, 178 )
          AND ix.rtype = 1 --AND ix.item = 2537895
    

	UNION
    
    --No Kill
    SELECT '04-No Kill'                                            AS [Grouping]
         , 'Foyle Omagh'                                        AS [Site]
         , ix.id                                     AS NoKillQtrQty
         , ix.[weight]            AS QtrWgtNoKill
         , ix.[weight] * m.[value] AS QtrValNoKill
		 ,ix.regtime AS regtime
    FROM FO_Innova.dbo.proc_matxacts           ix
        LEFT JOIN FO_Innova.dbo.proc_materials m
            ON m.material = ix.material
        LEFT JOIN FO_Innova.dbo.proc_items     i
            ON ix.item = i.id
        LEFT JOIN FO_Innova.dbo.base_sites     s
            ON i.site = s.site
    WHERE CONVERT(NVARCHAR(12),ix.regtime,102)
          BETWEEN CONVERT(NVARCHAR(12), @Start, 102) AND CONVERT(NVARCHAR(12), @End, 102)
		  AND i.id IS NULL AND ix.xactpath = 1
		  AND m.code NOT LIKE '%9999%'
          --AND ix.cday IS NOT NULL

		  UNION
          


    --Sold
    SELECT '05-Sold'                                              AS [Grouping]
         , s.[name]
         , i.id                                        AS SoldQtrQty
         , i.[weight]             AS QtrWgtSold
         , i.[weight] * m.[value] AS QtrValSold
		 ,i.regtime AS Regtime
    FROM FO_Innova.dbo.proc_items               i
        INNER JOIN FO_Innova.dbo.proc_orders    o
            ON o.[order] = i.[order]
        INNER JOIN FO_Innova.dbo.proc_materials m
            ON i.material = m.material
        INNER JOIN FO_Innova.dbo.base_sites     s
            ON s.site = i.site
    WHERE i.inventory IN (4)
          AND CONVERT(NVARCHAR(12), o.dispatchtime, 102)
         BETWEEN CONVERT(NVARCHAR(12), @Start, 102) AND CONVERT(NVARCHAR(12), @End, 102)
   
	
	UNION 
      --Broken
	SELECT '06-Breakdown' AS [Grouping],
			s.[name],
			i.id AS Qty, i.[weight] AS QtrWgtBD
         , i.[weight] * m.[value] AS QtrValBD
		 ,i.regtime AS Regtime
	FROM FO_Innova.dbo.proc_items i 
	INNER JOIN FO_Innova.dbo.proc_materials m ON i.material = m.material
	INNER JOIN FO_Innova.dbo.base_sites s ON i.[site] = s.[site]
	WHERE i.device IS NOT NULL AND i.parentitem IS NOT NULL 
	AND CONVERT(NVARCHAR(12), i.regtime, 102)BETWEEN CONVERT(NVARCHAR(12), @Start, 102) AND CONVERT(NVARCHAR(12), @End, 102)
	AND m.code NOT LIKE '%9999%'
	

	UNION
    
    --Issues
    SELECT '07-Issues'                                            AS [Grouping]
         , s.[name]
         , i.id                                        AS IssuesQtrQty
         , i.[weight]             AS QtrWgtIssues
         , i.[weight] * m.[value] AS QtrValIssues
		 ,i.regtime AS Regtime
    FROM FO_Innova.dbo.proc_items               i
        INNER JOIN FO_Innova.dbo.proc_materials m
            ON i.material = m.material
        LEFT JOIN FO_Innova.dbo.base_sites      s
            ON s.[site] = i.[site]
    WHERE i.inventory = 47
          AND CONVERT(NVARCHAR(12), i.regtime, 102)
         BETWEEN CONVERT(NVARCHAR(12), @Start, 102) AND CONVERT(NVARCHAR(12), @End, 102)

		 UNION

	--Deleted 
	SELECT '08-Deleted' AS [Grouping]
		    ,s.[name] AS [Site]
			, i.id                                        AS QtrCountDeletes
			, CAST(i.[weight] AS DECIMAL(10, 2))             AS QtrWgtDeletes
			, CAST(i.[weight] * m.[value] AS DECIMAL(10, 2)) AS QtrValDeletes
			, i.regtime
	FROM FO_Innova.dbo.proc_items               i
        INNER JOIN FO_Innova.dbo.proc_materials m
            ON i.material = m.material
        LEFT JOIN FO_Innova.dbo.base_sites      s
            ON s.[site] = i.[site]
	WHERE CONVERT(NVARCHAR(12), i.regtime, 102) BETWEEN CONVERT(NVARCHAR(12), @Start, 102) AND CONVERT(NVARCHAR(12), @End, 102)
			AND i.rtype = 4
	

		UNION 

	--Breakdown - Out
	SELECT '09-BD-Out' AS [Grouping]
		    ,s.[name] AS [Site]
			, i.id                                        AS QtrCountDeletes
			, CAST(i.[weight] AS DECIMAL(10, 2))           AS QtrWgtDeletes
			, CAST(i.[weight] * m.[value] AS DECIMAL(10, 2)) AS QtrValDeletes
			,i.regtime
	FROM FO_Innova.dbo.proc_items               i
        INNER JOIN FO_Innova.dbo.proc_materials m
            ON i.material = m.material
        LEFT JOIN FO_Innova.dbo.base_sites      s
            ON s.[site] = i.[site]
	WHERE CONVERT(NVARCHAR(12), i.exday2, 102) BETWEEN CONVERT(NVARCHAR(12), @Start, 102) AND CONVERT(NVARCHAR(12), @End, 102)
			AND i.rtype = 1 AND i.inventory IS NULL AND m.[name] NOT IN ('Side 1','Side 2')
	
  
  DELETE FROM
  dbo.itemReconTmp


  INSERT INTO dbo.itemReconTmp
  SELECT * FROM @t
  
END;
GO
