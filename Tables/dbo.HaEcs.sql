CREATE TABLE [dbo].[HaEcs]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SSCC] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Location] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FFGSite] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HaEcs] ADD CONSTRAINT [PK_HaEcs] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
