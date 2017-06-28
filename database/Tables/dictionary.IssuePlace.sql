/*
name=[dictionary].[IssuePlace]
version=1.0.1
lastUpdate=2017-01-24 10:37:21
GOmCJloJYwNQYWxOZndK5g==
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dictionary].[IssuePlace]') AND type in (N'U'))
BEGIN
CREATE TABLE [dictionary].[IssuePlace](
	[id] [uniqueidentifier] NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[version] [uniqueidentifier] NOT NULL,
	[order] [int] NOT NULL,
 CONSTRAINT [PK_IssuePlace] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
