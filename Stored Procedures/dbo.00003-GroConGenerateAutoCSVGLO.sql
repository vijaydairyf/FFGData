SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Benjamin Aranyi
-- Create date: 12/09/2018
-- Description:	Automatically Generate CSV File Gloucester Site
-- =============================================

--exec [00003-GroConGenerateAutoCSVGLO]

CREATE PROCEDURE [dbo].[00003-GroConGenerateAutoCSVGLO]
AS
BEGIN

	DECLARE @Date DATE 
	DECLARE @FileDate NVarChar(50)
	DECLARE @max_id INT
	DECLARE @Counter NVARCHAR(5)
	DECLARE @InventoryNo INT
	Declare @Site as nvarchar(20)

	set @Site = 'FGL'
	SET @Date = CAST(GETDATE() AS DATE)

	DECLARE @RowCount1 as INT

	Select @RowCount1=ISNull(Count(PalletNo),0) From tblGroConPalletList
	WHERE CONVERT(VARCHAR(10), DueDate, 103)=CONVERT(VARCHAR(10), @Date, 103) AND SiteID=@Site
	And Not FileSent='True' And DateSent Is Null

If @RowCount1>0
	BEGIN

		Update tblGroConPalletList
		Set FileSent='True' 
		WHERE CONVERT(VARCHAR(10), DueDate, 103)=CONVERT(VARCHAR(10), @Date, 103) AND SiteID=@Site
		And Not FileSent='True' And DateSent Is Null

		SELECT @Counter = RIGHT('00000'+ RTRIM(NumberIndicator), 5)  FROM [FFGData].[dbo].[tblLRP] WHERE TableName='GroCon' And [Site]=@Site
		SET @FileDate=CONCAT(FORMAT(@Date,'yyyy'), FORMAT(@Date,'MM'), FORMAT(@Date,'dd'), @Counter)

		UPDATE [FFGData].[dbo].[tblLRP] SET [NumberIndicator] = [NumberIndicator] + 1 WHERE TableName='GroCon' And [Site]=@Site

		Select Top 1 @InventoryNo=PrUnit From [FG_innova].dbo.[proc_prunits] Where [Name]='Grocontinental In-Transit'

		Insert Into [FFGData].dbo.[tblGroConLog]
		(DueDate, Site, ASNRef, ItemNo, Units, Weight, Expiry, PalletNo, KillDate, GCPalletNo, PalletSSCC, RegTime)

		SELECT CONVERT(VARCHAR(10), @Date, 103) AS [DueDate], 'FGL' AS [Site], CONCAT(FORMAT(@Date,'yyyy'), FORMAT(@Date,'MM'), FORMAT(@Date,'dd'), @Counter) AS [ASNRef],
		pm.[code] AS [ItemNo], COUNT(pc.[units]) AS [Units], SUM(ROUND(pp.[nominal],2)) AS [Weight], 
		MIN(CONVERT(VARCHAR(10), pp.[expire1], 103)) AS [Expiry],
		pc.[number] AS [PalletNo], MIN(CONVERT(VARCHAR(10), pp.[expire2], 103))  AS [KillDate], CONCAT(pm.[code],pc.[number]) AS [GCPalletNo], pc.sscc, GetDate()
		FROM [FG_innova].dbo.[proc_collections] pc
		LEFT JOIN [FG_innova].dbo.[proc_packs] pp ON pc.[id] = pp.[pallet]
		INNER JOIN [FG_innova].dbo.[proc_materials] pm ON pp.[material] = pm.[material]
		LEFT JOIN [FFGDATA].DBO.[tblGroConPalletList] gp On pc.[number]=gp.PalletNo And gp.[SiteID]='FGL'
		WHERE pc.inventory = @InventoryNo --AND CAST(pc.invtime AS DATE) = @Date
		And gp.FileSent='True' And gp.DateSent Is Null
		GROUP BY pm.[code], pc.[number], pc.sscc
		ORDER BY pc.[number], pm.[code]

		SELECT DueDate, [Site] As 'Site', ASNRef, ItemNo, Units, Weight, Expiry, PalletNo, KillDate, GCPalletNo, PalletSSCC
		Into ##fglcsv
		From [FFGData].dbo.[tblGroConLog] 
		Where FileSent Is Null And [Site]=@Site
		Order By PalletNo, ItemNo

		Update ##fglcsv Set [Site]='FG' Where [Site]='FGL'

		Declare @RowCount2 Int

		Select @RowCount2=ISNull(Count(PalletNo),0) From ##fglcsv
		If @RowCount2>0 
			BEGIN

				Insert Into ##fglcsv
				(DueDate, Site, ASNRef, ItemNo, Units, Weight, Expiry, PalletNo, KillDate, GCPalletNo)
				Values ('DueDate', 'Site', 'ASNRef', 'Product', 'Units', 'Weight', 'Expiry', 'PalletNo', 'KillDate', 'GCPalletNo')

				DECLARE @Exec12 NVARCHAR(MAX), @sql11 VARCHAR(1000)
				SET @sql11 = '"SELECT QuoteName(DueDate,CHAR(34)), QuoteName(Site,CHAR(34)), QuoteName(ASNRef,CHAR(34)), QuoteName(ItemNo,CHAR(34)), QuoteName(Units,CHAR(34)), QuoteName(Weight,CHAR(34)), QuoteName(Expiry,CHAR(34)), QuoteName(PalletNo,CHAR(34)), QuoteName(KillDate,CHAR(34)), QuoteName(GCPalletNo,CHAR(34)) From ##fglcsv Order By DueDate Desc, PalletNo, ItemNo"'  
				SET @Exec12 = 'exec master.dbo.xp_cmdshell ''bcp '+@sql11+' queryout "\\ffgapp03\Shared\GroConFiles\FGL'+@FileDate+'.csv" -c -t, -T'''
				EXECUTE sp_executesql @Exec12

				Update [FFGDATA].DBO.[tblGroConLog] 
				Set FileSent='OK', SentTime=GetDate(), [FileName]='FGL'+@FileDate+'.csv'
				Where ASNRef=@FileDate And [Site]=@Site

				INSERT Into [FFGUtility].dbo.[COST_InteractionLog]
				(UserName,Action,AuditTime)
				Values ('Automatic Generation','CSV file has been generated',GETDATE())

				Update tblGroConPalletList 
				Set FileSent='True',
				DateSent=GetDate(),
				ASN=@FileDate
				Where PalletNo In (Select PalletNo From tblGroConLog Where ASNRef=@FileDate And [Site]=@Site) And SiteID=@Site
			END

		Drop Table ##fglcsv
	END
END
GO
