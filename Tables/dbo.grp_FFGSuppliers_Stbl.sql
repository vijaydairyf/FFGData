CREATE TABLE [dbo].[grp_FFGSuppliers_Stbl]
(
[FFGSupplierID] [int] NOT NULL IDENTITY(1, 1),
[NAVSupplierNo] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[SupplierName] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL,
[Address] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[City] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[grp_FFGSuppliers_Stbl] ADD CONSTRAINT [PK_grp_FFGSuppliers_Stbl] PRIMARY KEY CLUSTERED  ([FFGSupplierID]) ON [PRIMARY]
GO
