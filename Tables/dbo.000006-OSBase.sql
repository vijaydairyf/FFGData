CREATE TABLE [dbo].[000006-OSBase]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[FFGSO] [nvarchar] (50) COLLATE SQL_Latin1_General_CP850_CI_AS NULL,
[FFGSite] [nvarchar] (50) COLLATE SQL_Latin1_General_CP850_CI_AS NULL,
[InnovaStatus] [int] NULL,
[Customer] [nvarchar] (250) COLLATE SQL_Latin1_General_CP850_CI_AS NULL,
[PostingDate] [datetime] NULL,
[accepttype] [int] NULL,
[orderstatus] [int] NULL,
[RequestTime] [time] NULL,
[NavInnovaStat] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[InnovaStat] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[TimeStat] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AcceptsStat] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ProcessStat] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IPAddress] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Username] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[DateAndTime] [datetime] NULL,
[SalesAdminContacted] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[PdaError] [nvarchar] (150) COLLATE Latin1_General_CI_AS NULL,
[UpdatedTime] [datetime] NULL,
[OrField] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[000006-OSBase] ADD CONSTRAINT [PK_000006-OSBase] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
