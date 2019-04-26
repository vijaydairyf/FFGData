CREATE TABLE [dbo].[tblHROrdersChecker]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[SSite] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrderRowNo] [int] NULL,
[OrderNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrderSubNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrderDate] [smalldatetime] NULL,
[DeliveryDate] [smalldatetime] NULL,
[RowNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SiteName] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[PalletNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[InventoryName] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[InventoryLocation] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[HRBoxNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ProductCode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ProductDescription] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL,
[LotCode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[KillDate] [smalldatetime] NULL,
[ProductionDate] [smalldatetime] NULL,
[UseByDate] [smalldatetime] NULL,
[DNOB] [smalldatetime] NULL,
[Qty] [decimal] (18, 5) NULL,
[Wgt] [decimal] (18, 5) NULL,
[OkOnNav] [bit] NULL,
[Processed] [bit] NULL,
[VIPOrder] [bit] NULL,
[AddOn] [bit] NULL,
[NavLotNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[LotQtyReq] [decimal] (18, 5) NULL,
[LotWgtReq] [decimal] (18, 5) NULL,
[NavInventory] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[NavLocation] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[NavSalesOrder] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[NavResQty] [decimal] (18, 5) NULL,
[NavResWgt] [decimal] (18, 5) NULL,
[NavPalletNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[QtyDiff] [decimal] (18, 5) NULL,
[WgtDiff] [decimal] (18, 5) NULL,
[NavDesQty] [decimal] (18, 5) NULL,
[NavDesWgt] [decimal] (18, 5) NULL,
[LastNegILE] [int] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-NavSalesOrder] ON [dbo].[tblHROrdersChecker] ([NavSalesOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-SiteOrderNo] ON [dbo].[tblHROrdersChecker] ([SSite], [OrderNo]) ON [PRIMARY]
GO
