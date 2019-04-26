CREATE TABLE [dbo].[grp_AnimalRecordValues_Stbl]
(
[AnlValID] [int] NOT NULL IDENTITY(1, 1),
[SiteIdentifier] [char] (10) COLLATE Latin1_General_CI_AS NULL,
[IndividualID] [int] NULL,
[AphisANLID] [int] NULL,
[EartagNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Conform] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FatClass] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Grade] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[GradeMethod] [text] COLLATE Latin1_General_CI_AS NULL,
[LocationCode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Side1Wgt] [decimal] (10, 1) NULL,
[FQ1Wgt] [decimal] (10, 1) NULL,
[HQ2Wgt] [decimal] (10, 1) NULL,
[Side2Wgt] [decimal] (10, 1) NULL,
[FQ3Wgt] [decimal] (10, 1) NULL,
[HQ4Wgt] [decimal] (10, 1) NULL,
[HotWeight] [decimal] (10, 1) NULL,
[ColdWeight] [decimal] (10, 1) NULL,
[IdentigenNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RegTime] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[grp_AnimalRecordValues_Stbl] ADD CONSTRAINT [PK_grp_AnimalRecordValues_Stbl] PRIMARY KEY CLUSTERED  ([AnlValID]) ON [PRIMARY]
GO
