SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Tommy 
-- Create date: 22/08/2016?
-- Description:	Stock Interface to NAV
-- =============================================

--EXEC [APP_P2_Stock_NAV_Interface]
CREATE PROCEDURE [dbo].[APP_P2_Stock_NAV_Interface] 

AS

BEGIN

	SET NOCOUNT ON;
--------------------------------------------------------------------------------------------
-- TMP Table set up for Innova 
--------------------------------------------------------------------------------------------

Update t
Set TimeIndicator=GETDATE(), NumberIndicator='1'
From FFGData.dbo.tblLRP t
Where ID=17

create table #InnovaTMP ([SITE] nvarchar (3)
      ,[ProductCode] bigint
      ,PalletNo  bigint 
      ,[Lot code]  bigint 
      ,[KillDate] datetime
      ,[PackDate] datetime
      ,[UseBy] datetime
      ,[DNOB] datetime
      ,[Inventory] nvarchar (80)
      ,[Inventory Location] nvarchar (20)
      ,[QTY] decimal(18,0)
      ,[Weight] decimal(18,2)
	  ,[ExtCode] nvarchar (50)
	

)
--------------------------------------------------------------------------------------------
-- TMP Table set up for NAV 
--------------------------------------------------------------------------------------------
create table #NAVTMP ([SITE] nvarchar (3)
      ,[ProductCode] bigint
      ,PalletNo  bigint 
      ,[Lot code]  bigint 
      ,[KillDate] datetime
      ,[PackDate] datetime
      ,[UseBy] datetime
      ,[DNOB] datetime
      ,[Inventory] nvarchar (80)
      ,[Inventory Location] nvarchar (20)
      ,[QTY] decimal(18,0)
      ,[Weight] decimal(18,2)
	  ,[ExtCode] nvarchar(50)
	 

)

--------------------------------------------------------------------------------------------
-- TMP Table set up for NAV and Innova Compare
--------------------------------------------------------------------------------------------
create table #Compare
(	
	 
	[SITE] nvarchar (3)
	,[ProductCode] bigint
	,[PalletNO] bigint
	,[Lot code] bigint
	,[KillDate] datetime
	,[PackDate] datetime
	,[UseBy] datetime
	,[DNOB] datetime
	,[Inventory] nvarchar (80)
	,[InventoryLocation] nvarchar (20)
	,[ExtCode] nvarchar(50)
	,[INVQTY] decimal(18,0)
	,[INVWGT] decimal(18,2)
	,[NAVQTY] decimal(18,0)
	,[NAVWGT] decimal(18,2)
	,[QTY_DIFF] decimal(18,0)
	,[WGT_DIFF] decimal(18,2)

)


--------------------------------------------------------------------------------------------
-- Collect STOCK SNAPSHOT from Innova's Input into TMP Table for compare against NAV Table 
--------------------------------------------------------------------------------------------
insert into #InnovaTMP
			select * from  [FO_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK]
insert into #InnovaTMP
			select * from  [FD_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK]
insert into #InnovaTMP
			select * from  [FM_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK]
insert into #InnovaTMP
			select * from  [FH_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK]
insert into #InnovaTMP
			select * from  [FG_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK]
insert into #InnovaTMP
			select * from  [FMM_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK]
insert into #InnovaTMP
			select * from  [FI_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK]
--insert into #InnovaTMP
--			select * from  [test1-Innova].[dbo].[VW_NAV_AVAILABLE_STOCK]

--------------------------------------------------------------------------------------------
-- Collect Stock SNAPSHOT from NAV/ Input into TMP Table for compare aginst Innova Table
--------------------------------------------------------------------------------------------
INSERT INTO #NAVTMP

Select * from [FFGSQL01].[FFG-Production].[dbo].[VW_NAV_AVAILABLE_STOCK]

--------------------------------------------------------------------------------------------
--Compare 2 TMP Tables from innova side
--------------------------------------------------------------------------------------------
insert into #Compare

