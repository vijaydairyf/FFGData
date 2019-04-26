CREATE TABLE [dbo].[tblGroConLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DueDate] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Site] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ASNRef] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ItemNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Units] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Weight] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Expiry] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[PalletNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[KillDate] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[GCPalletNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[GCReference] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FileSent] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RecAdv] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RegTime] [smalldatetime] NULL,
[SentTime] [smalldatetime] NULL,
[RecAdvTime] [smalldatetime] NULL,
[FileName] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL,
[PalletSSCC] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
