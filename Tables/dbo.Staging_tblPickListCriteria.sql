CREATE TABLE [dbo].[Staging_tblPickListCriteria]
(
[PaymentLineId] [int] NOT NULL,
[SpecName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SiteID] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[KillDate] [smalldatetime] NULL,
[KillNo] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Eartag] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Sex] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AgeInMonths] [int] NULL,
[ColdWeight] [decimal] (18, 0) NULL,
[Conformation] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Fat] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FQAS] [bit] NULL,
[DaysOnLastFarm] [int] NULL,
[BornIn] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RearedIn] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SlaughteredIn] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Location] [varchar] (30) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Staging_tblPickListCriteria] ADD CONSTRAINT [PK_Staging_tblPickListCriteria] PRIMARY KEY CLUSTERED  ([PaymentLineId]) ON [PRIMARY]
GO
