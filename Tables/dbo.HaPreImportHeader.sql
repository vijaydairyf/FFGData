CREATE TABLE [dbo].[HaPreImportHeader]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[OrderNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SubOrderNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SiteID] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FFGSO] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OrderStatus] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[LastDAT] [smalldatetime] NULL,
[Closed] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HaPreImportHeader] ADD CONSTRAINT [PK_tblHRPreImportHeader] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
