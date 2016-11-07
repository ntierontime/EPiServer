CREATE PROCEDURE [dbo].[netNotificationMessageGetRecipients]
	@Read BIT = NULL,
	@Sent BIT = NULL
AS 
BEGIN
	SELECT Distinct(Recipient) FROM tblNotificationMessage
	WHERE 
		(@Read IS NULL OR 
			((@Read = 1 AND [Read] IS NOT NULL) OR
			(@Read = 0 AND [Read] IS NULL)))
		AND
		(@Sent IS NULL OR 
			((@Sent = 1 AND [Sent] IS NOT NULL) OR
			(@Sent = 0 AND [Sent] IS NULL)))
END
