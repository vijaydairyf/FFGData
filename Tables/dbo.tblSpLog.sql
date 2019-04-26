CREATE TABLE [dbo].[tblSpLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DateAndTime] [smalldatetime] NULL,
[TransNumber] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Sp] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[SpMessage] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblSpLog] ADD CONSTRAINT [PK_tblSpLog] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
