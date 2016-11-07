CREATE PROCEDURE [dbo].[DateTimeConversion_Finalize]
(@Print INT = NULL)
AS
BEGIN
	IF @Print IS NOT NULL PRINT 'UPDATE DateTimeKind'
	UPDATE tbl 
	SET DateTimeKind = 2
	FROM tblBigTableStoreConfig tbl
	JOIN tblDateTimeConversion_FieldName f ON tbl.StoreName = f.StoreName AND tbl.TableName = f.TableName 
	DECLARE @GetDateTimeKindSql NVARCHAR(MAX) = '
ALTER PROCEDURE [dbo].[sp_GetDateTimeKind]
AS
	-- 0 === Unspecified  
	-- 1 === Local time 
	-- 2 === UTC time 
	RETURN 2
'
	EXEC (@GetDateTimeKindSql)
	IF @Print IS NOT NULL PRINT 'FINISHED'
END
