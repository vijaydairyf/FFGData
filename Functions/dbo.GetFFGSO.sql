SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetFFGSO] 
(   
    @OrderNo NVarChar(25)
)
RETURNS @temptable TABLE ([ffgso] NVARCHAR(50),
						  [SiteID] NVarChar(50),
						  [OrderNo] NVarChar(50))
AS
BEGIN

Declare @f Table([ffgso] NVARCHAR(50),
				 [SiteID] NVarChar(50),
				 [OrderNo] NVarChar(50)) 

	Insert Into @f
	Select H.[No_] As 'FFGSO', H.[Location Code] As SiteID, @OrderNo As 'OrderNo' 
	From [ffgsql01].[FFG-PRODUCTION].dbo.[FFG LIVE$Sales Header] H Where H.[External Document No_]=@OrderNo

	Insert Into @f
	Select H.[Order No_] As 'FFGSO', H.[Location Code] As SiteID, @OrderNo As 'OrderNo'   
	From [ffgsql01].[FFG-PRODUCTION].dbo.[FFG LIVE$Sales Shipment Header] H Where H.[External Document No_]=@OrderNo

    INSERT INTO @temptable          
    Select FFGSO, SiteID, @OrderNo As 'OrderNo' 
	From @f 
	Group By FFGSO, SiteID

RETURN
END;
GO
