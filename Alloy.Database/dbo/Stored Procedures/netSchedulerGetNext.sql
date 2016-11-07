CREATE PROCEDURE dbo.netSchedulerGetNext
(
	@ID			UNIQUEIDENTIFIER OUTPUT,	-- returned id of new item to queue 
	@NextExec	DATETIME		 OUTPUT		-- returned nextExec of new item to queue
)
AS
BEGIN
	SET NOCOUNT ON
	SET @ID = NULL
	SET @NextExec = NULL
	SELECT TOP 1 @ID = tblScheduledItem.pkID, @NextExec = tblScheduledItem.NextExec
	FROM tblScheduledItem
	WHERE NextExec IS NOT NULL AND
		Enabled = 1
	ORDER BY NextExec ASC
END
