CREATE TABLE [dbo].[Group_Fresh_Snapshot_Daily]
(
[Date] [datetime] NULL,
[SiteID] [nvarchar] (5) COLLATE Latin1_General_CI_AS NULL,
[Product Code] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Product Description] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Product Type] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Product Condition] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Inventory] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Pack Date] [datetime] NULL,
[Kill Date] [datetime] NULL,
[Use By Date] [datetime] NULL,
[DNOB Date] [datetime] NULL,
[Weight] [decimal] (18, 3) NULL,
[P/KG] [money] NULL,
[Value] [float] NULL,
[QTY] [bigint] NULL
) ON [PRIMARY]
GO
