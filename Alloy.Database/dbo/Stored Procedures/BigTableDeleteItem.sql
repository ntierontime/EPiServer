CREATE PROCEDURE [dbo].[BigTableDeleteItem]
@StoreId BIGINT = NULL,
@ExternalId uniqueidentifier = NULL
AS
BEGIN
	IF @StoreId IS NULL
	BEGIN
		SELECT @StoreId = pkId FROM tblBigTableIdentity WHERE [Guid] = @ExternalId
	END
	IF @StoreId IS NULL RAISERROR(N'No object exists for the unique identifier passed', 1, 1)
	DECLARE @deletes AS BigTableDeleteItemInternalTable;
	INSERT INTO @deletes(Id, NestLevel, ObjectPath) VALUES(@StoreId, 1, '/' + CAST(@StoreId AS varchar) + '/')
	EXEC sp_executesql N'BigTableDeleteItemInternal @deletes', N'@deletes BigTableDeleteItemInternalTable READONLY',@deletes 
END
