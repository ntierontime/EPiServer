CREATE PROCEDURE [dbo].[netNotificationMessagesSent]
	@MessageIDs dbo.IDTable READONLY,
	@Sent DATETIME2
AS
BEGIN
	UPDATE M SET Sent = @Sent
	FROM [tblNotificationMessage] AS M INNER JOIN @MessageIDs AS IDS ON M.pkID = IDS.ID
END
