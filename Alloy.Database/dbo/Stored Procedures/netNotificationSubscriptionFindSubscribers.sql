CREATE PROCEDURE [dbo].[netNotificationSubscriptionFindSubscribers]
	@SubscriptionKey [nvarchar](255),
	@Recursive BIT = 1
AS
BEGIN 
	IF (@Recursive = 1)	BEGIN
		DECLARE @key [nvarchar](257) = @SubscriptionKey + CASE SUBSTRING(@SubscriptionKey, LEN(@SubscriptionKey), 1) WHEN N'/' THEN N'%' ELSE N'/%' END
		SELECT [pkID], [UserName], [SubscriptionKey] FROM [dbo].[tblNotificationSubscription] WHERE Active = 1 AND (SubscriptionKey = @SubscriptionKey OR SubscriptionKey LIKE @key)
	END	ELSE BEGIN
		SELECT [pkID], [UserName], [SubscriptionKey] FROM [dbo].[tblNotificationSubscription] WHERE Active = 1 AND SubscriptionKey = @SubscriptionKey
	END
END
