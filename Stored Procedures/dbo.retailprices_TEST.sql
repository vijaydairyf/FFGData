SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[retailprices_TEST]

@Code nvarchar(25),
@Description nvarchar(max)


AS
BEGIN

insert into tblTargetPricesFI (ProductCode,[Description])
Values
(@Code,@Description)



END
GO
