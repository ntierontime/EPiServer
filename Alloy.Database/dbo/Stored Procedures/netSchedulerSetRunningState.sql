CREATE PROCEDURE dbo.netSchedulerSetRunningState
	@pkID UNIQUEIDENTIFIER,
	@IsRunning bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    UPDATE tblScheduledItem SET IsRunning = @IsRunning, LastPing = GETUTCDATE(), CurrentStatusMessage = NULL WHERE pkID = @pkID
END
