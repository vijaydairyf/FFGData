CREATE TABLE [dbo].[FrozenStockInOut]
(
[ProductCode] [int] NULL,
[Weight] [float] NULL,
[Value] [money] NULL,
[TransactionID] [int] NULL,
[InOrOut] [int] NULL,
[Pack] [int] NULL,
[Regtime] [datetime] NULL,
[Subjectid] [int] NULL,
[Site] [int] NULL,
[ImportDate] [datetime] NULL,
[Cat] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Customer] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
