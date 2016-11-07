CREATE PROCEDURE [dbo].[BigTableDeleteItemInternal]
@TVP BigTableDeleteItemInternalTable READONLY,
@forceDelete bit = 0
AS
BEGIN
	DECLARE @deletes AS BigTableDeleteItemInternalTable
	INSERT INTO @deletes SELECT * FROM @TVP
	DECLARE @nestLevel int
	SET @nestLevel = 1
	WHILE @@ROWCOUNT > 0
	BEGIN
		SET @nestLevel = @nestLevel + 1
		-- insert all items contained in the ones matching the _previous_ nestlevel and give them _this_ nestLevel
		-- exclude those items that are also referred by some other item not already in @deletes
		-- IMPORTANT: Make sure that this insert is the last statement that can affect @@ROWCOUNT in the while-loop
		INSERT INTO @deletes(Id, NestLevel, ObjectPath)
		SELECT DISTINCT RefIdValue, @nestLevel, deletes.ObjectPath + '/' + CAST(RefIdValue AS VARCHAR) + '/'
		FROM tblBigTableReference R1
		INNER JOIN @deletes deletes ON deletes.Id=R1.pkId
		WHERE deletes.NestLevel=@nestLevel-1
		AND RefIdValue NOT IN(SELECT Id FROM @deletes)
	END 
	DELETE @deletes FROM @deletes deletes
	INNER JOIN 
	(
		SELECT innerDelete.Id
		FROM @deletes as innerDelete
		INNER JOIN tblBigTableReference ON tblBigTableReference.RefIdValue=innerDelete.Id
		WHERE NOT EXISTS(SELECT * FROM @deletes deletes WHERE deletes.Id=tblBigTableReference.pkId)
	) ReferencedObjects ON deletes.ObjectPath LIKE '%/' + CAST(ReferencedObjects.Id AS VARCHAR) + '/%'
	WHERE @forceDelete = 0 OR deletes.NestLevel > 1
	-- Go through each big table and create sql to delete any rows associated with the item being deleted
	DECLARE @sql NVARCHAR(MAX) = ''
	DECLARE @tableName NVARCHAR(128)
	DECLARE tableNameCursor CURSOR READ_ONLY 
	
	FOR SELECT DISTINCT TableName FROM tblBigTableStoreConfig WHERE TableName IS NOT NULL				
	OPEN tableNameCursor
	FETCH NEXT FROM tableNameCursor INTO @tableName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @sql = @sql + 'DELETE t1 FROM ' + @tableName  +  ' t1 JOIN @deletes t2 ON t1.pkId = t2.Id;' + CHAR(13)
		FETCH NEXT FROM tableNameCursor INTO @tableName
	END
	CLOSE tableNameCursor
	DEALLOCATE tableNameCursor 			
	BEGIN TRAN
    DELETE t1 FROM tblBigTableReference t1 JOIN @deletes t2 ON t1.RefIdValue = t2.Id
    DELETE t1 FROM tblBigTableReference t1 JOIN @deletes t2 ON t1.pkId = t2.Id
    EXEC sp_executesql @sql, N'@deletes BigTableDeleteItemInternalTable READONLY',@deletes 
    DELETE t1 FROM tblBigTableIdentity t1 JOIN @deletes t2 ON t1.pkId = t2.Id	 
	COMMIT TRAN
END
