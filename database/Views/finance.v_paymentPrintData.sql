/*
name=[finance].[v_paymentPrintData]
version=1.0.1
lastUpdate=2017-01-24 10:37:21
VOjBaxA3qWPba8E3S8yTiQ==
*/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[finance].[v_paymentPrintData]'))
DROP VIEW [finance].[v_paymentPrintData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[finance].[v_paymentPrintData]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [finance].[v_paymentPrintData]
AS
SELECT id ,commercialDocumentHeaderId, financialDocumentHeaderId,
			 (	SELECT

					p.[id],
					p.[date],
					p.[dueDate],
					p.[contractorId],
					p.[contractorAddressId],
					p.[paymentMethodId],
					p.[commercialDocumentHeaderId],
					p.[financialDocumentHeaderId],
					p.[amount],
					p.[paymentCurrencyId],
					p.[systemCurrencyId],
					p.[exchangeDate],
					p.[exchangeScale],
					p.[exchangeRate],
					p.[isSettled],
					p.[version],
					p.[ordinalNumber],
					p.[description],
					p.[documentInfo],
					p.[direction],
					(SELECT (
							SELECT vc.xmlValue
							FROM [contractor].[v_contractorPrintData] vc WITH (NOLOCK)
							WHERE vc.id = p.contractorId
							)
					FOR XML PATH(''contractor''), TYPE ) ,
					(SELECT ( SELECT 
								ps.id,
								ps.[date],
								ps.incomePaymentId,
								ps.outcomePaymentId,
								ps.amount,
								ps.[version],
								ps.isAutoGenerated
							FROM [finance].PaymentSettlement ps WITH (NOLOCK)
							WHERE p.id IN ( ps.incomePaymentId, ps.outcomePaymentId )
							FOR XML PATH(''settlement''), TYPE )
					 FOR XML PATH(''settlements''), TYPE )						
				FROM finance.Payment p
				WHERE p.id = pp.id
				FOR XML PATH(''payment''), TYPE ) xmlValue
FROM finance.Payment pp
' 
GO
