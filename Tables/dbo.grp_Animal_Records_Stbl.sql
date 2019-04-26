CREATE TABLE [dbo].[grp_Animal_Records_Stbl]
(
[stblID] [int] NOT NULL IDENTITY(1, 1),
[SiteIdentifier] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AphisTblID] [int] NULL,
[Sex] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IndividualID] [int] NULL,
[KillNo] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[MoveDate] [datetime] NULL,
[DOB] [datetime] NULL,
[KillDate] [datetime] NULL,
[Regtime] [datetime] NULL,
[FQAS] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[numMoves] [int] NULL,
[HerdNo] [nvarchar] (30) COLLATE Latin1_General_CI_AS NULL,
[KeeperName] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[DaysOnLastFarm] [int] NULL,
[TWA] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AgeZone] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[OriginalEartagNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[EartagNo] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL,
[AgeInMonths] [int] NULL,
[Breed] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[brcountry] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ricountry] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ArchivedRecord] [int] NULL,
[HideColour] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CertificateNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FQA_InspectionDate] [datetime] NULL,
[ControlRisk] [nvarchar] (3) COLLATE Latin1_General_CI_AS NULL,
[RecordStatus] [nvarchar] (3) COLLATE Latin1_General_CI_AS NULL,
[HighPH] [nvarchar] (1) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[grp_Animal_Records_Stbl] ADD CONSTRAINT [PK_grp_Animal_Records_Stbl] PRIMARY KEY CLUSTERED  ([stblID]) ON [PRIMARY]
GO
