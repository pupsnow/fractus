/*
name=[item].[p_getRandomKeywords]
version=1.0.1
lastUpdate=2017-01-24 10:37:21
/a1WdBW2czSDumRD6586Cw==
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[item].[p_getRandomKeywords]') AND type in (N'P', N'PC'))
DROP PROCEDURE [item].[p_getRandomKeywords]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[item].[p_getRandomKeywords]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [item].[p_getRandomKeywords] --''<root amount="1000" />''
@xmlVar XML
AS

DECLARE 
@s int
,@g int
,@i int
,@x int
,@id UNIQUEIDENTIFIER
,@keyword NVARCHAR(500)


DECLARE  @tmp_t TABLE (keyword NVARCHAR(500))

/*Pobranie ilości oczekiwanych linii*/
SELECT @s = NULLIF(x.value(''@amount[1]'',''int''),0)
FROM @xmlVar.nodes(''/*'') a ( x )

SELECT TOP 1 @id = id, @keyword = field , @x = 0, @g = 1 + CAST(RIGHT(CAST(DATEPART(s,getdate()) as varchar(2)),1) as int), @i = 1
FROM item.ItemDictionary
ORDER BY id

WHILE (@x + 1) <= @s 
	BEGIN

		SELECT TOP 1 @id = id , @keyword = field
		FROM item.ItemDictionary
		WHERE id > @id
		ORDER BY id

		IF @i%@g = 0 
			BEGIN
				SELECT @x = @x + 1 
				INSERT INTO @tmp_t SELECT @keyword
			END
			
		SELECT @i = @i + 1
	END


SELECT (
	SELECT keyword [value] 
	FROM @tmp_t keyword  
	FOR XML AUTO, TYPE
) FOR XML PATH(''root''), TYPE
' 
END
GO
