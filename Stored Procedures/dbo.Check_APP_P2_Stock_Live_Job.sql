SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Check_APP_P2_Stock_Live_Job]

AS
BEGIN

Select j.job_id, j.[name], a.session_id,a.start_execution_date,a.last_executed_step_date,a.stop_execution_date
--, h.run_date,h.run_duration
into #tmp
from msdb.dbo.sysjobs j 
left join msdb.dbo.sysjobactivity a on a.job_id = j.job_id
--inner join msdb.dbo.sysjobhistory h on j.job_id = h.job_id
where a.start_execution_date > DATEADD(MINUTE,-15,GETDATE())
order by a.start_execution_date desc

select *, datediff(MINUTE, start_execution_date,GETDATE()) as dur
into #tmp1 from #tmp


declare @threshold int
set @threshold = 15

if ((select dur from #tmp1 where [name] in ('APP_P2_STOCK_TO_NAV(10 Min) - LIVE')) > @threshold)
begin

exec msdb.dbo.sp_send_dbmail
@profile_name = 'StockJobFail',
@recipients = 'BusinessRelationshipTeam@foylefoodgroup.com',
@body = 'ERROR - APP_P2_STOCK_TO_NAV(10 Min) - LIVE may have failed or is taking too long to run. Please check job.',
@subject = 'Error!';
end 

--begin
--EXEC msdb.dbo.sp_stop_job  
--    N'APP_P2_STOCK_TO_NAV(10 Min)' ; 
--	end
--	begin
--EXEC msdb.dbo.sp_start_job
-- N'APP_P2_STOCK_TO_NAV(10 Min)' ;  
-- end 



 drop table #tmp,#tmp1

END
GO
