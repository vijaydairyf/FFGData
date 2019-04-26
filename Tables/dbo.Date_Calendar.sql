CREATE TABLE [dbo].[Date_Calendar]
(
[DateKey] [int] NOT NULL,
[Date] [date] NOT NULL,
[DayName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[WeekOfYear] [int] NULL,
[MonthOfYear] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Year] [int] NULL,
[FiscalWeekStart] [date] NULL,
[FiscalWeekEnd] [date] NULL,
[FiscalPeriodStart] [date] NULL,
[FiscalPeriodEnd] [date] NULL,
[FiscalWeekOfYear] [int] NULL,
[FiscalMonthYear] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FiscalYear] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Date_Calendar] ADD CONSTRAINT [PK_Date_Calendar] PRIMARY KEY CLUSTERED  ([DateKey]) ON [PRIMARY]
GO
