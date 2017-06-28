/*
name=[translation].[p_insertOrSelectDok_NaglowekFromMega]
version=1.0.1
lastUpdate=2017-01-24 10:37:21
cApfwPEs3Dznc0LMMXIb/g==
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[translation].[p_insertOrSelectDok_NaglowekFromMega]') AND type in (N'P', N'PC'))
DROP PROCEDURE [translation].[p_insertOrSelectDok_NaglowekFromMega]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[translation].[p_insertOrSelectDok_NaglowekFromMega]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [translation].[p_insertOrSelectDok_NaglowekFromMega]
@megaId VARCHAR(50),
@megaGID NUMERIC(18, 0) = NULL
AS
BEGIN
	DECLARE @fractus2Id UNIQUEIDENTIFIER

	SELECT @fractus2Id = fractus2Id
		FROM [translation].[Dok_Naglowek] 
		WHERE megaId = @megaId

	IF @fractus2Id IS NULL
		BEGIN
			DECLARE @assignedId NUMERIC(18, 0)
			DECLARE @prefix int
			DECLARE @branchSymbol VARCHAR(20)
			SET @branchSymbol = SUBSTRING(@megaId, 1, 2)

			SET @fractus2Id = NEWID()

			SELECT @prefix = prefix 
				FROM translation.BranchAttributes ba 
				INNER JOIN dictionary.Branch db 
				ON ba.branchId = db.id 
				WHERE db.symbol = @branchSymbol
			SET @megaGID = (@prefix * 1000000000000000) + CAST(SUBSTRING(@megaId, 3, LEN(@megaId) - 2) AS NUMERIC(18, 0))

			INSERT INTO [translation].[Dok_Naglowek](fractus2Id, megaId, megaGID) 
				VALUES(@fractus2Id, @megaId, @megaGID)
		END	

SELECT @fractus2Id AS fractus2Id

END
' 
END
GO
