CREATE TABLE [dbo].[InStockPowerBi]
(
[Product Description] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Conservation Name] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[prday] [datetime] NULL,
[Site] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Product Code] [nvarchar] (30) COLLATE Latin1_General_CI_AS NOT NULL,
[Week] [varchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Period] [varchar] (30) COLLATE Latin1_General_CI_AS NULL,
[Year] [int] NULL,
[Site Code] [int] NULL,
[Location] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[description1] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[description2] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[Weight] [real] NULL,
[Value] [real] NULL
) ON [PRIMARY]
GO
