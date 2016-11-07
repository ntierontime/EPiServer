CREATE PROCEDURE [dbo].[netNotificationMessagesRead]
	@MessageIDs dbo.IDTable READONLY,
	@Read DATETIME2
AS
BEGIN
	UPDATE M SET [Read] = @Read
	FROM [tblNotificationMessage] AS M INNER JOIN @MessageIDs AS IDS ON M.pkID = IDS.ID
END
