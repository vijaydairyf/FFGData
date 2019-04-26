CREATE TABLE [dbo].[Tbl_Group_Item_Reconciliation_SS]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[Site] [text] COLLATE Latin1_General_CI_AS NULL,
[ItemID] [int] NOT NULL,
[Weight] [decimal] (10, 2) NULL,
[ProductionDay] [datetime] NULL,
[Value] [decimal] (10, 2) NULL,
[SnapshotDate] [datetime] NULL,
[InventoryName] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL,
[ProductCode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[WeekNo] [int] NULL
) ON [PRIMARY]
GO
