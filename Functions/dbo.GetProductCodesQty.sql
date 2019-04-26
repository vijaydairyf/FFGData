SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetProductCodesQty]
(
    @OrderNo NVarChar(25),
	@SubOrderNo NVarChar(25),
	@BoxNo NVarChar(25)
)
RETURNS varchar(max)
AS
BEGIN
    declare @output varchar(max)
    select @output = COALESCE(@output + ', ', '') + ProductCode+' ('+Cast(Count(BoxNo) As NVarChar(50))+' '+
	CASE WHEN SiteID=1 Then 'FC' When SiteID=2 Then 'FO' When SiteID=3 Then 'FH' When SiteID=4 Then 'FD'	When SiteID=5 Then 'FGL' When SiteID=6 Then 'FMM' Else 'FFG' End
	+')'
    from [ffgbi-serv].[ffg_dw].dbo.HR_Order_Allocation
    where OrderNo = @OrderNo And SubOrderNo=@SubOrderNo And HR_BoxNo=@BoxNo
	Group By ProductCode, SiteID

    return @output
END
GO
