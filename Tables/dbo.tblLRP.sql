CREATE TABLE [dbo].[tblLRP]
(
[ID] [bigint] NOT NULL IDENTITY(1, 1),
[TableName] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Site] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[TimeIndicator] [datetime] NULL,
[NumberIndicator] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblLRP] ADD CONSTRAINT [PK_tblLRP] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
