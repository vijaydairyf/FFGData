CREATE TABLE [dbo].[grp_Countries]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CountryId] [int] NOT NULL,
[CountryName] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CountryShname] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Dimension1] [int] NULL
) ON [PRIMARY]
GO
