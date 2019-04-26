CREATE TABLE [dbo].[grp_FFGSuppliers]
(
[FFGSupplierID] [int] NOT NULL IDENTITY(1, 1),
[NAVSupplierNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[SupplierName] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL,
[Address] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[City] [text] COLLATE Latin1_General_CI_AS NULL,
[PostCode] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[grp_FFGSuppliers] ADD CONSTRAINT [PK_grp_FFGSuppliers] PRIMARY KEY CLUSTERED  ([FFGSupplierID]) ON [PRIMARY]
GO
