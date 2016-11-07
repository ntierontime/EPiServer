CREATE PROCEDURE [dbo].netSchedulerListLog
(
	@pkID UNIQUEIDENTIFIER
)
AS
BEGIN
	SELECT TOP 100 [Exec], Status, [Text]
	FROM tblScheduledItemLog
	WHERE fkScheduledItemId=@pkID
	ORDER BY [Exec] DESC
END
