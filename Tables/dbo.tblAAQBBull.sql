CREATE TABLE [dbo].[tblAAQBBull]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[BullName] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[BullSource] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[BullSite] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblAAQBBull] ADD CONSTRAINT [PK_tblAAQBBull] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
