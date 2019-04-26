CREATE TABLE [dbo].[tblGroConPalletList]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DueDate] [date] NULL,
[SiteID] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ItemNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[PalletNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Units] [int] NULL CONSTRAINT [DF_tblGroConPalletList_Units] DEFAULT ((0)),
[Wgt] [decimal] (18, 2) NULL CONSTRAINT [DF_tblGroConPalletList_Wgt] DEFAULT ((0)),
[FileSent] [bit] NULL CONSTRAINT [DF_tblGroConPalletList_FileSent] DEFAULT ((0)),
[DateSent] [smalldatetime] NULL,
[ASN] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RECADV] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblGroConPalletList] ADD CONSTRAINT [PK_tblGroConPalletList] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
