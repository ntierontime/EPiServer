CREATE PROCEDURE [dbo].[netNotificationMessagesDelete]
	@MessageIDs dbo.IDTable READONLY
AS
BEGIN
	DELETE M
	FROM [tblNotificationMessage] AS M INNER JOIN @MessageIDs AS IDS ON M.pkID = IDS.ID
END
