/*
name=[dictionary].[p_getIssuePlaces]
version=1.0.1
lastUpdate=2017-01-24 10:37:21
Nfcx1Cs0nDaR2y7Tq5PQ3w==
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dictionary].[p_getIssuePlaces]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dictionary].[p_getIssuePlaces]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dictionary].[p_getIssuePlaces]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dictionary].[p_getIssuePlaces]
AS 
	/*Budowa XML z Miejscami składowania*/
    SELECT  ( SELECT    ( SELECT    ( SELECT    *
                                      FROM      dictionary.IssuePlace
                                      ORDER BY  [order]
                                    FOR
                                      XML PATH(''entry''),
                                          TYPE
                                    )
                        FOR
                          XML PATH(''issuePlace''),
                              TYPE
                        )
            FOR
              XML PATH(''root''),
                  TYPE
            ) AS returnsXML
' 
END
GO
