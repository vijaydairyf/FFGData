CREATE TABLE [dbo].[tblColdStoreData]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SSite] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Destination] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ProductCode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ProductDescription] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[LotCode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[KillDate] [smalldatetime] NULL,
[PackDate] [smalldatetime] NULL,
[DNOB] [smalldatetime] NULL,
[UseBy] [smalldatetime] NULL,
[Qty] [int] NULL,
[Wgt] [decimal] (18, 2) NULL,
[CSReference] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblColdStoreData] ADD CONSTRAINT [PK_tblColdStoreData] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
