SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--This doesnt work

--exec [invlocations_Master] 'N'
CREATE PROCEDURE [dbo].[invlocations_Master]
--@Invloc nvarchar(4)
AS

DECLARE @Locations table (

invloc nvarchar(max),
[Site] nvarchar (max),
[name] nvarchar (max),
capacity nvarchar (max),
contents int,
[Status] nvarchar (max)
)



BEGIN

insert into @Locations
EXEC [FO_Innova].[dbo].usrrep_invlocations 

insert into @Locations
EXEC [INGSQL01].[FI_Innova].[dbo].usrrep_invlocations

insert into @Locations
EXEC [FG_Innova].[dbo].usrrep_invlocations 

insert into @Locations
EXEC [FM_Innova].[dbo].usrrep_invlocations 

insert into @Locations
EXEC [FMM_innova].[dbo].usrrep_invlocations 

insert into @Locations
EXEC [FH_Innova].[dbo].usrrep_invlocations



--select invloc,[Site],contents,[Status] from @Locations
--where [Site] in ('FO','FI','FMM','FC','FG','FH') and [Status] = 'Empty'
--group by invloc,[Site],contents,[Status]

Select * from (
select distinct invloc,Status,[Site]

 from @Locations
)datatable
PIVOT
(max(Status) for [Site] in (FO,FI,FG,FC,FMM,FH)
)as pvt
order by invloc asc

select * from (
select distinct invloc, contents, [site]
from @Locations
) dt2
PIVOT
(sum(contents) for [Site] in (FO,FI,FG,FC,FMM,FH))as pvt
	

END
GO
