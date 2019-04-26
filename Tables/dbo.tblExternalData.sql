CREATE TABLE [dbo].[tblExternalData]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SourceLocation] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL,
[DocumentRef] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[DocumentDate] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FFGReference] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ItemReference] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Qty] [int] NULL,
[Wgt] [decimal] (18, 2) NULL,
[ProductCode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[LotCode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[KillDate] [smalldatetime] NULL,
[PackDate] [smalldatetime] NULL,
[DNOB] [smalldatetime] NULL,
[UseBy] [smalldatetime] NULL,
[ItemStatus] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[DropTime] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblExternalData] ADD CONSTRAINT [PK_tblExternalData] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
