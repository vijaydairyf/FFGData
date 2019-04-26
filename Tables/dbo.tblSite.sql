CREATE TABLE [dbo].[tblSite]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SiteName] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Goods] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblSite] ADD CONSTRAINT [PK_tblSite] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
