SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,> 2016-11-17
-- =============================================
--EXEC   [usrrep_Group_Order_Returns] 'FC', '10/11/2017','20/11/2017'
-- EXEC   [usrrep_Group_Order_Returns] 'FO', '2017-11-10','2017-11-20'
CREATE PROCEDURE [dbo].[usrrep_Group_Order_Returns] 
	-- Add the parameters for the stored procedure here
	@Site nvarchar(4)


AS

BEGIN
declare @DBname as nvarchar(25)
Declare @SQL as nvarchar(max)
declare @MainSQL as nvarchar(max)

IF @Site = 'FC' 
		begin
			set @DBname = 'FM_Innova'
		end
IF @Site = 'FO'
begin 
set @DBname = 'FO_Innova'
end



	


SET @SQL =' select pp.id as pack, ''''Returned From Order'''' as [Return Type], PM.Code + '''':'''' + cast(pp.lot as nvarchar(10)) + '''':'''' + ord.[name] as Product,
				PM.description1 AS [Name], 1 AS Qty, ROUND(pp.nominal, 2) AS [Weight], 
				ord.[name] AS [Order Number], ord.description2 AS [Customer], ord.dispatchtime AS [Dispatched], pp.po AS [PO]


				, Pp.lot AS [Lot],
					PM.code + '''' : '''' + CAST(Pp.lot AS NVARCHAR(10)) AS [Product/Lot]
					
				

			 from proc_packs pp
			 inner join proc_materials pm (nolock) on pp.material = pm.material
			 INNER JOIN proc_matxacts AS X				WITH (NOLOCK) ON Pp.id = X.pack
				 
			 CROSS APPLY	(SELECT TOP (1) subjectid, regtime FROM proc_packxacts AS PX WHERE pp.id = PX.pack AND xacttype = 4 ORDER BY regtime DESC) AS CA
			  left outer join proc_orders ord on ca.subjectid = ord.[order] 

				WHERE		(NOT (Pp.rtype IN (4, 12))) 
				AND			(X.xactpath IN
							(SELECT	xactpath 
									FROM proc_xactpaths 
											WHERE		(srcprunit = 19) AND (dstprunit = 11)))
				
				AND X.regtime BETWEEN ''''2017-11-17 00:00:00.000'''' AND ''''2017-11-22 00:00:00.000''''

			 '


SET @MainSQL = 'USE ' + @DBname + '; EXEC sp_executesql N''' + @SQL + ''''; EXEC (@MainSQL) 


	
END


GO
