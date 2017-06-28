/*
name=[translation].[Dok_Pozycje]
version=1.0.1
lastUpdate=2017-01-24 10:37:21
bKTlUeZkrGUiRkx5DzfCew==
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[translation].[Dok_Pozycje]') AND type in (N'U'))
BEGIN
CREATE TABLE [translation].[Dok_Pozycje](
	[id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[megaId] [nvarchar](50) NULL,
	[fractus2Id] [uniqueidentifier] NULL,
	[megaGID] [numeric](18, 0) NULL
) ON [PRIMARY]
END
GO