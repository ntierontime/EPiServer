CREATE PROCEDURE [dbo].[netNotificationMessagesTruncate]
(	
	@OlderThan	DATETIME2,
	@MaxRows BIGINT = NULL
)
AS
BEGIN
	IF (@MaxRows IS NOT NULL)
	BEGIN
		DELETE TOP(@MaxRows) FROM [tblNotificationMessage]
		WHERE Saved < @OlderThan
	END
	ELSE
	BEGIN
		DELETE FROM [tblNotificationMessage] 
		WHERE Saved < @OlderThan
	END
	SELECT @@ROWCOUNT
END
