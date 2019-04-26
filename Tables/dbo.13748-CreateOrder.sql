CREATE TABLE [dbo].[13748-CreateOrder]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[OriginalOrder] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[NewOrder] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Supplier] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[KillDate] [smalldatetime] NULL,
[User] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[EntryTime] [smalldatetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[13748-CreateOrder] ADD CONSTRAINT [PK_13748-CreateOrder] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
