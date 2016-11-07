CREATE PROCEDURE [dbo].[BigTableDeleteExcessReferences]
	@Id bigint,
	@PropertyName nvarchar(75),
	@StartIndex int
AS
BEGIN
BEGIN TRAN
	IF @StartIndex > -1
	BEGIN
		-- Creates temporary store with id's of references that has no other reference
		DECLARE @deletes AS BigTableDeleteItemInternalTable;
		
		INSERT INTO @deletes(Id, NestLevel, ObjectPath)
		SELECT DISTINCT R1.RefIdValue, 1, '/' + CAST(R1.RefIdValue AS VARCHAR) + '/' FROM tblBigTableReference AS R1
		LEFT OUTER JOIN tblBigTableReference AS R2 ON R1.RefIdValue = R2.pkId
		WHERE R1.pkId = @Id AND R1.PropertyName = @PropertyName AND R1.[Index] >= @StartIndex AND 
				R1.RefIdValue IS NOT NULL AND R2.RefIdValue IS NULL
		
		-- Remove reference on main store
		DELETE FROM tblBigTableReference WHERE pkId = @Id and PropertyName = @PropertyName and [Index] >= @StartIndex
		
		IF((select count(*) from @deletes) > 0)
		BEGIN
			EXEC sp_executesql N'BigTableDeleteItemInternal @deletes', N'@deletes BigTableDeleteItemInternalTable READONLY',@deletes 
		END
	END
	ELSE
		-- Remove reference on main store
		DELETE FROM tblBigTableReference WHERE pkId = @Id and PropertyName = @PropertyName and [Index] >= @StartIndex
COMMIT TRAN
END
