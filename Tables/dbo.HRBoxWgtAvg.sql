CREATE TABLE [dbo].[HRBoxWgtAvg]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[BoxNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Wgt] [decimal] (18, 2) NULL,
[Qty] [decimal] (18, 2) NULL,
[AvgCaseWgt] [decimal] (18, 2) NULL,
[Imported] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HRBoxWgtAvg] ADD CONSTRAINT [PK_HRBoxWgtAvg] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
