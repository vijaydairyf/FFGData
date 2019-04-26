CREATE TABLE [dbo].[tblPack]
(
[ID] [bigint] NOT NULL IDENTITY(1, 1),
[StockSite] [nvarchar] (22) COLLATE Latin1_General_CI_AS NOT NULL,
[PackNumber] [bigint] NULL,
[OriginalSite] [nvarchar] (22) COLLATE Latin1_General_CI_AS NULL,
[SSCC] [nvarchar] (18) COLLATE Latin1_General_CI_AS NULL,
[LotCode] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[LotName] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[PalletNo] [int] NULL,
[ProductionDate] [datetime] NULL,
[DeviceName] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[UseByDate] [datetime] NULL,
[KillDate] [datetime] NULL,
[DNOB] [datetime] NULL,
[InventoryName] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[InventoryStorage] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[InventoryCategory] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[InventoryLocation] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[ProductCode] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[ProductDescription] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[CustomerBrandCode] [int] NULL,
[CustomerBrand] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[FrozenGrouping] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[MaterialType] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[ProductSubGrouping] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[FreshFrozen] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Weight] [decimal] (18, 2) NULL,
[Pieces] [int] NULL,
[Xacttime] [datetime] NULL,
[ProductionLocation] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[InventoryTime] [smalldatetime] NULL,
[BatchNumber] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RegistrationTime] [datetime] NULL,
[PackRtype] [int] NULL,
[ICOR] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[MaterialNo] [bigint] NULL,
[PackStatus] [nchar] (20) COLLATE Latin1_General_CI_AS NULL,
[MaterialExtCode] [bigint] NULL,
[Side] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[YieldGroup] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[PackBatch] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL,
[MeatId] [int] NULL,
[ProductionOrder] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrderStatus] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrderName] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[CustomerName] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[OrderDispatchDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblPack] ADD CONSTRAINT [PK_tbl.FFGData] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20170424-090331] ON [dbo].[tblPack] ([SSCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tblPackItem_StockSite] ON [dbo].[tblPack] ([StockSite]) INCLUDE ([ID], [PackNumber], [SSCC]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [siteInventoryNameInventoryStorage-20170807-103916] ON [dbo].[tblPack] ([StockSite], [InventoryName], [InventoryStorage]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20170404-084842] ON [dbo].[tblPack] ([Xacttime]) ON [PRIMARY]
GO
