CREATE TABLE [dbo].[tblLPRPallets]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[NewRecord] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[RecordNo] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[SenderCodeQualifier] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[SenderCode] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[ReceiverCodeQualifier] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[ReceiverCode] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[PalletCodeQualifier] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[PalletCode] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[MovementDate] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Quantity] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[CustomerReference] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Ship-ToReference] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[CounterPartName] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[CounterPartAddress] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[CounterPartCity] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[CounterPartZip] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[CounterPartCountry] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[CounterPartPhone] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[FlowCode] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[SpecialMovementFlag] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Comment] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[EndOfRecord] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Ignore] [bit] NULL CONSTRAINT [DF_tblLPRPallets_Ignore] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblLPRPallets] ADD CONSTRAINT [PK_tblLPRPallets] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-IgnoreColumnOnly] ON [dbo].[tblLPRPallets] ([Ignore]) ON [PRIMARY]
GO
