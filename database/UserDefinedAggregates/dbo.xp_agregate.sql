IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[xp_agregate]') AND type = N'AF')
EXEC dbo.sp_executesql @statement =
N'CREATE AGGREGATE [dbo].[xp_agregate]
(@val [nvarchar](4000))
RETURNS[nvarchar](4000)
EXTERNAL NAME [xp_agregat].[xp_agregate]
'
GO
