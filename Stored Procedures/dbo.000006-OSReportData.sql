SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 24th October 2018
-- Description:	Open Order on relevant Innova 
-- =============================================

--exec [000006-OSReportData]

CREATE PROCEDURE [dbo].[000006-OSReportData]

AS

SELECT  FFGSO, FFGSite, Customer, PostingDate, IPAddress, Username, DateAndTime,  PdaError, Case When OrField='qwe' Then '*OR' Else '' End As orf
FROM   [000006-OSBase]
Where Convert(nvarchar(12),DateAndTime,23)  >= convert(nvarchar(12),GetDate()-1,23) And len(FFGSO)=11
GO
