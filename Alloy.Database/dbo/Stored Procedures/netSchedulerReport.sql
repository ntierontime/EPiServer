CREATE PROCEDURE [dbo].[netSchedulerReport]
@ScheduledItemId	UNIQUEIDENTIFIER,
@Status INT,
@Text	NVARCHAR(2048) = null,
@utcnow DATETIME,
@MaxHistoryCount	INT = NULL
AS
BEGIN
	UPDATE tblScheduledItem SET LastExec = @utcnow,
								LastStatus = @Status,
								LastText = @Text
	FROM tblScheduledItem
	
	WHERE pkID = @ScheduledItemId
	INSERT INTO tblScheduledItemLog( fkScheduledItemId, [Exec], Status, [Text] ) VALUES(@ScheduledItemId,@utcnow,@Status,@Text)
	WHILE (SELECT COUNT(pkID) FROM tblScheduledItemLog WHERE fkScheduledItemId = @ScheduledItemId) > @MaxHistoryCount
	BEGIN
		DELETE tblScheduledItemLog FROM (SELECT TOP 1 * FROM tblScheduledItemLog WHERE fkScheduledItemId = @ScheduledItemId ORDER BY tblScheduledItemLog.pkID) AS T1
		WHERE tblScheduledItemLog.pkID = T1.pkID
	END	
END
