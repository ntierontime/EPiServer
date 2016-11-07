CREATE PROCEDURE dbo.netSoftLinksUpdateStatus
(
	@pkID int,
	@LastCheckedDate datetime,
	@FirstDateBroken datetime,
	@HttpStatusCode int,
	@LinkStatus int
)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE tblContentSoftlink SET
		LastCheckedDate = @LastCheckedDate,
		FirstDateBroken = @FirstDateBroken,
		HttpStatusCode = @HttpStatusCode,
		LinkStatus = @LinkStatus
	WHERE pkID = @pkID
END
