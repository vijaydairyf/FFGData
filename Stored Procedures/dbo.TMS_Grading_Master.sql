SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- [TMS_Grading_Master] 'FC','2018-01-15', '07','08','15','15'
-- [TMS_Grading_Master] 'FO','2018-07-23', '07','08','15','15'
CREATE PROCEDURE [dbo].[TMS_Grading_Master] 
	-- Add the parameters for the stored procedure here
	@Site nvarchar(3),
	@Date date,
	@FromHour nvarchar(2),
	@ToHour nvarchar(2),

	@FromMin nvarchar(2),
	@ToMin nvarchar(2)
AS
BEGIN

DECLARE @tms table(
MaterialCode nvarchar(11),
MaterialName nvarchar(250),
Pruname nvarchar(40),
targetCL decimal,
avgCL decimal,
Wgt decimal,
Pieces int,
hr nvarchar(3),
mi nvarchar(3)
)

if @Site = 'FC'
Begin
Insert into @tms
Exec [FM_Innova].[dbo].[usrrep_TMS_Overview_reportdesigner_Replica] @Date,@FromHour,@ToHour,@FromMin,@ToMin
Select * from @tms
End


If @Site = 'FG'
Begin
insert into @tms
Exec FG_Innova.[dbo].[usrrep_TMS_Overview_reportdesigner]  @Date,@FromHour,@ToHour,@FromMin,@ToMin
Select * from @tms
End

--omagh
If @Site = 'FO'
Begin
insert into @tms
Exec FO_Innova.[dbo].[usrrep_TMS_Overview_reportdesigner_Replica]  @Date,@FromHour,@ToHour,@FromMin,@ToMin
Select * from @tms
End



END
GO
