SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[Usr_Vw_Order_Allocation_BI]
AS
-----------------------
--Kelsey Brennan
--
--Master View (XLM columns) for comparing if stock was allocated or if despatch did not scan it. 

---------------------
SELECT 
		o.[name] as [Order No]
      ,SUM(l.[amount]) as [Sent to Innova]
	  ,m.code as [Innova Item No]
	  ,Case when accepttype=1
	  Then 'By List'
	   when accepttype=3
	  Then 'Accepts All'
	  end as [Innova type]
  FROM      [FD_Innova].[dbo].[proc_orders] o with(nolock)
 inner join [FD_Innova].[dbo].[proc_orderl] l with(nolock) on o.[order]=l.[order]
 left join  [FD_Innova].[dbo].[proc_materials] m on l.material=m.material

WHERE        (o.ordertype = 1) 
         AND (LEFT(o.name, 5) = 'ffgso')

GROUP BY 
o.name
,m.code
,accepttype
having SUM(l.[amount]) is not null
---------------------------------
UNION ALL
---------------------------------
SELECT 
		o.[name] as [Order No]
      ,SUM(l.[amount]) as [Sent to Innova]
	  ,m.code as [Innova Item No]
	    ,Case when accepttype=1
	  Then 'By List'
	   when accepttype=3
	  Then 'Accepts All'
	  end as [Innova type]
  FROM      [FO_Innova].[dbo].[proc_orders] o with(nolock)
 inner join [FO_Innova].[dbo].[proc_orderl] l with(nolock) on o.[order]=l.[order]
 left join  [FO_Innova].[dbo].[proc_materials] m on l.material=m.material

WHERE        (o.ordertype = 1) 
         AND (LEFT(o.name, 5) = 'ffgso')

GROUP BY 
o.name
,m.code
,accepttype
having SUM(l.[amount]) is not null
-------------------------------
UNION ALL
---------------------------------
SELECT 
		o.[name] as [Order No]
      ,SUM(l.[amount]) as [Sent to Innova]
	  ,m.code as [Innova Item No]
	    ,Case when accepttype=1
	  Then 'By List'
	   when accepttype=3
	  Then 'Accepts All'
	  end as [Innova type]
  FROM      [FG_Innova].[dbo].[proc_orders] o with(nolock)
 inner join [FG_Innova].[dbo].[proc_orderl] l with(nolock) on o.[order]=l.[order]
 left join  [FG_Innova].[dbo].[proc_materials] m on l.material=m.material

WHERE        (o.ordertype = 1) 
         AND (LEFT(o.name, 5) = 'ffgso')

GROUP BY 
o.name
,m.code
,accepttype
having SUM(l.[amount]) is not null
---------------------------------
UNION ALL
---------------------------------
SELECT 
		o.[name] as [Order No]
      ,SUM(l.[amount]) as [Sent to Innova]
	  ,m.code as [Innova Item No]
	    ,Case when accepttype=1
	  Then 'By List'
	   when accepttype=3
	  Then 'Accepts All'
	  end as [Innova type]
  FROM      [FH_Innova].[dbo].[proc_orders] o with(nolock)
 inner join [FH_Innova].[dbo].[proc_orderl] l with(nolock) on o.[order]=l.[order]
 left join  [FH_Innova].[dbo].[proc_materials] m on l.material=m.material

WHERE        (o.ordertype = 1) 
         AND (LEFT(o.name, 5) = 'ffgso')

GROUP BY 
o.name
,m.code
,accepttype
having SUM(l.[amount]) is not null
---------------------------------
UNION ALL
---------------------------------
SELECT 
		o.[name] as [Order No]
      ,SUM(l.[amount]) as [Sent to Innova]
	  ,m.code as [Innova Item No]
	    ,Case when accepttype=1
	  Then 'By List'
	   when accepttype=3
	  Then 'Accepts All'
	  end as [Innova type]
  FROM      [FI_Innova].[dbo].[proc_orders] o with(nolock)
 inner join [FI_Innova].[dbo].[proc_orderl] l with(nolock) on o.[order]=l.[order]
 left join  [FI_Innova].[dbo].[proc_materials] m on l.material=m.material

WHERE        (o.ordertype = 1) 
         AND (LEFT(o.name, 5) = 'ffgso')

GROUP BY 
o.name
,m.code
,accepttype
having SUM(l.[amount]) is not null
-------------------------------

-------------------------------
UNION ALL
---------------------------------
SELECT 
		o.[name] as [Order No]
      ,SUM(l.[amount]) as [Sent to Innova]
	  ,m.code as [Innova Item No]
	    ,Case when accepttype=1
	  Then 'By List'
	   when accepttype=3
	  Then 'Accepts All'
	  end as [Innova type]
  FROM      [FMM_Innova].[dbo].[proc_orders] o with(nolock)
 inner join [FMM_Innova].[dbo].[proc_orderl] l with(nolock) on o.[order]=l.[order]
 left join  [FMM_Innova].[dbo].[proc_materials] m on l.material=m.material

WHERE        (o.ordertype = 1) 
         AND (LEFT(o.name, 5) = 'ffgso')

GROUP BY 
o.name
,m.code
,accepttype
having SUM(l.[amount]) is not null
-------------------------------------------------------------
UNION ALL
---------------------------------
SELECT 
		o.[name] collate Latin1_General_CI_AS as [Order No]
      ,SUM(l.[amount]) as [Sent to Innova]
	  ,m.code  collate Latin1_General_CI_AS as [Innova Item No]
	    ,Case when accepttype=1
	  Then 'By List'
	   when accepttype=3
	  Then 'Accepts All'
	  end as [Innova type]
  FROM      [FM_Innova].[dbo].[proc_orders] o with(nolock)
 inner join [FM_Innova].[dbo].[proc_orderl] l with(nolock) on o.[order]=l.[order]
 left join  [FM_Innova].[dbo].[proc_materials] m on l.material=m.material

WHERE        (o.ordertype = 1) 
         AND (LEFT(o.name, 5) = 'ffgso')

GROUP BY 
o.name
,m.code
,accepttype
having SUM(l.[amount]) is not null
-------------------------------------------------------------
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'Usr_Vw_Order_Allocation_BI', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'Usr_Vw_Order_Allocation_BI', NULL, NULL
GO
