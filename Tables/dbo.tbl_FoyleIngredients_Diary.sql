CREATE TABLE [dbo].[tbl_FoyleIngredients_Diary]
(
[RecordID] [int] NOT NULL IDENTITY(1, 1),
[ProductionLine] [nvarchar] (150) COLLATE Latin1_General_CI_AS NULL,
[ProductionLineID] [int] NULL,
[Supervisor] [int] NULL,
[Operators] [int] NULL,
[StartTimeHr] [nvarchar] (2) COLLATE Latin1_General_CI_AS NULL,
[StartTimeMin] [nvarchar] (2) COLLATE Latin1_General_CI_AS NULL,
[EndTimeHr] [nvarchar] (2) COLLATE Latin1_General_CI_AS NULL,
[EndTimeMin] [nvarchar] (2) COLLATE Latin1_General_CI_AS NULL,
[TotalWgt] [decimal] (10, 2) NULL,
[ProductionDate] [date] NULL,
[RegTime] [datetime] NULL,
[LineType] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Archived] [int] NULL,
[EntryNo] [int] NULL,
[Active] [int] NULL
) ON [PRIMARY]
GO
