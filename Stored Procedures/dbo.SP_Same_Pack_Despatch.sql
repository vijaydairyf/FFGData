SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- =============================================
-- Author:		<kelsey brennan>
-- Create date: <21/02/2018>
-- Description:	<Heather M report, Pack date and Despatch date same>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Same_Pack_Despatch]
as
begin
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;






Select 
	
	cast(pp.regtime as date) as [Pack Date],
	po.[name] 

	into #union
from [FD_Innova].[dbo].[proc_packs] as pp
left join [FD_Innova].[dbo].proc_orders as po with (nolock) on po.[order] = pp.[order]

where 
	cast(pp.regtime as date)=cast(po.dispatchtime as date) 
	and cast(pp.regtime as date) >= '2017-01-01'

group by 
cast(pp.regtime as date),
po.[name] 
	
----------------------------------------------
				union 
----------------------------------------------
	
Select 
	
	cast(pp.regtime as date) as [Pack Date],
	po.[name] 


from [Fg_Innova].[dbo].[proc_packs] as pp
left join [Fg_Innova].[dbo].proc_orders as po with (nolock) on po.[order] = pp.[order]

where 
	cast(pp.regtime as date)=cast(po.dispatchtime as date) 
	and cast(pp.regtime as date) >= '2017-01-01'

group by 
cast(pp.regtime as date),
po.[name] 
	

----------------------------------------------
					union 
----------------------------------------------
	
Select 
	
	cast(pp.regtime as date) as [Pack Date],
	po.[name] 


from [Fh_Innova].[dbo].[proc_packs] as pp
left join [Fh_Innova].[dbo].proc_orders as po with (nolock) on po.[order] = pp.[order]

where 
	cast(pp.regtime as date)=cast(po.dispatchtime as date) 
	and cast(pp.regtime as date) >= '2017-01-01'

group by 
cast(pp.regtime as date),
po.[name] 
	
	----------------------------------------------
					union 
----------------------------------------------
	
Select 
	
	cast(pp.regtime as date) as [Pack Date],
	po.[name] 


from [Fi_Innova].[dbo].[proc_packs] as pp
left join [Fi_Innova].[dbo].proc_orders as po with (nolock) on po.[order] = pp.[order]

where 
	cast(pp.regtime as date)=cast(po.dispatchtime as date) 
	and cast(pp.regtime as date) >= '2017-01-01'

group by 
cast(pp.regtime as date),
po.[name] 
	
--		----------------------------------------------
					union 
----------------------------------------------
	
Select 
	
	cast(pp.regtime as date) as [Pack Date],
	po.[name] 


from [Fmm_Innova].[dbo].[proc_packs] as pp
left join [Fmm_Innova].[dbo].proc_orders as po with (nolock) on po.[order] = pp.[order]

where 
	cast(pp.regtime as date)=cast(po.dispatchtime as date) 
	and cast(pp.regtime as date) >= '2017-01-01'

group by 
cast(pp.regtime as date),
po.[name] 
	

--			----------------------------------------------
				union 
----------------------------------------------
	
Select 
	
	cast(pp.regtime as date) as [Pack Date],
	po.[name] 


from [Fo_Innova].[dbo].[proc_packs] as pp
left join [Fo_Innova].[dbo].proc_orders as po with (nolock) on po.[order] = pp.[order]

where 
	cast(pp.regtime as date)=cast(po.dispatchtime as date) 
	and cast(pp.regtime as date) >= '2017-01-01'

group by 
cast(pp.regtime as date),
po.[name] 
	
------------------------------------------
					union 
----------------------------------------------
	


Select 
	
	cast(pp.regtime as date) as [Pack Date],
	po.[name] collate database_default 


from [Fm_Innova].[dbo].[proc_packs] as pp
left join [Fm_Innova].[dbo].proc_orders as po with (nolock) on po.[order] = pp.[order]

where 
	cast(pp.regtime as date)=cast(po.dispatchtime as date) 
	and cast(pp.regtime as date) >= '2017-01-01'

group by 
cast(pp.regtime as date),
po.[name] 
	

	
	--------------------------

SELECT 
     
	 [Posting Date]
	 ,A.[Week]
	 ,A.[Period]
	 ,a.[Year]
	 ,[site dimension]
	      ,[Sell-to Customer No_]
      ,[Sell-to Customer Name]
	 ,COUNT (distinct u.name) as [Same Day Order]
      ,Count(distinct [Document No_]) as [Total Orders]
	  ,sum(Case when  u.name IS not null 
	  then ([Quantity])
	  end) as [Same Day KG]
      ,sum([Quantity]) as [KG]

  FROM  [ffgsql02].[FFG-Production].[dbo].[FFG LIVE$Sales Analysis History] s with (nolock)
  left join #union u on u.name collate SQL_Latin1_General_CP850_CI_AS=s.[sales order] collate SQL_Latin1_General_CP850_CI_AS
  left join[ffgsql02].[FFG-Production].[dbo].[AccountantDates] a on s.[Posting Date]=A.[date]

  where  [Posting Date]> '2017-01-01 00:00:00.000' 
  and [site dimension]<>'ffg_ltd'

  group by 

[Posting Date]
	 ,A.[Week]
	 ,A.[Period]
	 ,a.[Year]
	 ,[site dimension]
	      ,[Sell-to Customer No_]
      ,[Sell-to Customer Name]
   
	drop table #Union 
	
END
GO
