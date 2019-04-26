SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Emma Nugent>
-- Create date: 	<30/11/17>
-- Description:	<Canadian Shipment EU Cert Report>
-- =============================================

-- exec [usr_GetCanadaShipmentDetails_Master] '42100'
CREATE PROCEDURE [dbo].[usr_GetCanadaShipmentDetails_Master]

@shFFGSONum nvarchar(15)

AS

DECLARE @Canadian table (
[Description] nvarchar(100),
[SlaughteredAddress] nvarchar(100),
[ManufacturedAddress] nvarchar (100),
[Weight] decimal(10,2),
[Shipment Mark] nvarchar(50),
[FFGSONumber] nvarchar(60),
[ColdStore] nvarchar(60),
[TypeOfPackages] nvarchar(60),
[Site] nvarchar(60),
[Number Of Packages] smallint
)


Begin
INSERT INTO @Canadian
EXEC	[dbo].[usr_GetCanadaShipmentDetails_FO] @shFFGSONum


INSERT INTO @Canadian
EXEC	[dbo].[usr_GetCanadaShipmentDetails_FC] @shFFGSONum


INSERT INTO @Canadian
EXEC	[dbo].[usr_GetCanadaShipmentDetails_FD] @shFFGSONum


INSERT INTO @Canadian
EXEC	[dbo].[usr_GetCanadaShipmentDetails_FG] @shFFGSONum


INSERT INTO @Canadian
EXEC	[dbo].[usr_GetCanadaShipmentDetails_FMM] @shFFGSONum


INSERT INTO @Canadian
EXEC	[dbo].[usr_GetCanadaShipmentDetails_FH] @shFFGSONum

SELECT * FROM @Canadian
order by  [Site] desc

ENd





GO
