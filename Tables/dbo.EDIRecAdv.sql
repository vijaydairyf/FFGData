CREATE TABLE [dbo].[EDIRecAdv]
(
[ReceiptDate] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ExternalDocNo] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL,
[QTY] [nvarchar] (20) COLLATE Latin1_General_CI_AS NULL,
[Customer] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ProductCode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[UnitOfMeasure] [nchar] (10) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
