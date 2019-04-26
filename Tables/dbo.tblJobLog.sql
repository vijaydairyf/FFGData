CREATE TABLE [dbo].[tblJobLog]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[JobName] [nvarchar] (150) COLLATE Latin1_General_CI_AS NULL,
[JobDateTime] [datetime] NULL,
[OrderExportedLocked] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblJobLog] ADD CONSTRAINT [PK_tblJobLog] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
