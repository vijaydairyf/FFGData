CREATE TABLE [dbo].[tblRetailYieldPerc]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[MinceYield] [decimal] (18, 2) NULL,
[DicedYield] [decimal] (18, 2) NULL,
[BBQYield] [decimal] (18, 2) NULL,
[BurgerYield] [decimal] (18, 2) NULL,
[BKYield] [decimal] (18, 2) NULL,
[SirloinYield] [decimal] (18, 2) NULL,
[LMCYield] [decimal] (18, 2) NULL,
[MedallionYield] [decimal] (18, 2) NULL,
[FryingYield] [decimal] (18, 2) NULL,
[RibYield] [decimal] (18, 2) NULL,
[RumpYield] [decimal] (18, 2) NULL,
[FilletYield] [decimal] (18, 2) NULL,
[Date] [date] NULL,
[WeekNo] [int] NULL
) ON [PRIMARY]
GO
