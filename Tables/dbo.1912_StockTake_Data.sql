CREATE TABLE [dbo].[1912_StockTake_Data]
(
[StockTakeId] [int] NULL,
[StockTakeFlag] [nchar] (10) COLLATE Latin1_General_CI_AS NULL,
[Stocktake] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL,
[Inventory] [nvarchar] (150) COLLATE Latin1_General_CI_AS NULL,
[ProductCode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ProductDescription] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL,
[Quantity] [int] NULL,
[Weight] [real] NULL,
[Price] [real] NULL,
[Value] [real] NULL,
[ProductType] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[PalletNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Location] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Fabcode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
