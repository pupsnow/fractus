/*
name=[dictionary].[p_updateShiftField]
version=1.0.1
lastUpdate=2017-01-24 10:37:21
RPFAoSfkIanJ0h8X3x9DPg==
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dictionary].[p_updateShiftField]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dictionary].[p_updateShiftField]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dictionary].[p_updateShiftField]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dictionary].[p_updateShiftField]
@xmlVar XML
AS
BEGIN
		/*Deklaracja zmiennych*/
        DECLARE @errorMsg VARCHAR(2000),
            @rowcount INT

        /*Aktualizacja danych o atrybutach Shift*/
        UPDATE  dictionary.ShiftField
        SET     name = CASE WHEN con.exist(''name'') = 1
                            THEN con.query(''name'').value(''.'', ''varchar(255)'')
                            ELSE NULL
                       END,
                xmlLabels = CASE WHEN con.exist(''xmlLabels'') = 1
                                 THEN con.query(''xmlLabels/*'')
                                 ELSE NULL
                            END,
                xmlMetadata = CASE WHEN con.exist(''xmlMetadata'') = 1
                                   THEN con.query(''xmlMetadata/*'')
                                   ELSE NULL
                              END,
                version = CASE WHEN con.exist(''_version'') = 1
                               THEN con.query(''_version'').value(''.'', ''char(36)'')
                               ELSE NULL
                          END,
                [order] = CASE WHEN con.exist(''order'') = 1
                               THEN con.query(''order'').value(''.'', ''int'')
                               ELSE NULL
                          END
        FROM    @xmlVar.nodes(''/root/shiftField/entry'') AS C ( con )
        WHERE   ShiftField.id = con.query(''id'').value(''.'', ''char(36)'')

		/*Pobranie liczby wierszy*/
        SET @rowcount = @@ROWCOUNT
        
        /*Aktualizacja wersji słowników*/
        EXEC [dictionary].[p_updateVersion] ''ShiftField''
        
        /*Obsługa błędów i wyjątków*/
        IF @@ERROR <> 0 
            BEGIN
                
                SET @errorMsg = ''Błąd wstawiania danych table: ShiftField; error:''
                    + CAST(@@error AS VARCHAR(50)) + ''; ''
                RAISERROR ( @errorMsg, 16, 1 )
            END
        ELSE 
            BEGIN
                
                IF @rowcount = 0 
                    RAISERROR ( 50012, 16, 1 ) ;
            END
    END
' 
END
GO
