CREATE TABLE [dbo].[FFGL-PicklistSpecs-Group]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SiteIdentifier] [nvarchar] (150) COLLATE Latin1_General_CI_AS NOT NULL,
[Spec] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL,
[SpecCriteria] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[IsActive] [bit] NULL,
[ReportDesc] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FFGL-PicklistSpecs-Group] ADD CONSTRAINT [PK_0000-PicklistSpecs] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
