/*
name=[finance].[p_updatePaymentSettlement]
version=1.0.1
lastUpdate=2017-01-24 10:37:21
ajDDFdQXa/qe7u1NhTGUqA==
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[finance].[p_updatePaymentSettlement]') AND type in (N'P', N'PC'))
DROP PROCEDURE [finance].[p_updatePaymentSettlement]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[finance].[p_updatePaymentSettlement]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [finance].[p_updatePaymentSettlement]
@xmlVar XML
AS
    BEGIN
	DECLARE @errorMsg VARCHAR(2000),
			@rowcount INT,
			@error int 
    
	BEGIN TRY

	DECLARE @tmp_set TABLE (i int identity(1,1),id uniqueidentifier,[date] datetime, incomePaymentId uniqueidentifier, outcomePaymentId uniqueidentifier, amount numeric(18,2), [version] uniqueidentifier, isAutoGenerated bit) 
        
		INSERT  INTO @tmp_set ( id,[date],incomePaymentId,outcomePaymentId,amount,version,isAutoGenerated )
        SELECT  con.query(''id'').value(''.'', ''char(36)''),
                con.query(''date'').value(''.'', ''datetime''),
                con.query(''incomePaymentId'').value(''.'', ''char(36)''),
                con.query(''outcomePaymentId'').value(''.'', ''char(36)''),
                con.query(''amount'').value(''.'', ''numeric(18,2)''),
               ISNULL(
					NULLIF(con.query(''_version'').value(''.'', ''char(36)''), ''''),
					con.query(''version'').value(''.'', ''char(36)'')
				),
				con.query(''isAutoGenerated'').value(''.'', ''bit'')
        FROM    @xmlVar.nodes(''/root/paymentSettlement/entry'') AS C ( con )

		/*Aktualizacja danych o rozliczeniach płatności*/
        UPDATE  x
        SET     date = t.date,
                incomePaymentId = t.incomePaymentId,
                outcomePaymentId = t.outcomePaymentId,
                amount = t.amount,
                [version] = t.[version],
                isAutoGenerated = t.isAutoGenerated
        FROM    [finance].[PaymentSettlement] x
			JOIN @tmp_set t ON x.id = t.id
                 
		/*Pobranie liczby wierszy*/
        SET @rowcount = @@ROWCOUNT

     END TRY
	 BEGIN CATCH
			SELECT @errorMsg = ''Błąd wstawiania danych tabela:Configuration; error:''
				+ CAST(@@ERROR AS VARCHAR(50)) + '';Procedura:'' + ERROR_PROCEDURE() + '';Linia:'' + CAST(ERROR_LINE() as varchar(50))+ '';Opis:'' + ERROR_MESSAGE() 
            RAISERROR ( @errorMsg, 16, 1)
    END CATCH        
	IF @rowcount = 0 
		BEGIN
		-- RAISERROR ( 50011, 16, 1 ) ;
		/* 
			Aby zapobiec występowaniu przestojów w komunikacji zamieniam ten komunikat na próbę wstawienia jak się okazuje nowgo wpisu w konfiguracji.
			Może to spowodować błąd logiki systemu (jeśli ktoś celowo usunoł klucz w tym samym czasie z tego miejsca), jednak z punktu widzenia
			i tak koniecznej naprawy, lepiej jest mieć dane które może są niesłusznie niż wcale ich nie mieć i wykminiać czy słusznie 
		*/
			EXEC [finance].[p_insertPaymentSettlement] @xmlVar

		END
END
' 
END
GO