CREATE TABLE [dbo].[tblHAChecker]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[OrderNo] [nvarchar] (25) COLLATE Latin1_General_CI_AS NULL,
[SubOrder] [nvarchar] (10) COLLATE Latin1_General_CI_AS NULL,
[SiteName] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[NavSalesOrder] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ProductCode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ProductDescription] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL,
[ProductionDate] [smalldatetime] NULL,
[KillDate] [smalldatetime] NULL,
[DNOB] [smalldatetime] NULL,
[UseByDate] [smalldatetime] NULL,
[Status] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[LOCN] [varchar] (7) COLLATE Latin1_General_CI_AS NULL,
[Qty] [decimal] (38, 5) NULL,
[QtyScanned] [decimal] (38, 5) NULL,
[HA] [int] NULL,
[QtyDiff] [int] NULL,
[Warning] [nvarchar] (25) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblHAChecker] ADD CONSTRAINT [PK_tblHAChecker] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-OrderNoSubOrderSite] ON [dbo].[tblHAChecker] ([OrderNo], [SubOrder], [SiteName]) ON [PRIMARY]
GO
