/*
name=[dictionary].[p_checkContainerTypeVersion]
version=1.0.1
lastUpdate=2017-01-24 10:37:21
1mKs9N++BvZnaEQCaMpAow==
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dictionary].[p_checkContainerTypeVersion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dictionary].[p_checkContainerTypeVersion]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dictionary].[p_checkContainerTypeVersion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dictionary].[p_checkContainerTypeVersion]
    @version UNIQUEIDENTIFIER
AS 
    BEGIN

		/*Walidacja wersji */
        IF NOT EXISTS ( SELECT  id
                        FROM    dictionary.ContainerType
                        WHERE   ContainerType.version = @version ) 
            RAISERROR ( 50012, 16, 1 )

    END
' 
END
GO