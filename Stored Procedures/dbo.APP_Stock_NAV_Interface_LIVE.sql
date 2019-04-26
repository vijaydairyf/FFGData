SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Tommy 
-- Create date: 22/08/2016?
-- Description:	Stock Interface to NAV
-- =============================================

--EXEC [APP_Stock_NAV_Interface_LIVE]
CREATE PROCEDURE [dbo].[APP_Stock_NAV_Interface_LIVE] 

	@UseFOLive bit = 0,
	@UseFCLive bit = 0,
	@UseFGLive bit = 0,
	@UseFDLive bit = 0,
	@UseFHLive bit = 0,
	@UseFMMLive bit = 0,
	@UseFILive bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



--------------------------------------------------------------------------------------------
-- TMP Table set up for Innova 
--------------------------------------------------------------------------------------------
create table #InnovaTMP ([SITE] nvarchar (3)
      ,[ProductCode] bigint
      ,PalletNo  nvarchar(20) 
      ,[Lot code]  nvarchar(20) 
      ,[KillDate] datetime
      ,[PackDate] datetime
      ,[UseBy] datetime
      ,[DNOB] datetime
      ,[Inventory] nvarchar (80)
      ,[Inventory Location] nvarchar (20)
      ,[QTY] decimal(6,0)
      ,[Weight] decimal(6,2)
	  ,extcode nvarchar(50)
)

--------------------------------------------------------------------------------------------
-- TMP Table set up for NAV 
--------------------------------------------------------------------------------------------
create table #NAVTMP ([SITE] nvarchar (3)
      ,[ProductCode] bigint
      ,PalletNo  nvarchar(20) 
      ,[Lot code]  nvarchar(20) 
      ,[KillDate] datetime
      ,[PackDate] datetime
      ,[UseBy] datetime
      ,[DNOB] datetime
      ,[Inventory] nvarchar (80)
      ,[Inventory Location] nvarchar (20)
      ,[QTY] decimal(6,0)
      ,[Weight] decimal(6,2)
)

--------------------------------------------------------------------------------------------
-- TMP Table set up for NAV and Innova Compare
--------------------------------------------------------------------------------------------
create table #Compare
(	
	[SITE] nvarchar (3)
	,[ProductCode] bigint
	,[PalletNO] nvarchar(20)
	,[Lot code] nvarchar(20)
	,[KillDate] datetime
	,[PackDate] datetime
	,[UseBy] datetime
	,[DNOB] datetime
	,[Inventory] nvarchar (80)
	,[InventoryLocation] nvarchar (20)
	,[INVQTY] decimal(6,0)
	,[INVWGT] decimal(6,2)
	,[NAVQTY] decimal(6,0)
	,[NAVWGT] decimal(6,2)
	,[QTY_DIFF] decimal(6,0)
	,[WGT_DIFF] decimal(6,2)
)


--------------------------------------------------------------------------------------------
-- Collect STOCK SNAPSHOT from Innova's Input into TMP Table for compare against NAV Table 
--------------------------------------------------------------------------------------------
	--- OMAGH
	if(@UseFOLive = 0)
		BEGIN
			insert into #InnovaTMP
				select * from  [FO_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK] with (nolock)
		END
	else
		BEGIN
			-- todo : Add Omagh Live when Campsie Tested - Linked Server and Create View on Live Innova
			insert into #InnovaTMP
				select * from  [FO_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK] with (nolock)
		END

	-- DONEGAL
	if(@UseFDLive = 0)
		BEGIN
			insert into #InnovaTMP
				select * from  [FD_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK] with (nolock) 
		END
	else
		BEGIN
			-- todo : Add Donegal Live when Campsie Tested
			insert into #InnovaTMP
				select * from  [FD_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK] with (nolock)
		END


	-- CAMPSIE
	if(@UseFCLive = 0)	
		BEGIN
			insert into #InnovaTMP
				select * from  [FM_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK] with (nolock)
		END
	else
		BEGIN
			insert into #InnovaTMP
				select * from  [FM_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK] with (nolock)
				--select * from  [CAMSQL01].[Innova].[dbo].[VW_NAV_AVAILABLE_STOCK] with (nolock)
		END


	-- GLOUCESTER
	if(@UseFGLive = 0)
		BEGIN
			insert into #InnovaTMP
				select * from  [FG_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK] with (nolock)
		END
	ELSE
		BEGIN
			-- todo : Add Gloucester Live when Campsie Tested
			insert into #InnovaTMP
				select * from  [FG_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK] with (nolock)
		END
	
	if(@UseFHLive = 0)
		BEGIN
			insert into #InnovaTMP
				select * from  [FH_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK] with (nolock)
		END
	ELSE
		BEGIN
			-- todo : Add Hilton Live when Campsie Tested
			insert into #InnovaTMP
				select * from  [FH_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK] with (nolock)
		END
	
	if(@UseFMMLive = 0)
		BEGIN
			insert into #InnovaTMP
				select * from  [FMM_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK] with (nolock)
		END
	ELSE
		BEGIN
			-- todo : Add Melton Live when Campsie Tested
			insert into #InnovaTMP
				select * from  [FMM_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK] with (nolock)
		END
	
	-- Ingredients
	if(@UseFILive = 0)	
		BEGIN
			insert into #InnovaTMP
				select * from  [FI_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK] with (nolock)
		END
	else
		BEGIN
			insert into #InnovaTMP
				select * from  [INGSQL01].[FI_Innova].[dbo].[VW_NAV_AVAILABLE_STOCK] with (nolock)
		END





