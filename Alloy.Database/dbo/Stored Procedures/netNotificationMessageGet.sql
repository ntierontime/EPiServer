CREATE PROCEDURE [dbo].[netNotificationMessageGet]
	@Id	INT
AS
BEGIN
	SELECT
		pkID AS ID, Recipient, Sender, Channel, [Type], [Subject], Content, Sent, SendAt, Saved, [Read], Category
	FROM
		[tblNotificationMessage]
	WHERE pkID = @Id
END
