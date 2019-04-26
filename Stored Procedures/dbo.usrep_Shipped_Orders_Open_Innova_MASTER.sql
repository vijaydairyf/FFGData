SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usrep_Shipped_Orders_Open_Innova_MASTER]
	-- Add the parameters for the stored procedure here
	
AS

DECLARE @OrderTable table(
OrderNO nvarchar(20),
OrderSite nvarchar(25)
)
BEGIN

Begin
insert into @OrderTable
Exec [FO_Innova].[dbo].[usrep_Shipped_Orders_Open]
end

Begin
insert into @OrderTable
Exec [FD_Innova].[dbo].[usrep_Shipped_Orders_Open]
end

Begin
insert into @OrderTable
Exec [FG_Innova].[dbo].[usrep_Shipped_Orders_Open]
end

Begin
insert into @OrderTable
Exec [FMM_innova].[dbo].[usrep_Shipped_Orders_Open]
end

Begin
insert into @OrderTable
Exec [FH_innova].[dbo].[usrep_Shipped_Orders_Open]
end

Begin
insert into @OrderTable
Exec [FI_Innova].[dbo].[usrep_Shipped_Orders_Open]
end

Begin
insert into @OrderTable
Exec [FM_Innova].[dbo].[usrep_Shipped_Orders_Open]
end


Select * from @OrderTable



END
GO
