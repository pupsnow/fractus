/*
name=[document].[p_deleteCommercialDocumentVatTable]
version=1.0.1
lastUpdate=2017-01-24 10:37:21
4bQBNwGibYYbyI4vqtKgwA==
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[document].[p_deleteCommercialDocumentVatTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [document].[p_deleteCommercialDocumentVatTable]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[document].[p_deleteCommercialDocumentVatTable]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [document].[p_deleteCommercialDocumentVatTable]
@xmlVar XML
AS
DECLARE @errorMsg VARCHAR(2000),
        @rowcount INT

    
    
    /*Kasowanie danych o pozycja w tabeli vat*/
    DELETE  FROM [document].CommercialDocumentVatTable
    WHERE   id IN (
            SELECT  NULLIF(con.query(''id'').value(''.'', ''char(36)''), '''')
            FROM    @xmlVar.nodes(''/root/commercialDocumentVatTable/entry'') AS C ( con )
            WHERE   version = NULLIF(con.query(''version'').value(''.'', ''char(36)''),'''') )

	/*Pobranie liczby wierszy*/
    SET @rowcount = @@ROWCOUNT
    
    /*Obsługa błędów i wyjątków*/
    IF @@ERROR <> 0 
        BEGIN
            
            SET @errorMsg = ''Błąd kasowania danych:CommercialDocumentVatTable; error:''
                + CAST(@@error AS VARCHAR(50)) + ''; ''
            RAISERROR ( @errorMsg, 16, 1 )
        END
    ELSE 
        BEGIN
            
            IF @rowcount = 0 
                RAISERROR ( 50012, 16, 1 ) ;
        END
' 
END
GO
