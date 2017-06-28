/*
name=[translation].[p_insertOrUpdateDok_PozycjeFromFractus2]
version=1.0.1
lastUpdate=2017-01-24 10:37:21
73F1nyNxUT0m8K560pBVSg==
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[translation].[p_insertOrUpdateDok_PozycjeFromFractus2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [translation].[p_insertOrUpdateDok_PozycjeFromFractus2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[translation].[p_insertOrUpdateDok_PozycjeFromFractus2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [translation].[p_insertOrUpdateDok_PozycjeFromFractus2]
@fractus2Id UNIQUEIDENTIFIER, @branchSymbol VARCHAR (20)
AS
BEGIN
DECLARE @megaId VARCHAR(50)
DECLARE @megaGID NUMERIC(18, 0)

	DECLARE @assignedId NUMERIC(18, 0)
	DECLARE @prefix int

	SELECT @megaId = megaId, @megaGID = megaGID 
		FROM [translation].[Dok_Pozycje] 
		WHERE fractus2Id = @fractus2Id

	IF @megaId IS NULL
		BEGIN
			INSERT INTO [translation].[Dok_Pozycje](fractus2Id) VALUES(@fractus2Id)

			SELECT @assignedId = scope_identity()

			SET @megaId = @branchSymbol + CAST(@assignedId AS VARCHAR(18))

			SELECT @prefix = prefix 
				FROM translation.BranchAttributes ba 
				INNER JOIN dictionary.Branch db 
				ON ba.branchId = db.id 
				WHERE db.symbol = @branchSymbol

			SET @megaGID = (@prefix * 1000000000000000) + @assignedId

			UPDATE [translation].[Dok_Pozycje] 
				SET megaId = @megaId, megaGID = @megaGID 
				WHERE id=@assignedId
		END	


SELECT @megaId, @megaGID

END
' 
END
GO
