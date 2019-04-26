CREATE TABLE [dbo].[EcsPreImport]
(
[timestamp] [timestamp] NULL,
[Primary Key] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Posting Date] [datetime] NULL,
[Transaction Type] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Order No_] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Location Code] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Customer No_] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Customer Name] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Item No_] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Line No_] [int] NULL,
[Unit Of Measure Code] [varchar] (4) COLLATE Latin1_General_CI_AS NULL,
[Qty_ Ordered] [decimal] (18, 5) NULL,
[Weight Qty_ Ordered] [decimal] (18, 5) NULL,
[ProductDescription] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL,
[No_ Of Pallets] [int] NULL,
[Delivery Date] [datetime] NULL,
[Delivery Time] [varchar] (8) COLLATE Latin1_General_CI_AS NULL,
[No_ Of Times Already Exported] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Shipment Mark] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Innova Lot No_] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Lot No_] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Kill Date] [smalldatetime] NULL,
[Pack Date] [smalldatetime] NULL,
[Use By Date] [smalldatetime] NULL,
[DNOB] [smalldatetime] NULL,
[Quantity] [decimal] (18, 5) NULL,
[Weight] [decimal] (18, 5) NULL,
[Innova Inventory] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Innova Inventory Location] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Message Type] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Pallet No_] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetryCount] [int] NULL,
[UnitTypeXfer] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Constraint] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Max Weight] [decimal] (18, 5) NULL,
[InnovaQty] [decimal] (18, 5) NULL,
[ItemStatus] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ShipTo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Storage] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[VIP] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[QtyDiff] [decimal] (18, 5) NULL
) ON [PRIMARY]
GO