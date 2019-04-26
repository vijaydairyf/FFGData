SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--Truncate Table tblHrOrders

--exec [00002-GranvilleListPalletsInString] 'FFGSO311421'

CREATE PROCEDURE [dbo].[00002-GranvilleListPalletsInString]

@FFGSO As NVarChar(20)

AS 

Select FFGReference, ItemReference Into #t2 From tblExternalData Where FFGReference=@FFGSO

SELECT 
   SS.FFGReference,
	   STUFF((SELECT '|' + US.ItemReference
			  FROM #t2 US
			  WHERE US.FFGReference = @FFGSO
			  FOR XML PATH('')), 1, 1, '') [GPN]
Into #t4
FROM #t2 SS
GROUP BY SS.FFGReference
ORDER BY 1

select * From #t4

Drop Table #t2, #t4
GO
