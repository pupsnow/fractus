/*
name=[reports].[p_getItemsSalesByContractor]
version=1.0.1
lastUpdate=2017-01-24 10:37:21
4wNzLrK1gXHzQyD8vCWkQw==
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[reports].[p_getItemsSalesByContractor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [reports].[p_getItemsSalesByContractor]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[reports].[p_getItemsSalesByContractor]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [reports].[p_getItemsSalesByContractor]
@xmlVar XML
AS
BEGIN

/*
exec reports.[p_getContractorsSalesByItems] ''<root><searchParams contractorId="FEB23044-460B-4489-822F-E41C22E762CA" /> <searchParams fromDate="2013-07-01" /> </root>''
*/

        DECLARE 
			@ItemId uniqueidentifier,
			@fromDate datetime,
			@ToDate datetime,
			@salesDirection int

        SELECT  
                @itemId = @xmlVar.value(''(root/searchParams/@itemId)[1]'',''char(36)''),
				@fromDate  = NULLIF(@xmlVar.value(''(root/searchParams/@fromDate)[1]'',''varchar(50)''),''''),
				@ToDate =  NULLIF(@xmlVar.value(''(root/searchParams/@toDate)[1]'',''varchar(50)''),''''),
				@salesDirection = NULLIF(@xmlVar.value(''(root/searchParams/@salesDirection)[1]'',''int''),'''')

		 	SELECT  
				(
					SELECT  c.id as ''@id'', ISNULL(c.shortName, c.fullName )  as  ''@contractorName'' , c.code AS ''@contractorCode'', 
						CAST(ROUND(-(SUM(l.quantity * l.commercialDirection)) ,2) AS numeric(18,2)) AS ''@quantity'' , 
						CAST(ROUND(SUM(ABS(ISNULL(cv.value,0)) * SIGN(l.quantity )),2) AS numeric(18,2)) AS ''@cost'' ,
						CAST(ROUND(SUM((l.netValue * CommercialDocumentHeader.exchangeRate)/CommercialDocumentHeader.exchangeScale),2) AS numeric(18,2)) AS ''@netValue'' , 
						CAST(ROUND(SUM( (l.grossValue * CommercialDocumentHeader.exchangeRate)/CommercialDocumentHeader.exchangeScale),2) AS numeric(18,2)) AS ''@grossValue''
					FROM document.CommercialDocumentHeader WITH(NOLOCK)
						JOIN dictionary.DocumentType dt WITH(NOLOCK) ON CommercialDocumentHeader.documentTypeId = dt.id AND documentCategory IN (0,5, 2)  AND CommercialDocumentHeader.status >= 40
						JOIN document.CommercialDocumentLine l WITH(NOLOCK) ON CommercialDocumentHeader.id = l.commercialDocumentHeaderId AND l.commercialDirection <> 0
						JOIN contractor.Contractor c WITH(NOLOCK) ON CommercialDocumentHeader.contractorId = c.id 
						LEFT JOIN ( SELECT  SUM(ISNULL(ll.value,0)) value , v.commercialDocumentLineId FROM document.CommercialWarehouseRelation v WITH(NOLOCK) JOIN document.WarehouseDocumentLine ll WITH(NOLOCK) ON v.warehouseDocumentLineId = ll.id Group by  v.commercialDocumentLineId ) cv ON l.id = cv.commercialDocumentLineId 
					WHERE l.itemId = @itemId 
						AND ( CommercialDocumentHeader.issueDate >= @fromDate  OR @fromDate IS NULL)
						AND ( CommercialDocumentHeader.issueDate <= @toDate OR @toDate IS NULL)
						AND ( l.commercialDirection = @salesDirection OR ISNULL(@salesDirection,0) = 0)
					GROUP BY c.id , ISNULL(c.shortName, c.fullName ) , c.code	
					ORDER BY  ISNULL(c.shortName, c.fullName )
					FOR XML PATH(''line''),TYPE 
				)
			FOR XML PATH(''root''),TYPE 
END
' 
END
GO
