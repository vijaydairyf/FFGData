CREATE TABLE [dbo].[Inventories]
(
[Site] [int] NOT NULL,
[InventoryID] [bigint] NOT NULL,
[Name] [nvarchar] (30) COLLATE Latin1_General_CI_AS NOT NULL,
[InventoryTypeID] [bigint] NOT NULL,
[description1] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[description2] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[description3] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
