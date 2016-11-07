CREATE PROCEDURE [dbo].[BigTableDeleteAll]
@ViewName nvarchar(4000)
AS
BEGIN
	DECLARE @deletes AS BigTableDeleteItemInternalTable;
	INSERT INTO @deletes(Id, NestLevel, ObjectPath)
	EXEC ('SELECT [StoreId], 1, ''/'' + CAST([StoreId] AS VARCHAR) + ''/'' FROM ' + @ViewName)
	EXEC sp_executesql N'BigTableDeleteItemInternal @deletes, 1', N'@deletes BigTableDeleteItemInternalTable READONLY',@deletes 
END
