SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,joe	>
-- Create date: <Create Date,,>
-- Description:	<Description,,Danish crown wanted a specific del note. Can add more customers if needs be>
-- =============================================
--exec [dbo].[usrrep_CompanyDel_Note_Pallet] '342961'
Create PROCEDURE [dbo].[usrrep_CompanyDel_Note_Pallet_FO]
		
			@Pallet nvarchar(15)

AS
BEGIN


Select			count(pp.id) as Quantity, cast(sum(pp.nominal)as decimal(18,2))as [Weight],
				pc.number as Pallet,
				pm.[code] as ProductCode, 
				pm.[name] as Product,
				format(pp.expire1,'dd/MM/yy') as UseBy,format(pp.expire2,'dd/MM/yy')as KillDate
				

From [FO_Innova].[dbo].proc_packs pp (nolock)
inner join [FO_Innova].[dbo].proc_collections pc with(nolock) on pp.pallet = pc.id
inner join [FO_Innova].[dbo].proc_materials pm with(nolock) on pp.material = pm.material 

where pc.number = @Pallet
 group by	
			 pc.number, 
			pm.code,pm.[name],
			pp.expire2,pp.expire1
		
 order by pc.number,pp.expire1,pp.expire2 desc




END
GO
