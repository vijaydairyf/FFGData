SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Benjamin Aranyi
-- Create date: 29/08/2018
-- Description:	Generate inhouse receipt file
-- =============================================

-- exec [00003-GroConGenerateInhouseCSV] '2018082800043' 'FG'

CREATE PROCEDURE [dbo].[00003-GroConGenerateInhouseCSV]

	@ASNRef AS NVARCHAR(50),
	@Site AS NVARCHAR(20)

AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @Date AS NVARCHAR(20)
	SET @Date = FORMAT(GETDATE(),'ddMMyyhhmmss')

	SELECT GCPalletNo, FORMAT(GETDATE(),'dd/MM/yyyy') AS 'ReceiptDate', ASNRef, ItemNo AS 'Product', Units, [Weight]
	Into ##fgrocsv
	FROM [FFGData].[dbo].[tblGroConLog]
	WHERE ASNRef=@ASNRef

	DECLARE @Exec2 NVARCHAR(MAX), @sql1 VARCHAR(1000)
	SET @sql1 ='"SELECT QuoteName(GCPalletNo,CHAR(34)), QuoteName(ReceiptDate,CHAR(34)), QuoteName(ASNRef,CHAR(34)), QuoteName(Product,CHAR(34)), QuoteName(Units,CHAR(34)), QuoteName(Weight,CHAR(34)) From ##fgrocsv"'  
	SET @Exec2 = 'exec master.dbo.xp_cmdshell ''bcp '+@sql1+' queryout "\\ffgapp03\Shared\GroConEmail\Exports\GRO_Receipt_'+@Site+@Date+'_Inhouse.csv" -c -t, -T'''
	EXECUTE sp_executesql @Exec2
	Drop Table ##fgrocsv

END
GO
