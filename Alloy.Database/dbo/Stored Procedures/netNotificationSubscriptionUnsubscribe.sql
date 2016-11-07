CREATE PROCEDURE [dbo].[netNotificationSubscriptionUnsubscribe]
	@UserName [nvarchar](50),
	@SubscriptionKey [nvarchar](255)
AS
BEGIN
	DECLARE @SubscriptionCount INT = (SELECT COUNT(*) FROM [dbo].[tblNotificationSubscription] WHERE UserName = @UserName AND SubscriptionKey = @SubscriptionKey AND Active = 1)
	DECLARE @Result INT = CASE @SubscriptionCount WHEN 0 THEN 0 ELSE 1 END
	IF (@SubscriptionCount > 0)
		UPDATE [dbo].[tblNotificationSubscription] SET Active = 0 WHERE UserName = @UserName AND SubscriptionKey = @SubscriptionKey
	SELECT @Result
END
