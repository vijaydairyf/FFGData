SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <24/04/2017>
-- Description:	<Description,,>
-- =============================================

--exec [EDI_RECADV_CSVCreator]

CREATE PROCEDURE [dbo].[EDI_RECADV_CSVCreator]

AS

Create Table myFileList (FileNumber INT IDENTITY, [FileName] VARCHAR(300))


Declare @Path varchar (300) = 'dir C:\EDIRECADV\'
Declare @Command varchar(1024) = @Path + ' /A-D /B'
Declare @FileName nvarchar(300)
Declare @JustFileName nvarchar(300)
Declare @MovedFileName nvarchar(300)
Declare @Filenumber INT
Declare @ReceiptDate Nvarchar(50)
Declare @ExternalDocNo Nvarchar(50)
Declare @QTY Nvarchar(50)
Declare @Customer Nvarchar(50)
Declare @ProductCode Nvarchar(50)
Declare @UnitOfMeasure nvarchar(10)

Insert INTO myFileList
EXEC MASTER.dbo.xp_cmdshell @Command

Select Count (*) from myFileList where [FileName] like '%.H%R'
Select * from  myFileList
While(Select Count (*) from myFileList where [FileName] like '%.H%R')>0

		BEGIN

		--Check the list
		Set @FileName = REPLACE (@Path, 'dir ','') + (SELECT Top 1 [FileName] FROM myFileList where [FileName] like '%.H%R' order by FileNumber)
		PRINT @FileName
		Set @JustFileName = (Select Top 1 [Filename] from myFileList where [FileName] like '%.H%R')
		PRINT @JustFileName
		Set @MovedFileName = REPLACE (@Path, 'dir ' ,'') + 'Processed\'
		PRINT @MovedFileName
		Set @FileNumber = (Select Top 1 Filenumber from myFileList where [FileName] like '%.H%R' order by FileNumber) 
		PRINT @FileNumber


		IF @FileName <> ''

					BEGIN
						Create Table EDIRecAdv_Staging (Line1 nvarchar(max))

						DECLARE @sql varchar(max)
						 set @sql = 'BULK INSERT EDIRecAdv_Staging FROM ''' + 'C:\EDIRECADV\' + @JustFileName + ''' '
							   + '     WITH ( 
											   ROWTERMINATOR = ''\r''
											 ) '
						print @sql
						exec (@sql)

						DECLARE @sql1 varchar(1024)
						Set @sql1 = 'MOVE ' + @FileName + ' ' + @MovedFileName
						EXEC MASTER.dbo.xp_cmdshell @sql1

						Update myFileList Set [FileName] = [FileName] + 'X' Where FileNumber=@Filenumber

						Select Line1
						into #tmp
						from EDIRecAdv_Staging
						where SUBSTRING(Line1,1,3) = ('UNB') or  SUBSTRING(Line1,2,6) = ('DTM+50') or SUBSTRING(Line1,2,6) = ('RFF+ON') or SUBSTRING(Line1,2,3) = ('LIN')
							  or SUBSTRING(Line1,2,3) =('QTY')
	  
						Select * from #tmp
						Select * from myFileList

						Set @Customer =(Select Substring(Line1,12,13)from #tmp where SUBSTRING(Line1,1,3) = ('UNB'));
						Set @ReceiptDate = (Select Substring(Line1,9,8) from #tmp where SUBSTRING(Line1,2,6) = ('DTM+50'));
						Set @ExternalDocNo = (Select Substring(Line1,9,10) from #tmp where SUBSTRING(Line1,2,6) = ('RFF+ON'));
						Set @ProductCode = Case when @Customer = '5790001968229' THEN (Select Substring(Line1,9,13) from #tmp where SUBSTRING(Line1,2,3) = ('LIN'))
										   ELSE (Select Substring(Line1,9,9) from #tmp where SUBSTRING(Line1,2,3) = ('LIN')) END
						Set @QTY = (Select 
							Case When Right(Line1,4) Like '%CR%' Then Replace(Replace(Line1,'QTY+194:',''),':CR''','') 
							Else Replace(Replace(Line1,'QTY+194:',''),':KGM''','') End
							from #tmp where SUBSTRING(Line1,2,3) = ('QTY'))  
						
						SET @UnitOfMeasure = (Select REPLACE(REPLACE(Right(Line1,4),'''',''),':','') from #tmp where SUBSTRING(Line1,2,3) = ('QTY'))  
						
						;
						
						INSERT INTO [dbo].[EDIRecAdv] ([ReceiptDate] ,[ExternalDocNo],[QTY],[Customer],[ProductCode], [UnitOfMeasure])
						VALUES (@ReceiptDate, @ExternalDocNo, @QTY, @Customer, @ProductCode, @UnitOfMeasure)

						drop table EDIRecAdv_Staging
						Drop table #tmp
								
						
					
						

	
					END

					
					
		END

		Drop Table myFileList
		
		--truncate table [dbo].[EDIRecAdv]
GO
