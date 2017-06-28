/*
name=[communication].[p_getWarehouseDocumentValuationPackage]
version=1.0.1
lastUpdate=2017-01-24 10:37:21
0p9WhyvaO6tDfUe7wcarAw==
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[communication].[p_getWarehouseDocumentValuationPackage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [communication].[p_getWarehouseDocumentValuationPackage]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[communication].[p_getWarehouseDocumentValuationPackage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [communication].[p_getWarehouseDocumentValuationPackage] @id UNIQUEIDENTIFIER
AS /*Gets WarehouseDocumentValuation xml Package that match input parameter*/
    BEGIN
		/*Deklaracja zmiennych*/
        DECLARE @snap XML

		/*Budowa obrazu danych*/
        SELECT  @snap = ( 
						SELECT (
						  SELECT    @id ''id'',
                                    incomeWarehouseDocumentLineId ''incomeWarehouseDocumentLineId'',
                                    outcomeWarehouseDocumentLineId ''outcomeWarehouseDocumentLineId'',
                                    valuationId ''valuationId'',
									quantity ''quantity'',
									incomePrice ''incomePrice'',
									incomeValue ''incomeValue'',
									version ''version''
                          FROM      document.WarehouseDocumentValuation
                          WHERE     WarehouseDocumentValuation.id = @id
                        FOR XML PATH(''entry''), TYPE )
                        FOR XML PATH(''warehouseDocumentValuation''), TYPE
                        ) 
		/*Zwrócenie wyników*/
        SELECT  @snap
        FOR     XML PATH(''root''),
                    TYPE
    END
' 
END
GO
