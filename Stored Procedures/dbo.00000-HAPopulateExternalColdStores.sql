SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--Truncate Table HaEcs

--exec [00000-HAPopulateExternalColdStores]

CREATE PROCEDURE [dbo].[00000-HAPopulateExternalColdStores]

AS 

Insert Into FFGData.dbo.HaEcs
(SSCC, [Location], FFGSite)

Select Distinct pp.sscc AS 'SSCC',pru.[name] As 'Location', 'FOCS' As FFGSite
From [FO_Innova].dbo.proc_packs pp (NOLOCK)
inner join [FO_Innova].dbo.proc_prunits pru With (NOLOCK)  on pp.inventory = pru.prunit 
Left Join FFGData.dbo.HaEcs ecs with (NOLOCK) on pp.sscc=ecs.SSCC And ecs.FFGSite='FOCS'
Where pru.prunit in (105,106,120,121,131) And ecs.sscc is null

Insert Into FFGData.dbo.HaEcs
(SSCC, [Location], FFGSite)

Select Distinct pp.sscc AS 'SSCC',pru.[name] As 'Location', 'FHCS' As FFGSite
From [FH_Innova].dbo.proc_packs pp (NOLOCK)
inner join [FH_Innova].dbo.proc_prunits pru With (NOLOCK)  on pp.inventory = pru.prunit 
Left Join FFGData.dbo.HaEcs ecs with (NOLOCK) on pp.sscc=ecs.SSCC And ecs.FFGSite='FHCS'
Where pru.prunit in (23,24,63,64,65,66,67) And ecs.sscc is null

Insert Into FFGData.dbo.HaEcs
(SSCC, [Location], FFGSite)

Select Distinct pp.sscc AS 'SSCC',pru.[name] As 'Location', 'FDCS' As FFGSite
From [FD_Innova].dbo.proc_packs pp (NOLOCK)
inner join [FD_Innova].dbo.proc_prunits pru With (NOLOCK)  on pp.inventory = pru.prunit 
Left Join FFGData.dbo.HaEcs ecs with (NOLOCK) on pp.sscc=ecs.SSCC And ecs.FFGSite='FDCS'
Where pru.prunit in (83,84,85) And ecs.sscc is null
GO