--select 'innova',* from #InnovaTMP
--------------------------------------------------------------------------------------------
-- Collect Stock SNAPSHOT from NAV/ Input into TMP Table for compare aginst Innova Table
--------------------------------------------------------------------------------------------
 INSERT INTO #NAVTMP
select * from [FFGSQL01].[FFG-Production].[dbo].[VW_NAV_AVAILABLE_STOCK]

--select 'NAV', * from #NAVTMP

--------------------------------------------------------------------------------------------
--Compare 2 TMP Tables from innova side
--------------------------------------------------------------------------------------------
 insert into #Compare

select   IT.[SITE],IT.ProductCode,isnull(IT.PalletNo,0) as PalletNO,IT.[Lot code],IT.KillDate,IT.PackDate,IT.UseBy,isnull(IT.DNOB,'1753-01-01 00:00:00.000') as DNOB,isnull(IT.Inventory,'') As Inventory,isnull(IT.[Inventory Location],'') as InventoryLocation, IT.QTY as INVQTY,IT.[Weight] as INVWGT,

--NAV QTY AND WEIGHT
Isnull((SELECT TP.QTY from #NAVTMP TP where TP.[SITE] =IT.[SITE]  AND TP.[PRODUCTCODE] =IT.[PRODUCTCODE] AND  ISNULL(TP.[PALLETNO],0) = ISNULL(IT.[PALLETNO],0)  AND TP.[LOT CODE] =IT.[LOT CODE] AND  TP.[KILLDATE] =IT.[KILLDATE]  AND  TP.PACKDATE = IT.PACKDATE AND  TP.USEBY =IT.USEBY  AND  ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(IT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(TP.INVENTORY,'') = ISNULL(upper(IT.INVENTORY),'') AND  ISNULL(TP.[INVENTORY LOCATION],'') = ISNULL(IT.[INVENTORY LOCATION],'')),0) AS NAVQTY,
Isnull((SELECT TP.[WEIGHT] from #NAVTMP TP where IT.[SITE]= TP.[SITE] AND IT.[PRODUCTCODE] = TP.[PRODUCTCODE]  AND ISNULL(IT.[PALLETNO],0) = ISNULL(TP.[PALLETNO],0) AND IT.[LOT CODE]= TP.[LOT CODE] AND IT.[KILLDATE] = TP.[KILLDATE] AND IT.PACKDATE = TP.PACKDATE AND IT.USEBY = TP.USEBY AND ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(IT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(IT.INVENTORY,'') = ISNULL(upper(TP.INVENTORY),'') AND ISNULL(IT.[INVENTORY LOCATION],'') = ISNULL(TP.[INVENTORY LOCATION],'')),0) AS NAVWGT,

--QTY AND WGT DIFF
(IT.QTY - Isnull((SELECT TP.QTY from #NAVTMP TP where TP.[SITE] =IT.[SITE]  AND TP.[PRODUCTCODE] =IT.[PRODUCTCODE] AND  ISNULL(TP.[PALLETNO],0) = ISNULL(IT.[PALLETNO],0)  AND TP.[LOT CODE] =IT.[LOT CODE] AND  TP.[KILLDATE] =IT.[KILLDATE]  AND  TP.PACKDATE = IT.PACKDATE AND  TP.USEBY =IT.USEBY  AND  ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(IT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(TP.INVENTORY,'') = ISNULL(upper(IT.INVENTORY),'') AND  ISNULL(TP.[INVENTORY LOCATION],'') = ISNULL(IT.[INVENTORY LOCATION],'')),0))AS QTY_DIFF,
(IT.[Weight] - Isnull((SELECT TP.[WEIGHT] from #NAVTMP TP where IT.[SITE]= TP.[SITE] AND IT.[PRODUCTCODE] = TP.[PRODUCTCODE]  AND ISNULL(IT.[PALLETNO],0) = ISNULL(TP.[PALLETNO],0) AND IT.[LOT CODE]= TP.[LOT CODE] AND IT.[KILLDATE] = TP.[KILLDATE] AND IT.PACKDATE = TP.PACKDATE AND IT.USEBY = TP.USEBY AND ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(IT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(IT.INVENTORY,'') = ISNULL(upper(TP.INVENTORY),'') AND ISNULL(IT.[INVENTORY LOCATION],'') = ISNULL(TP.[INVENTORY LOCATION],'')),0) ) AS WGT_DIFF

From
#InnovaTMP IT (NOLOCK)
where ((IT.QTY - Isnull((SELECT TP.QTY from #NAVTMP TP where TP.[SITE] =IT.[SITE]  AND TP.[PRODUCTCODE] =IT.[PRODUCTCODE] AND  ISNULL(TP.[PALLETNO],0) = ISNULL(IT.[PALLETNO],0)  AND TP.[LOT CODE] =IT.[LOT CODE] AND  TP.[KILLDATE] =IT.[KILLDATE]  AND  TP.PACKDATE = IT.PACKDATE AND  TP.USEBY =IT.USEBY  AND  ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(IT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(TP.INVENTORY,'') = ISNULL(upper(IT.INVENTORY),'') AND  ISNULL(TP.[INVENTORY LOCATION],'') = ISNULL(IT.[INVENTORY LOCATION],'')),0)) <> 0
OR (IT.[Weight] - Isnull((SELECT TP.[WEIGHT] from #NAVTMP TP where IT.[SITE]= TP.[SITE] AND IT.[PRODUCTCODE] = TP.[PRODUCTCODE]  AND ISNULL(IT.[PALLETNO],0) = ISNULL(TP.[PALLETNO],0) AND IT.[LOT CODE]= TP.[LOT CODE] AND IT.[KILLDATE] = TP.[KILLDATE] AND IT.PACKDATE = TP.PACKDATE AND IT.USEBY = TP.USEBY AND ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(IT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(IT.INVENTORY,'') = ISNULL(upper(TP.INVENTORY),'') AND ISNULL(IT.[INVENTORY LOCATION],'') = ISNULL(TP.[INVENTORY LOCATION],'')),0) ) <> 0)
and KillDate is not null and PackDate is not null and useby is not null
--order by NAVQTY desc

union
--------------------------------------------------------------------------------------------
--Compare 2 TMP Tables from NAV Side
--------------------------------------------------------------------------------------------


select  NT.[SITE],NT.ProductCode,isnull(NT.PalletNo,0) as PalletNO,NT.[Lot code],NT.KillDate,NT.PackDate,NT.UseBy,isnull(NT.DNOB,'1753-01-01 00:00:00.000') as DNOB,isnull(NT.Inventory,'') As Inventory,isnull(NT.[Inventory Location],'') as InventoryLocation, 

--NAV QTY AND WEIGHT
Isnull((SELECT TP.QTY from #InnovaTMP TP where TP.[SITE] =NT.[SITE]  AND TP.[PRODUCTCODE] =NT.[PRODUCTCODE] AND  ISNULL(TP.[PALLETNO],0) = ISNULL(NT.[PALLETNO],0)  AND TP.[LOT CODE] =NT.[LOT CODE] AND  TP.[KILLDATE] =NT.[KILLDATE]  AND  TP.PACKDATE = NT.PACKDATE AND  TP.USEBY =NT.USEBY  AND  ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(NT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(TP.INVENTORY,'') = ISNULL(NT.INVENTORY,'') AND  ISNULL(TP.[INVENTORY LOCATION],'') = ISNULL(NT.[INVENTORY LOCATION],'')),0) AS INVQTY,
Isnull((SELECT TP.[WEIGHT] from #InnovaTMP TP where NT.[SITE]= TP.[SITE] AND NT.[PRODUCTCODE] = TP.[PRODUCTCODE]  AND ISNULL(NT.[PALLETNO],0) = ISNULL(TP.[PALLETNO],0) AND NT.[LOT CODE]= TP.[LOT CODE] AND NT.[KILLDATE] = TP.[KILLDATE] AND NT.PACKDATE = TP.PACKDATE AND NT.USEBY = TP.USEBY AND ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(NT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(NT.INVENTORY,'') = ISNULL(TP.INVENTORY,'') AND ISNULL(NT.[INVENTORY LOCATION],'') = ISNULL(TP.[INVENTORY LOCATION],'')),0) AS INVWGT,
NT.QTY as  NAVQTY, NT.[Weight] as NAVWGT ,

--QTY AND WGT DIFF
(Isnull((SELECT TP.QTY from #InnovaTMP TP where TP.[SITE] =NT.[SITE]  AND TP.[PRODUCTCODE] =NT.[PRODUCTCODE] AND  ISNULL(TP.[PALLETNO],0) = ISNULL(NT.[PALLETNO],0)  AND TP.[LOT CODE] =NT.[LOT CODE] AND  TP.[KILLDATE] =NT.[KILLDATE]  AND  TP.PACKDATE = NT.PACKDATE AND  TP.USEBY =NT.USEBY  AND  ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(NT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(TP.INVENTORY,'') = ISNULL(NT.INVENTORY,'') AND  ISNULL(TP.[INVENTORY LOCATION],'') = ISNULL(NT.[INVENTORY LOCATION],'')),0)- NT.QTY )AS QTY_DIFF,
(Isnull((SELECT TP.[WEIGHT] from #InnovaTMP TP where NT.[SITE]= TP.[SITE] AND NT.[PRODUCTCODE] = TP.[PRODUCTCODE]  AND ISNULL(NT.[PALLETNO],0) = ISNULL(TP.[PALLETNO],0) AND NT.[LOT CODE]= TP.[LOT CODE] AND NT.[KILLDATE] = TP.[KILLDATE] AND NT.PACKDATE = TP.PACKDATE AND NT.USEBY = TP.USEBY AND ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(NT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(NT.INVENTORY,'') = ISNULL(TP.INVENTORY,'') AND ISNULL(NT.[INVENTORY LOCATION],'') = ISNULL(TP.[INVENTORY LOCATION],'')),0)-NT.[Weight] ) AS WGT_DIFF

From
#NAVTMP NT (NOLOCK)
where (( Isnull((SELECT TP.QTY from #InnovaTMP TP where TP.[SITE] =NT.[SITE]  AND TP.[PRODUCTCODE] =NT.[PRODUCTCODE] AND  ISNULL(TP.[PALLETNO],0) = ISNULL(NT.[PALLETNO],0)  AND TP.[LOT CODE] =NT.[LOT CODE] AND  TP.[KILLDATE] =NT.[KILLDATE]  AND  TP.PACKDATE = NT.PACKDATE AND  TP.USEBY =NT.USEBY  AND  ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(NT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(TP.INVENTORY,'') = ISNULL(NT.INVENTORY,'') AND  ISNULL(TP.[INVENTORY LOCATION],'') = ISNULL(NT.[INVENTORY LOCATION],'')),0) - NT.QTY) <> 0
OR ( Isnull((SELECT TP.[WEIGHT] from #InnovaTMP TP where NT.[SITE]= TP.[SITE] AND NT.[PRODUCTCODE] = TP.[PRODUCTCODE]  AND ISNULL(NT.[PALLETNO],0) = ISNULL(TP.[PALLETNO],0) AND NT.[LOT CODE]= TP.[LOT CODE] AND NT.[KILLDATE] = TP.[KILLDATE] AND NT.PACKDATE = TP.PACKDATE AND NT.USEBY = TP.USEBY AND ISNULL(TP.DNOB,'1753-01-01 00:00:00.000') = ISNULL(NT.DNOB,'1753-01-01 00:00:00.000')  AND ISNULL(NT.INVENTORY,'') = ISNULL(TP.INVENTORY,'') AND ISNULL(NT.[INVENTORY LOCATION],'') = ISNULL(TP.[INVENTORY LOCATION],'')),0) - NT.[Weight] ) <> 0)
and KillDate is not null and PackDate is not null and useby is not null
order by NAVQTY desc


--select distinct * from #Compare


declare @orderLogCheck int

-------------------------------------------------------------------------------------------------------------
set @orderLogCheck = (select count(*) from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Order Log] with (nolock) where cast([Date Imported] as date) = cast(getdate() as date) AND Processed = 0 and [Errors Exist] <> 1 and [Message Type] = 'STK'  )

--------------------------------------------------------------------------------------------
--INPUT TRANSACTIONS INTO OUR LOG TABLE - SP Will take from LOG Table to Order Import Table every 2 minutes
--------------------------------------------------------------------------------------------

if (@orderLogCheck <> 0 )
	begin
	
			return

	end
	
else 

begin
		Insert into [FFGSQL01].[FFG-Production].[dbo].[APP_NAV_TRANSACTIONS_LOGS] 
		([SITE],[ProductCode],[PalletNO],[Lot code],[KillDate],[PackDate],[UseBy],[DNOB],[Inventory],[InventoryLocation],[INVQTY],[INVWGT],[NAVQTY],[NAVWGT],[QTY_DIFF],[WGT_DIFF],[Processed],[Imported To NAV]
		)
		select distinct [SITE]    ,ProductCode  ,PalletNO      ,[Lot code]      ,KillDate   ,PackDate   ,UseBy   ,DNOB   ,Inventory    ,InventoryLocation   ,INVQTY,INVWGT,NAVQTY,NAVWGT,QTY_DIFF,WGT_DIFF,0,NULL
		From #Compare t
		where NOT EXISTS  (select  *  from  [FFGSQL01].[FFG-Production].[dbo].[APP_NAV_TRANSACTIONS_LOGS]  L (NOLOCK) where L.[SITE] collate SQL_Latin1_General_CP850_CI_AS  = T.[SITE]   AND L.[ProductCode]  = t.[ProductCode]  AND L.[PalletNO] collate SQL_Latin1_General_CP850_CI_AS   = t.[PalletNO]     AND L.[Lot code] collate SQL_Latin1_General_CP850_CI_AS  = t.[Lot code]      AND L.[KillDate]  = t.[KillDate]  AND L.[PackDate]  = t.[PackDate]   AND L.[UseBy] = t.[UseBy] AND L.[DNOB] = t.[DNOB] AND L.[Inventory] collate SQL_Latin1_General_CP850_CI_AS  = t.[Inventory]    AND L.[InventoryLocation] collate SQL_Latin1_General_CP850_CI_AS      = t.[InventoryLocation]     AND ([Processed]  <> 1 OR isnull([Imported To NAV]  ,'')  > dateadd(MINUTE,-15,getdate())) )
		AND NOT EXISTS  (select * from [FFGSQL01].[FFG-Production].[dbo].[FFG LIVE$Order - Import] OI(NOLOCK) where case when OI.[Stock Site] = 11 then 'FC' when OI.[Stock Site] = 12 then 'FD' when OI.[Stock Site] = 13 then 'FO' when OI.[Stock Site] = 14 then 'FMM' when OI.[Stock Site] = 15 then 'FGL'  when OI.[Stock Site] = 16 then 'FH' when OI.[Stock Site] = 28 then 'FI' else '' end = t.[SITE] AND 
						 OI.[Item No_] = t.[ProductCode] AND OI.[Pallet No_] collate SQL_Latin1_General_CP1_CI_AS = t.[PalletNO] AND OI.[Innova Lot No_] collate SQL_Latin1_General_CP1_CI_AS = t.[Lot code] AND OI.[Kill Date] = t.[KillDate] AND OI.[Pack Date] = t.[PackDate] AND OI.[Use By Date] = t.[UseBy] AND OI.[DNOB] = t.[DNOB] AND OI.[Innova Inventory] collate SQL_Latin1_General_CP1_CI_AS = t.[Inventory] AND OI.[Innova Inventory Location] collate SQL_Latin1_General_CP1_CI_AS = t.[InventoryLocation])
end
--------------------------------------------------------------------------------------------
--Checks put in place to make sure that all data going to LOG table is not awaiting to be 
--processed by either the LOG table or by the Order import table. 
--Also added a 2 minute wait on all transactions that have been processed in the last 2 minutes

--------------------------------------------------------------------------------------------
--select * from #InnovaTMP
--select * from #NAVTMP
--select * from #Compare
drop table #InnovaTMP
drop table #NAVTMP
drop table #Compare

-------KH 05/09/17 -- setting a flag against closed , active sales orders 

--		exec [OMASQL01].[innova].[dbo].[APP_Set_InnovaOrder_Flag]							---Omagh

--		exec [CAMSQL01].[innova].[dbo].[APP_Set_InnovaOrder_Flag]							---Campsie

--		exec [DONSQL01].[innova].[dbo].[APP_Set_InnovaOrder_Flag]							---Donegal

--		exec [GLOSQL01].[innova].[dbo].[APP_Set_InnovaOrder_Flag]							---Gloucester

--		exec [MELSQL01].[innova].[dbo].[APP_Set_InnovaOrder_Flag]							---Melton

--		exec [CKTSQL01].[innova].[dbo].[APP_Set_InnovaOrder_Flag]							---Cookstown

--		exec [INGSQL01].[FI_innova].[dbo].[APP_Set_InnovaOrder_Flag]						---Ingredients

--		exec [FFGSQLTEST\MSSQL_INNOVA].[innova_FO].[dbo].[APP_Set_InnovaOrder_Flag]			---TEST

-------KH 05/09/17 END

END

GO
