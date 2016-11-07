CREATE PROCEDURE [dbo].[netNotificationMessageGetForRecipients]
	@ScheduledBefore DATETIME2 = NULL,
	@Recipients dbo.StringParameterTable READONLY
AS
BEGIN
	SELECT
		pkID AS ID, Recipient, Sender, Channel, [Type], [Subject], Content, Sent, SendAt, Saved, [Read], Category
		FROM
			[tblNotificationMessage] AS M INNER JOIN @Recipients AS R ON M.Recipient = R.String
		WHERE
			Sent IS NULL AND
			(SendAt IS NULL OR
			(@ScheduledBefore IS NOT NULL AND SendAt IS NOT NULL AND @ScheduledBefore > SendAt))
					
		ORDER BY Recipient
END
