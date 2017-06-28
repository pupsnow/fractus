IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Concat]') AND type = N'AF')
EXEC dbo.sp_executesql @statement =
N'CREATE AGGREGATE [dbo].[Concat]
(@Value [nvarchar](4000))
RETURNS[nvarchar](4000)
EXTERNAL NAME [concat].[Concat]
'
GO
