CREATE PROCEDURE [dbo].[netChangeLogTruncByRowsNDate]
(
	@RowsToTruncate BIGINT = NULL,
	@OlderThan DATETIME = NULL
)
AS
BEGIN	
	IF (@RowsToTruncate IS NOT NULL)
	BEGIN
		DELETE TOP(@RowsToTruncate) FROM [tblActivityLog] WHERE
		((@OlderThan IS NULL) OR (ChangeDate < @OlderThan))
		RETURN		
	END
	
	DELETE FROM [tblActivityLog] WHERE
	((@OlderThan IS NULL) OR (ChangeDate < @OlderThan))
	
END
