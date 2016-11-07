CREATE PROCEDURE [dbo].[netNotificationSubscriptionListSubscriptions]
	@UserName [nvarchar](50)
AS
BEGIN 
	SELECT [pkID], [UserName], [SubscriptionKey] FROM [dbo].[tblNotificationSubscription] WHERE Active = 1 AND UserName = @UserName
END
