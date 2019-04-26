CREATE TABLE [dbo].[tblHROrdersHeader]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[OrderDate] [smalldatetime] NULL,
[GroupOrderNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[DeliveryDate] [smalldatetime] NULL,
[SubOrder] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[VIP] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SiteID] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SiteName] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[NavOrderNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Goods] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[GoodsDescription] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrderType] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Tracker] [bit] NULL CONSTRAINT [DF_tblHROrdersHeader_Tracker] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblHROrdersHeader] ADD CONSTRAINT [PK_tblHROrdersHeader] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