select   
IT.[SITE],IT.ProductCode,isnull(IT.PalletNo,0) as PalletNO,IT.[Lot code],IT.KillDate,IT.PackDate,IT.UseBy,isnull(IT.DNOB,'1753-01-01 00:00:00.000') as DNOB,isnull(IT.Inventory,'') As Inventory,isnull(IT.[Inventory Location],'') as InventoryLocation, IT.ExtCode, IT.QTY as INVQTY,IT.[Weight] as INVWGT,

--NAV QTY AND WEIGHT
Isnull((SELECT TP.QTY from #NAVTMP TP where TP.ExtCode = IT.ExtCode AND TP.[SITE] =IT.[SITE]  AND TP.[PRODUCTCODE] =IT.[PRODUCTCODE] AND  ISNULL(TP.[PALLETNO],0) = ISNULL(IT.[PALLETNO],0)  AND TP.[LOT CODE] =IT.[LOT CODE] AND  TP.[KILLDATE] =IT.[KILLDATE]  AND  TP.PACKDATE = IT.PACKDATE AND  TP.USEBY =IT.USEBY  AND  ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(IT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(TP.INVENTORY,'') = ISNULL(IT.INVENTORY,'') AND  ISNULL(TP.[INVENTORY LOCATION],'') = ISNULL(IT.[INVENTORY LOCATION],'')),0) AS NAVQTY,
Isnull((SELECT TP.[WEIGHT] from #NAVTMP TP where IT.ExtCode = TP.ExtCode AND IT.[SITE]= TP.[SITE] AND IT.[PRODUCTCODE] = TP.[PRODUCTCODE]  AND ISNULL(IT.[PALLETNO],0) = ISNULL(TP.[PALLETNO],0) AND IT.[LOT CODE]= TP.[LOT CODE] AND IT.[KILLDATE] = TP.[KILLDATE] AND IT.PACKDATE = TP.PACKDATE AND IT.USEBY = TP.USEBY AND ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(IT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(IT.INVENTORY,'') = ISNULL(TP.INVENTORY,'') AND ISNULL(IT.[INVENTORY LOCATION],'') = ISNULL(TP.[INVENTORY LOCATION],'')),0) AS NAVWGT,

--QTY AND WGT DIFF
(IT.QTY - Isnull((SELECT TP.QTY from #NAVTMP TP where TP.ExtCode = IT.ExtCode AND TP.[SITE] =IT.[SITE]  AND TP.[PRODUCTCODE] =IT.[PRODUCTCODE] AND  ISNULL(TP.[PALLETNO],0) = ISNULL(IT.[PALLETNO],0)  AND TP.[LOT CODE] =IT.[LOT CODE] AND  TP.[KILLDATE] =IT.[KILLDATE]  AND  TP.PACKDATE = IT.PACKDATE AND  TP.USEBY =IT.USEBY  AND  ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(IT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(TP.INVENTORY,'') = ISNULL(IT.INVENTORY,'') AND  ISNULL(TP.[INVENTORY LOCATION],'') = ISNULL(IT.[INVENTORY LOCATION],'')),0))AS QTY_DIFF,
(IT.[Weight] - Isnull((SELECT TP.[WEIGHT] from #NAVTMP TP where IT.ExtCode = TP.ExtCode AND IT.[SITE]= TP.[SITE] AND IT.[PRODUCTCODE] = TP.[PRODUCTCODE]  AND ISNULL(IT.[PALLETNO],0) = ISNULL(TP.[PALLETNO],0) AND IT.[LOT CODE]= TP.[LOT CODE] AND IT.[KILLDATE] = TP.[KILLDATE] AND IT.PACKDATE = TP.PACKDATE AND IT.USEBY = TP.USEBY AND ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(IT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(IT.INVENTORY,'') = ISNULL(TP.INVENTORY,'') AND ISNULL(IT.[INVENTORY LOCATION],'') = ISNULL(TP.[INVENTORY LOCATION],'')),0) ) AS WGT_DIFF

From
#InnovaTMP IT (NOLOCK)
where (IT.QTY - Isnull((SELECT TP.QTY from #NAVTMP TP where TP.ExtCode = IT.ExtCode AND TP.[SITE] =IT.[SITE]  AND TP.[PRODUCTCODE] =IT.[PRODUCTCODE] AND  ISNULL(TP.[PALLETNO],0) = ISNULL(IT.[PALLETNO],0)  AND TP.[LOT CODE] =IT.[LOT CODE] AND  TP.[KILLDATE] =IT.[KILLDATE]  AND  TP.PACKDATE = IT.PACKDATE AND  TP.USEBY =IT.USEBY  AND  ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(IT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(TP.INVENTORY,'') = ISNULL(IT.INVENTORY,'') AND  ISNULL(TP.[INVENTORY LOCATION],'') = ISNULL(IT.[INVENTORY LOCATION],'')),0)) <> 0
AND (IT.[Weight] - Isnull((SELECT TP.[WEIGHT] from #NAVTMP TP where IT.ExtCode = TP.ExtCode AND IT.[SITE]= TP.[SITE] AND IT.[PRODUCTCODE] = TP.[PRODUCTCODE]  AND ISNULL(IT.[PALLETNO],0) = ISNULL(TP.[PALLETNO],0) AND IT.[LOT CODE]= TP.[LOT CODE] AND IT.[KILLDATE] = TP.[KILLDATE] AND IT.PACKDATE = TP.PACKDATE AND IT.USEBY = TP.USEBY AND ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(IT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(IT.INVENTORY,'') = ISNULL(TP.INVENTORY,'') AND ISNULL(IT.[INVENTORY LOCATION],'') = ISNULL(TP.[INVENTORY LOCATION],'')),0) ) <> 0
and KillDate is not null and PackDate is not null and useby is not null
--order by NAVQTY desc

union
--------------------------------------------------------------------------------------------
--Compare 2 TMP Tables from NAV Side
--------------------------------------------------------------------------------------------


select 

NT.[SITE],NT.ProductCode,isnull(NT.PalletNo,0) as PalletNO,NT.[Lot code],NT.KillDate,NT.PackDate,NT.UseBy,isnull(NT.DNOB,'1753-01-01 00:00:00.000') as DNOB,isnull(NT.Inventory,'') As Inventory,isnull(NT.[Inventory Location],'') as InventoryLocation, NT.ExtCode,  

--NAV QTY AND WEIGHT
Isnull((SELECT TP.QTY from #InnovaTMP TP where TP.ExtCode = NT.ExtCode AND TP.[SITE] =NT.[SITE]  AND TP.[PRODUCTCODE] =NT.[PRODUCTCODE] AND  ISNULL(TP.[PALLETNO],0) = ISNULL(NT.[PALLETNO],0)  AND TP.[LOT CODE] =NT.[LOT CODE] AND  TP.[KILLDATE] =NT.[KILLDATE]  AND  TP.PACKDATE = NT.PACKDATE AND  TP.USEBY =NT.USEBY  AND  ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(NT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(TP.INVENTORY,'') = ISNULL(NT.INVENTORY,'') AND  ISNULL(TP.[INVENTORY LOCATION],'') = ISNULL(NT.[INVENTORY LOCATION],'')),0) AS INVQTY,
Isnull((SELECT TP.[WEIGHT] from #InnovaTMP TP where NT.ExtCode = TP.ExtCode AND NT.[SITE]= TP.[SITE] AND NT.[PRODUCTCODE] = TP.[PRODUCTCODE]  AND ISNULL(NT.[PALLETNO],0) = ISNULL(TP.[PALLETNO],0) AND NT.[LOT CODE]= TP.[LOT CODE] AND NT.[KILLDATE] = TP.[KILLDATE] AND NT.PACKDATE = TP.PACKDATE AND NT.USEBY = TP.USEBY AND ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(NT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(NT.INVENTORY,'') = ISNULL(TP.INVENTORY,'') AND ISNULL(NT.[INVENTORY LOCATION],'') = ISNULL(TP.[INVENTORY LOCATION],'')),0) AS INVWGT,
NT.QTY as  NAVQTY, NT.[Weight] as NAVWGT ,

--QTY AND WGT DIFF
(Isnull((SELECT TP.QTY from #InnovaTMP TP where TP.ExtCode = NT.ExtCode AND TP.[SITE] =NT.[SITE]  AND TP.[PRODUCTCODE] =NT.[PRODUCTCODE] AND  ISNULL(TP.[PALLETNO],0) = ISNULL(NT.[PALLETNO],0)  AND TP.[LOT CODE] =NT.[LOT CODE] AND  TP.[KILLDATE] =NT.[KILLDATE]  AND  TP.PACKDATE = NT.PACKDATE AND  TP.USEBY =NT.USEBY  AND  ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(NT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(TP.INVENTORY,'') = ISNULL(NT.INVENTORY,'') AND  ISNULL(TP.[INVENTORY LOCATION],'') = ISNULL(NT.[INVENTORY LOCATION],'')),0)- NT.QTY )AS QTY_DIFF,
(Isnull((SELECT TP.[WEIGHT] from #InnovaTMP TP where NT.ExtCode = TP.ExtCode AND NT.[SITE]= TP.[SITE] AND NT.[PRODUCTCODE] = TP.[PRODUCTCODE]  AND ISNULL(NT.[PALLETNO],0) = ISNULL(TP.[PALLETNO],0) AND NT.[LOT CODE]= TP.[LOT CODE] AND NT.[KILLDATE] = TP.[KILLDATE] AND NT.PACKDATE = TP.PACKDATE AND NT.USEBY = TP.USEBY AND ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(NT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(NT.INVENTORY,'') = ISNULL(TP.INVENTORY,'') AND ISNULL(NT.[INVENTORY LOCATION],'') = ISNULL(TP.[INVENTORY LOCATION],'')),0)-NT.[Weight] ) AS WGT_DIFF

From
#NAVTMP NT (NOLOCK)
where ( Isnull((SELECT TP.QTY from #InnovaTMP TP where TP.ExtCode = NT.ExtCode AND TP.[SITE] =NT.[SITE]  AND TP.[PRODUCTCODE] =NT.[PRODUCTCODE] AND  ISNULL(TP.[PALLETNO],0) = ISNULL(NT.[PALLETNO],0)  AND TP.[LOT CODE] =NT.[LOT CODE] AND  TP.[KILLDATE] =NT.[KILLDATE]  AND  TP.PACKDATE = NT.PACKDATE AND  TP.USEBY =NT.USEBY  AND  ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(NT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(TP.INVENTORY,'') = ISNULL(NT.INVENTORY,'') AND  ISNULL(TP.[INVENTORY LOCATION],'') = ISNULL(NT.[INVENTORY LOCATION],'')),0) - NT.QTY) <> 0
AND ( Isnull((SELECT TP.[WEIGHT] from #InnovaTMP TP where NT.ExtCode = TP.ExtCode AND NT.[SITE]= TP.[SITE] AND NT.[PRODUCTCODE] = TP.[PRODUCTCODE]  AND ISNULL(NT.[PALLETNO],0) = ISNULL(TP.[PALLETNO],0) AND NT.[LOT CODE]= TP.[LOT CODE] AND NT.[KILLDATE] = TP.[KILLDATE] AND NT.PACKDATE = TP.PACKDATE AND NT.USEBY = TP.USEBY AND ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(NT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(NT.INVENTORY,'') = ISNULL(TP.INVENTORY,'') AND ISNULL(NT.[INVENTORY LOCATION],'') = ISNULL(TP.[INVENTORY LOCATION],'')),0) - NT.[Weight] ) <> 0
and KillDate is not null and PackDate is not null and useby is not null
ORDER BY [SITE], ProductCode, PackDate, [Lot code], NAVQTY

declare @orderLogCheck int

-------------------------------------------------------------------------------------------------------------
set @orderLogCheck = (select count(*) from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Order Log] with (nolock) where cast([Date Imported] as date) = cast(getdate() as date) AND Processed = 0 and [Errors Exist] <> 1 and [Message Type] = 'STK'  )

--------------------------------------------------------------------------------------------
--INPUT TRANSACTIONS INTO OUR LOG TABLE - SP Will take from LOG Table to Order Import Table every 2 minutes
--------------------------------------------------------------------------------------------

if (@orderLogCheck <> 0 )
	begin

			Update t
			Set TimeIndicator=GETDATE(), NumberIndicator='0'
			From FFGData.dbo.tblLRP t
			Where ID=17
	
			return

	end
	
else 

begin

--------------------------------------------------------------------------------------------
--INPUT TRANSACTIONS INTO OUR LOG TABLE - SP Will take from LOG Table to Order Import Table every 2 minutes
--------------------------------------------------------------------------------------------
Insert into [FFGSQL01].[FFG-Production].[dbo].[APP_NAV_TRANSACTIONS_LOGS] 
([extCode],[SITE],[ProductCode],[PalletNO],[Lot code],[KillDate],[PackDate],[UseBy],[DNOB],[Inventory],[InventoryLocation],[INVQTY],[INVWGT],[NAVQTY],[NAVWGT],[QTY_DIFF],[WGT_DIFF],[Processed],[Imported To NAV])

select distinct extcode, [SITE]    ,ProductCode  ,PalletNO      ,[Lot code]      ,KillDate   ,PackDate   ,UseBy   ,DNOB   ,Inventory    ,InventoryLocation   ,INVQTY,INVWGT,NAVQTY,NAVWGT,QTY_DIFF,WGT_DIFF,0,NULL

From #Compare t
where NOT EXISTS  (select  *  from  [FFGSQL01].[FFG-Production].[dbo].[APP_NAV_TRANSACTIONS_LOGS]  L (NOLOCK) where L.[EXTCODE] collate SQL_Latin1_General_CP850_CI_AS  = T.[ExtCode] AND L.[SITE] collate SQL_Latin1_General_CP850_CI_AS  = T.[SITE]   AND L.[ProductCode]  = t.[ProductCode]  AND L.[PalletNO] collate SQL_Latin1_General_CP850_CI_AS   = t.[PalletNO]     AND L.[Lot code] collate SQL_Latin1_General_CP850_CI_AS  = t.[Lot code]      AND L.[KillDate]  = t.[KillDate]  AND L.[PackDate]  = t.[PackDate]   AND L.[UseBy] = t.[UseBy] AND L.[DNOB] = t.[DNOB] AND L.[Inventory] collate SQL_Latin1_General_CP850_CI_AS  = t.[Inventory] AND L.[InventoryLocation] collate SQL_Latin1_General_CP850_CI_AS = t.[InventoryLocation]  AND ([Processed]  <> 1 OR isnull([Imported To NAV]  ,'')  > dateadd(MINUTE,-1,getdate())) )
AND NOT EXISTS  (select * from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Order - Import] OI(NOLOCK) where OI.[External Ref_] collate SQL_Latin1_General_CP1_CI_AS = t.[ExtCode] AND case when OI.[Stock Site] = 11 then 'FC' when OI.[Stock Site] = 28 then 'FI' when OI.[Stock Site] = 12 then 'FD' when OI.[Stock Site] = 13 then 'FO' when OI.[Stock Site] = 14 then 'FMM' when OI.[Stock Site] = 15 then 'FGL'  when OI.[Stock Site] = 16 then 'FH' when OI.[Stock Site] = 29 then 'FT' else '' end = t.[SITE] AND 
				 OI.[Item No_] = t.[ProductCode] AND OI.[Pallet No_] collate SQL_Latin1_General_CP1_CI_AS = t.[PalletNO] AND OI.[Innova Lot No_] collate SQL_Latin1_General_CP1_CI_AS = t.[Lot code] AND OI.[Kill Date] = t.[KillDate] AND OI.[Pack Date] = t.[PackDate] AND OI.[Use By Date] = t.[UseBy] AND OI.[DNOB] = t.[DNOB] AND OI.[Innova Inventory] collate SQL_Latin1_General_CP1_CI_AS = t.[Inventory] AND OI.[Innova Inventory Location] collate SQL_Latin1_General_CP1_CI_AS = t.[InventoryLocation])
order by [site], productcode, [PackDate], [lot code]

END

--------------------------------------------------------------------------------------------
--Checks put in place to make sure that all data going to LOG table is not awaiting to be 
--processed by either the LOG table or by the Order import table. 
--Also added a 2 minute wait on all transactions that have been processed in the last 2 minutes
--------------------------------------------------------------------------------------------

drop table #InnovaTMP
drop table #NAVTMP
drop table #Compare

			Update t
			Set TimeIndicator=GETDATE(), NumberIndicator='0'
			From FFGData.dbo.tblLRP t
			Where ID=17

END

GO
