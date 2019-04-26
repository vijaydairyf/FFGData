SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Kevin Hargan
-- Create date: 25/10/18
-- Description:	created for HR dispatch report
-- =============================================
--exec [USREP_HR_Dispatch_Summary_Report_FO] '370182'
CREATE PROCEDURE [dbo].[USREP_HR_Dispatch_Summary_Report_FO] 
	-- Add the parameters for the stored procedure here
@pallet int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--declare @NAVOrder nvarchar(15)
--set @NAVOrder = ('%' + cast(@OrderNo as nvarchar(15))  + '%')
		select 'FO' as site,count(pk.id) as QTY  ,pm.description1 collate SQL_Latin1_General_CP1_CI_AS as [Product Name] , 
		pl.description1 collate SQL_Latin1_General_CP1_CI_AS as [Supplier ID],po.Dispatchtime,
		 sh.[Delivery Date], DATENAME(dw,sh.[Delivery Date]) as DOW ,sh.[External Document No_] as PO,'Foyle Omagh UK 9042 EC' as Supplier 
	From [FO_INNOVA].dbo.[proc_packs] pk
	left join [FO_INNOVA].[dbo].[vw_OrderswithNoXML] po (nolock) on pk.[order]= po.[order]
	left join [FO_INNOVA].[dbo].[vw_matswithNoXML] pm (nolock) on pk.material = pm.material
	left join [FO_INNOVA].[dbo].[vw_LotswithNoXML] pl (nolock) on pk.lot = pl.lot
	left join [FO_INNOVA].dbo.[proc_collections] pc (nolock) on pk.pallet = pc.id
	left join [FFGSQL02].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] sh (nolock) on sh.[Order No_] collate SQL_Latin1_General_CP1_CI_AS = po.[name] collate SQL_Latin1_General_CP1_CI_AS
	where --exists (select * from [FFGCLS01].[FFG-Production].[dbo].[FFG LIVE$Sales Shipment Header] where [External Document No_] collate SQL_Latin1_General_CP1_CI_AS like @NAVOrder)
	 --and sh.[External Document No_] like @NAVOrder 
	 pc.number = @pallet
	--christmas codes removed temp to produce a report for primal HRUK  --KH 16/09/16
	-- and pm.code in('501910272','501910232','501910274','501910754','501910708','501910740','501910736','501910228','501910229','501910230','501910389','501910292','501910075','501910233','501910293','501910291','501910571','901910919','901910993','901910330')
	group by pm.description1, pl.description1,po.Dispatchtime, sh.[Delivery Date], DATENAME(dw,sh.[Delivery Date]),sh.[External Document No_] 
   



END
GO
