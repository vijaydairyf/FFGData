CREATE TABLE [dbo].[tblLPRPalletsDepot]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DepotCode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[DepotName] [nvarchar] (150) COLLATE Latin1_General_CI_AS NULL,
[DepotFullName] [nvarchar] (150) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblLPRPalletsDepot] ADD CONSTRAINT [PK_tblLPRPalletsDepot] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
