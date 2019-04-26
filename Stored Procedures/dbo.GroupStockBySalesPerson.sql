SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Benjamin Aranyi
-- Create date: 01/04/2019
-- Description:	Insert fresh/frozen, grouping and sales person into table
-- =============================================
CREATE PROCEDURE [dbo].[GroupStockBySalesPerson]
	@FreshFrozen nvarchar(50),
	@Grouping nvarchar(100),
	@SalesPerson nvarchar(100)
AS
BEGIN
	UPDATE [SalesPersonVsProductGrouping] SET SalesPerson=@SalesPerson WHERE [Fresh/Frozen] = @FreshFrozen AND [Grouping]=@Grouping
	IF @@ROWCOUNT=0
	   INSERT INTO [SalesPersonVsProductGrouping]([Fresh/Frozen],[Grouping],[SalesPerson]) VALUES (@FreshFrozen,@Grouping,@SalesPerson);
END
GO
