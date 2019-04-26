CREATE TABLE [dbo].[HaOrderList]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[OrderNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SubOrder] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FFGSO] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrderStatus] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FFGSite] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ShipToCode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Storage] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HaOrderList] ADD CONSTRAINT [PK_HaOrderList] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
