SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Kevin Hargan>
-- Create date: <08/06/18>
-- Description:	<Confirm Dates for Drogheda & Ocado>
-- =============================================
CREATE PROCEDURE [dbo].[usrrep_Drogheda_Ocado_Confirm_Dates_Master]

--exec [dbo].[usrrep_Drogheda_Ocado_Confirm_Dates_Master] '145198'

@extnum nvarchar(20)


AS
BEGIN
	Create table #tmp (FAILTYPE nvarchar(20), PO nvarchar(20), ProductCode nvarchar(20) ,Product nvarchar(max), QTY int, Useby date, DNOB date)

	INSERT INTO #tmp
	exec [usrrep_Drogheda_Ocado_Confirm_Dates_FD] @extnum
	
	INSERT INTO #tmp
	exec [usrrep_Drogheda_Ocado_Confirm_Dates_FC] @extnum
	
	INSERT INTO #tmp
	exec [usrrep_Drogheda_Ocado_Confirm_Dates_FO] @extnum

	INSERT INTO #tmp
	exec [usrrep_Drogheda_Ocado_Confirm_Dates_FH] @extnum

	Select t.FAILTYPE, t.PO, t.ProductCode, t.Product, SUM(t.QTY) as QTY, t.Useby, t.DNOB
	from #tmp t
	group by  t.PO, t.ProductCode, t.Product, t.Useby, t.DNOB, t.FAILTYPE
	order by Product desc

END

--AS
--BEGIN
--	Create table #tmp (FAILTYPE nvarchar(20), PO nvarchar(20), ProductCode nvarchar(20) ,Product nvarchar(max), QTY int, Useby date, DNOB date)

--	INSERT INTO #tmp
--	exec [FD_Innova].[dbo].[usrrep_Drogheda_Ocado_Confirm_Dates] @extnum
	
--	INSERT INTO #tmp
--	exec [FM_Innova].[dbo].[usrrep_Drogheda_Ocado_Confirm_Dates] @extnum
	
--	INSERT INTO #tmp
--	exec [FO_Innova].[dbo].[usrrep_Drogheda_Ocado_Confirm_Dates] @extnum

--	INSERT INTO #tmp
--	exec [FH_Innova].[dbo].[usrrep_Drogheda_Ocado_Confirm_Dates] @extnum

--	Select t.FAILTYPE, t.PO, t.ProductCode, t.Product, SUM(t.QTY) as QTY, t.Useby, t.DNOB
--	from #tmp t
--	group by  t.PO, t.ProductCode, t.Product, t.Useby, t.DNOB, t.FAILTYPE
--	order by Product desc

--END
GO
