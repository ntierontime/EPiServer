CREATE PROCEDURE dbo.netSchedulerSetCurrentStatus 
	@pkID UNIQUEIDENTIFIER,
	@StatusMessage nvarchar(2048)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	UPDATE tblScheduledItem SET CurrentStatusMessage = @StatusMessage
	WHERE pkID = @pkID
END
