/*
name=[communication].[p_getItemPackage]
version=1.0.1
lastUpdate=2017-01-24 10:37:21
B6mQfdLNKJTLUcOu1bfvBQ==
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[communication].[p_getItemPackage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [communication].[p_getItemPackage]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[communication].[p_getItemPackage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [communication].[p_getItemPackage] @id UNIQUEIDENTIFIER
AS /*Gets item xml package that match input parameter*/
    BEGIN
		/*Deklaracja zmiennych*/
        DECLARE @result XML
		/*Budowanie obrazu danych*/
        SELECT  @result = ( SELECT  ( SELECT    ( SELECT    *
                                                  FROM      item.Item
                                                  WHERE     id = @id
                                                FOR
                                                  XML PATH(''entry''),
                                                      TYPE
                                                )
                                    FOR
                                      XML PATH(''item''),
                                          TYPE
                                    ),
                                    ( SELECT    ( SELECT    *
                                                  FROM      item.ItemAttrValue
                                                  WHERE     itemId = @id
                                                FOR
                                                  XML PATH(''entry''),
                                                      TYPE
                                                )
                                    FOR
                                      XML PATH(''itemAttrValue''),
                                          TYPE
                                    )
                          FOR
                            XML PATH(''root''),
                                TYPE
                          )
        /*Zwrócenie wyników*/                  
        SELECT  @result 
        /*Obsługa pustego resulta*/
        IF @@rowcount = 0 
            SELECT  ''''
            FOR     XML PATH(''root''),
                        TYPE
    END
' 
END
GO
