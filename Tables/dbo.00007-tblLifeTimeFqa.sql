CREATE TABLE [dbo].[00007-tblLifeTimeFqa]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[Site] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[KillDate] [datetime] NULL,
[LifeTimeQty] [int] NULL,
[Steers] [int] NULL,
[Heifers] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[00007-tblLifeTimeFqa] ADD CONSTRAINT [PK_tblLifeTimeFqa] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
