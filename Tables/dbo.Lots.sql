CREATE TABLE [dbo].[Lots]
(
[SiteID] [int] NOT NULL,
[LotID] [bigint] NOT NULL,
[Code] [bigint] NOT NULL,
[Name] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[ExtCode] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Dimension1] [int] NULL,
[Description2] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[Description5] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[SLHouse] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[BRCountry] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RICountry] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
