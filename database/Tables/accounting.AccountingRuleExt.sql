/*
name=[accounting].[AccountingRuleExt]
version=1.0.1
lastUpdate=2017-01-24 10:37:21
4lY4mUKqd5WG1VvahtF/sw==
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[accounting].[AccountingRuleExt]') AND type in (N'U'))
BEGIN
CREATE TABLE [accounting].[AccountingRuleExt](
	[accountingRuleId] [uniqueidentifier] NOT NULL,
	[ruleXml] [xml] NULL,
 CONSTRAINT [PK_AccountingRuleExt] PRIMARY KEY CLUSTERED 
(
	[accountingRuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO