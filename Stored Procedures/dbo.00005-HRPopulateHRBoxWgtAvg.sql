SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 17th September 2018
-- Description:	Populate HRBoxWgtAvg with Average weights
-- =============================================


--exec [00005-HRPopulateHRBoxWgtAvg]

CREATE PROCEDURE [dbo].[00005-HRPopulateHRBoxWgtAvg]

AS 

Truncate Table HRBoxWgtAvg

SELECT   ProductCode, BoxNo,
Case When Substring(Substitues,1,9)='' Then ProductCode Else Substring(Substitues,1,9) End As P1,
Case When Substring(Substitues,11,9)='' Then '' Else Substring(Substitues,11,9) End As P2,
Case When Substring(Substitues,21,9)='' Then '' Else Substring(Substitues,21,9) End As P3,
Case When Substring(Substitues,31,9)='' Then '' Else Substring(Substitues,31,9) End As P4,
Case When Substring(Substitues,41,9)='' Then '' Else Substring(Substitues,41,9) End As P5,
Case When Substring(Substitues,51,9)='' Then '' Else Substring(Substitues,51,9) End As P6,
Case When Substring(Substitues,61,9)='' Then '' Else Substring(Substitues,61,9) End As P7,
Case When Substring(Substitues,71,9)='' Then '' Else Substring(Substitues,71,9) End As P8,
Case When Substring(Substitues,81,9)='' Then '' Else Substring(Substitues,81,9) End As P9,
Case When Substring(Substitues,91,9)='' Then '' Else Substring(Substitues,91,9) End As P10
Into #t
FROM [FFGSQL06].[FFGProductionPlan].[dbo].HR_Product_Subs


Insert Into HRBoxWgtAvg
(Wgt, Qty, AvgCaseWgt, BoxNo, Imported)

SELECT Sum(i.[Remaining Quantity]) As Wgt, Sum(i.[Remaining Case Qty_]) Qty, 
Cast((Sum(i.[Remaining Quantity]) / Sum(i.[Remaining Case Qty_])) As Decimal(18,2)) As AvgCaseWgt, Min(t.BoxNo) As BoxNo, GetDate()
--Into #x
FROM            [ffgsql01].[FFG-PRODUCTION].dbo.[FFG LIVE$Item Ledger Entry] i
Left Join #t t On 
(
i.[Item No_] Collate Database_Default = t.[P1]
OR i.[Item No_] Collate Database_Default = t.[P2]
OR i.[Item No_] Collate Database_Default = t.[P3]
OR i.[Item No_] Collate Database_Default = t.[P4]
OR i.[Item No_] Collate Database_Default = t.[P5]
OR i.[Item No_] Collate Database_Default = t.[P6]
OR i.[Item No_] Collate Database_Default = t.[P7]
OR i.[Item No_] Collate Database_Default = t.[P8]
OR i.[Item No_] Collate Database_Default = t.[P9]
OR i.[Item No_] Collate Database_Default = t.[P10]
)
WHERE        (i.[Remaining Case Qty_] > 0) And Substring(i.[Item No_],1,2) In ('34','50','90') And i.[Open]=1 And i.Positive=1 And Not i.[Location Code]='FI'
AND NOT i.[Innova Inventory]='READY TO SHIP'
Group By t.BoxNo

drop table #t
GO
