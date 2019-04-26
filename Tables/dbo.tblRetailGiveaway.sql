CREATE TABLE [dbo].[tblRetailGiveaway]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[DicedGW] [decimal] (18, 2) NULL,
[DicedGWP] [decimal] (18, 2) NULL,
[MinceGW] [decimal] (18, 2) NULL,
[MinceGWP] [decimal] (18, 2) NULL,
[BurgerGW] [decimal] (18, 2) NULL,
[BurgerGWP] [decimal] (18, 2) NULL,
[BKGW] [decimal] (18, 2) NULL,
[BKGWP] [decimal] (18, 2) NULL,
[RumpGW] [decimal] (18, 2) NULL,
[RumpGWP] [decimal] (18, 2) NULL,
[RibeyeGW] [decimal] (18, 2) NULL,
[RibeyeGWP] [decimal] (18, 2) NULL,
[SirloinGW] [decimal] (18, 2) NULL,
[SirloinGWP] [decimal] (18, 2) NULL,
[LMCGw] [decimal] (18, 2) NULL,
[LMCGwp] [decimal] (18, 2) NULL,
[MedallionGW] [decimal] (18, 2) NULL,
[MedallionGWP] [decimal] (18, 2) NULL,
[FryingGW] [decimal] (18, 2) NULL,
[FryingGWP] [decimal] (18, 2) NULL,
[BbqGW] [decimal] (18, 2) NULL,
[BbqGWP] [decimal] (18, 2) NULL,
[FilletGW] [decimal] (18, 2) NULL,
[FilletGWP] [decimal] (18, 2) NULL,
[DateStamp] [date] NULL,
[WeekNo] [int] NULL
) ON [PRIMARY]
GO