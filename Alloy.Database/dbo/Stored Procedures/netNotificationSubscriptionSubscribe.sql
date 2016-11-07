CREATE PROCEDURE [dbo].[netNotificationSubscriptionSubscribe]
	@UserName [nvarchar](50),
	@SubscriptionKey [nvarchar](255)
AS
BEGIN
	DECLARE @SubscriptionCount INT 
	SELECT @SubscriptionCount = COUNT(*) FROM [dbo].[tblNotificationSubscription] WHERE UserName = @UserName AND SubscriptionKey = @SubscriptionKey AND Active = 1
	IF (@SubscriptionCount > 0)
	BEGIN
		SELECT 0
		RETURN
	END
	SELECT @SubscriptionCount = COUNT(*) FROM [dbo].[tblNotificationSubscription] WHERE UserName = @UserName AND SubscriptionKey = @SubscriptionKey AND Active = 0
	IF (@SubscriptionCount > 0)
		UPDATE [dbo].[tblNotificationSubscription] SET Active = 1 WHERE UserName = @UserName AND SubscriptionKey = @SubscriptionKey
	ELSE 
		INSERT INTO [dbo].[tblNotificationSubscription](UserName, SubscriptionKey) VALUES (@UserName, @SubscriptionKey)	
	SELECT 1
END
