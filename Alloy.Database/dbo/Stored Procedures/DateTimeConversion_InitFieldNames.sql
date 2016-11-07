CREATE PROCEDURE [dbo].[DateTimeConversion_InitFieldNames]
AS
BEGIN
	IF OBJECT_ID('[dbo].[tblDateTimeConversion_FieldName]', 'U') IS NOT NULL
		DROP TABLE [dbo].[tblDateTimeConversion_FieldName]
	CREATE TABLE [dbo].[tblDateTimeConversion_FieldName](
		[pkID] [int] IDENTITY(1,1) NOT NULL,		
		[TableName] nvarchar(128) NOT NULL,
		[ColName] nvarchar(128) NOT NULL,
		[StoreName] NVARCHAR(375) NULL,
		CONSTRAINT [PK_DateTimeConversion_InitFieldNames] PRIMARY KEY  CLUSTERED
		(
			[pkID]
		)
	)
	DECLARE @FieldNames AS TABLE 
	(
		TableName NVARCHAR(128) NOT NULL,
		ColName NVARCHAR(128) NULL,
		StoreName NVARCHAR(375) NULL
	)
	INSERT INTO @FieldNames
	EXEC DateTimeConversion_GetFieldNames
	INSERT INTO @FieldNames
	SELECT TableName = c.name, ColName = a.name, f.StoreName  from 
		sys.columns a 
		INNER JOIN sys.types t ON a.user_type_id = t.user_type_id AND (t.name = 'datetime' OR t.name = 'datetime2')
		INNER JOIN sys.tables c ON a.object_id = c.object_id 
		INNER JOIN @FieldNames f ON c.object_id = OBJECT_ID(f.TableName)
	WHERE f.ColName IS NULL
	
	DELETE @FieldNames WHERE ColName IS NULL
	DECLARE @DateTimeKind INT
	EXEC @DateTimeKind = sp_GetDateTimeKind
	INSERT INTO [dbo].[tblDateTimeConversion_FieldName](TableName, ColName, StoreName)
	SELECT DISTINCT REPLACE(REPLACE(REPLACE(X.TableName,'[',''),']',''),'dbo.',''), ColName = REPLACE(REPLACE(X.ColName,']',''),'[',''), X.StoreName FROM (
		SELECT f.TableName, f.ColName, StoreName = NULL FROM @FieldNames f WHERE @DateTimeKind = 0 AND f.StoreName IS NULL
		UNION
		SELECT DISTINCT f.TableName, f.ColName, f.StoreName
		FROM sys.columns a 
		INNER JOIN sys.types t ON a.user_type_id = t.user_type_id AND (t.name = 'datetime' OR t.name = 'datetime2')
		INNER JOIN sys.tables c ON a.object_id = c.object_id 
		INNER JOIN tblBigTableStoreConfig i ON c.object_id = OBJECT_ID(i.TableName) AND i.DateTimeKind = 0
		INNER JOIN @FieldNames f ON c.object_id = OBJECT_ID(f.TableName) AND (a.name COLLATE database_default = f.ColName OR '['+a.name COLLATE database_default+']' = f.ColName) AND f.StoreName = i.StoreName
	) X
	INNER JOIN (
		SELECT TableId = c.object_id, ColName = a.name FROM sys.columns a 
		INNER JOIN sys.types t ON a.user_type_id = t.user_type_id AND (t.name = 'datetime' OR t.name = 'datetime2')
		INNER JOIN sys.tables c ON a.object_id = c.object_id
	) Y 
	ON Y.TableId = OBJECT_ID(X.TableName) AND (Y.ColName = X.ColName COLLATE database_default OR '['+Y.ColName +']' = X.ColName COLLATE database_default)
END
