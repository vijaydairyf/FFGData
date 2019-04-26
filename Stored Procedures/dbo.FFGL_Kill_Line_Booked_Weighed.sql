SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kelsey Brennan>
-- Create date: <28/03/2019>
-- Description:	<SP for Kill line TV showing Booked and weighed animals>
-- =============================================
CREATE PROCEDURE [dbo].[FFGL_Kill_Line_Booked_Weighed]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 


CAST(r.KillDate AS DATE) AS [Date]
,DATENAME(weekDAY,r.KillDate) AS [Day]
,r.SiteIdentifier
,COUNT(r.IndividualID) AS [Booked]
,COUNT(v.IndividualID) AS [Weighed]


  FROM [FFGData].[dbo].[grp_Animal_Records] r
  left join dbo.grp_AnimalRecordValues v ON v.EartagNo = r.EartagNo AND v.SiteIdentifier = r.SiteIdentifier


 WHERE r.SiteIdentifier in ('fc','fo') 
 AND DATEDIFF(WK,r.KillDate,GetDate())=0
  
  
  GROUP BY 
CAST(r.KillDate AS DATE)
,DATENAME(weekDAY,r.KillDate)
,r.SiteIdentifier
END
GO
