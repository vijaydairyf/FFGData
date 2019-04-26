SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec [dbo].[usrrep_KL_Qty_BySupplier_Picklist] 'FO','2019-03-04','2019-03-06'
CREATE PROCEDURE [dbo].[usrrep_KL_Qty_BySupplier_Picklist]
    -- Add the parameters for the stored procedure here
    @Site NVARCHAR(3)
  , @StartDate DATE
  , @EndDate DATE
AS
BEGIN
    SELECT r.HerdNo
         , r.[KeeperName]
         , FLV.[Address] + '  | ' + FLV.[Address 2] + '  | '+ FLV.City + '  | ' + FLV.[Post Code] AS [Address]
         , r.KillNo
         , r.EartagNo
         , v.Grade
         , v.RegTime
    FROM [FFGData].[dbo].[grp_Animal_Records]                      r
        INNER JOIN dbo.grp_AnimalRecordValues                      v
            ON v.EartagNo = r.EartagNo
               AND v.SiteIdentifier = r.SiteIdentifier
        INNER JOIN FFGSQL01.[FFG-Production].dbo.[FFG LIVE$Vendor] AS FLV
            ON r.HerdNo COLLATE DATABASE_DEFAULT = FLV.[Supplier ID]
    WHERE r.SiteIdentifier = @Site
          AND r.KillDate
          BETWEEN @StartDate AND @EndDate;
END;
GO
