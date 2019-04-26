SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Martin McGinn
-- Create date: 12th April 2018
-- Description:	Look at the HA system and transfer in 
-- =============================================

--exec [00001-P2CheckErrorLog]

CREATE PROCEDURE [dbo].[00001-P2CheckErrorLog]

AS

SELECT        TOP (200) id, regtime, sequence, logtype, computer, username, application, obj, code1, code2, code3, message, info
Into #t
FROM            glosql01.[innova].dbo.base_log
WHERE        (application = 'APP_P2_ImportOrderOne_V2')
ORDER BY id DESC

Insert Into #t

SELECT        TOP (200) id, regtime, sequence, logtype, computer, username, application, obj, code1, code2, code3, message, info
FROM           omasql01.[innova].dbo.base_log
WHERE        (application = 'APP_P2_ImportOrderOne_V2')
ORDER BY id DESC

Insert Into #t

SELECT        TOP (200) id, regtime, sequence, logtype, computer, username, application, obj, code1, code2, code3, message, info
FROM           camsql01.[innova].dbo.base_log
WHERE        (application = 'APP_P2_ImportOrderOne_V2')
ORDER BY id DESC

Insert Into #t

SELECT        TOP (200) id, regtime, sequence, logtype, computer, username, application, obj, code1, code2, code3, message, info
FROM           donsql01.[innova].dbo.base_log
WHERE        (application = 'APP_P2_ImportOrderOne_V2')
ORDER BY id DESC

Insert Into #t

SELECT        TOP (200) id, regtime, sequence, logtype, computer, username, application, obj, code1, code2, code3, message, info
FROM           melsql01.[innova].dbo.base_log
WHERE        (application = 'APP_P2_ImportOrderOne_V2')
ORDER BY id DESC

Insert Into #t

SELECT        TOP (200) id, regtime, sequence, logtype, computer, username, application, obj, code1, code2, code3, message, info
FROM           cktsql01.[innova].dbo.base_log
WHERE        (application = 'APP_P2_ImportOrderOne_V2')
ORDER BY id DESC

Insert Into #t

SELECT        TOP (200) id, regtime, sequence, logtype, computer, username, application, obj, code1, code2, code3, message, info
FROM           ingsql01.[FI_innova].dbo.base_log
WHERE        (application = 'APP_P2_ImportOrderOne_V2')
ORDER BY id DESC

Select regtime As RegTime, computer As Computer, info As Info, Substring(info,137,11) As 'FFGSO' From #t Where regtime > GetDate()-1.75 Order By regtime desc

Drop Table #t
GO
