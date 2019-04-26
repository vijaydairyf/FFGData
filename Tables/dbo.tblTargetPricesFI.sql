CREATE TABLE [dbo].[tblTargetPricesFI]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Customer] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[OrderType] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ProductCode] [nvarchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [nvarchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[TargetPPK] [decimal] (10, 4) NULL
) ON [PRIMARY]
GO
