/*
name=[dictionary].[p_checkConfigurationKeyVersion]
version=1.0.1
lastUpdate=2017-01-24 10:37:21
r7RrQEqRiE9ZiB0pVe4qoA==
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dictionary].[p_checkConfigurationKeyVersion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dictionary].[p_checkConfigurationKeyVersion]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dictionary].[p_checkConfigurationKeyVersion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dictionary].[p_checkConfigurationKeyVersion]
    @version UNIQUEIDENTIFIER
AS 
    BEGIN
		/*Walidacja wersji konfiguracji*/
        IF NOT EXISTS ( SELECT  id
                        FROM    dictionary.ConfigurationKey
                        WHERE   ConfigurationKey.version = @version ) 
            RAISERROR ( 50012, 16, 1 )

    END
' 
END
GO
