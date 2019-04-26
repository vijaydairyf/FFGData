SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetProductCodes]
(
    @OrderNo NVarChar(25),
	@SubOrderNo NVarChar(25),
	@BoxNo NVarChar(25)
)
RETURNS varchar(max)
AS
BEGIN
    declare @output varchar(max)
    select @output = COALESCE(@output + ', ', '') + ProductCode
    from [ffgbi-serv].[ffg_dw].dbo.HR_Order_Allocation
    where OrderNo = @OrderNo And SubOrderNo=@SubOrderNo And HR_BoxNo=@BoxNo
	Group By ProductCode

    return @output
END
GO
