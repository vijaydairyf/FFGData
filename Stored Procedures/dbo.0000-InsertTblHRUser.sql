SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 19th May 2017
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [0000-InsertTblHRUser] '122387','1','Martin McGinn','10.11.8.226'

CREATE PROCEDURE [dbo].[0000-InsertTblHRUser]

@OrderNo NVarChar(Max),  -- Have this passing through before going live.
@SubOrderNo NVarChar(Max), -- Have this passing through before going live.
@FFGSite NVarChar(Max),
@UserName NVarChar(Max),
@IpAddress NVarChar(Max)

AS

Insert Into tblHRUser
(Username, IpAddress, DaT, OrderNo, SubOrderNo, FFGSite, Archived)
Select
@UserName, @IpAddress, GetDate(), @OrderNo, @SubOrderNo, @FFGSite, 0
GO
