CREATE TABLE [dbo].[Stock_SnapShot]
(
[ID] [bigint] NOT NULL IDENTITY(1, 1),
[SnapShotDate] [datetime] NULL,
[Site] [nvarchar] (15) COLLATE Latin1_General_CI_AS NULL,
[PackId] [bigint] NULL,
[Inventory] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[SSCC] [nvarchar] (18) COLLATE Latin1_General_CI_AS NULL,
[Wgt] [real] NULL,
[PalletId] [bigint] NULL,
[DestinationInv] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Stock_SnapShot] ADD CONSTRAINT [PK_Stock_SnapShot] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
