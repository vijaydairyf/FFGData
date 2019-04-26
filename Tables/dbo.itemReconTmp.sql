CREATE TABLE [dbo].[itemReconTmp]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[Grouping] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL,
[Site] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ItemId] [int] NULL,
[itemWgt] [decimal] (10, 2) NULL,
[itemVal] [decimal] (12, 2) NULL,
[Regtime] [datetime] NULL
) ON [PRIMARY]
GO
