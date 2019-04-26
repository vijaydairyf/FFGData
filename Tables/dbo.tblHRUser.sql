CREATE TABLE [dbo].[tblHRUser]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Username] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IpAddress] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[DaT] [smalldatetime] NULL,
[OrderNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SubOrderNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[FFGSite] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Archived] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblHRUser] ADD CONSTRAINT [PK_tblHRUser] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
