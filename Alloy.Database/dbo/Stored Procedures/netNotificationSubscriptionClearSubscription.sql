CREATE PROCEDURE [dbo].[netNotificationSubscriptionClearSubscription]
	@SubscriptionKey [nvarchar](255)
AS
BEGIN
	DELETE FROM [dbo].[tblNotificationSubscription] WHERE SubscriptionKey LIKE @SubscriptionKey + '%'
END
